// ***************************************************************************
// ***************************************************************************
// Copyright 2014 - 2017 (c) Analog Devices, Inc. All rights reserved.
//
// In this HDL repository, there are many different and unique modules, consisting
// of various HDL (Verilog or VHDL) components. The individual modules are
// developed independently, and may be accompanied by separate and unique license
// terms.
//
// The user should read each of these license terms, and understand the
// freedoms and responsibilities that he or she has by using this source/core.
//
// This core is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
// A PARTICULAR PURPOSE.
//
// Redistribution and use of source or resulting binaries, with or without modification
// of this file, are permitted under one of the following two license terms:
//
//   1. The GNU General Public License version 2 as published by the
//      Free Software Foundation, which can be found in the top level directory
//      of this repository (LICENSE_GPL2), and also online at:
//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
//
// OR
//
//   2. An ADI specific BSD license, which can be found in the top level directory
//      of this repository (LICENSE_ADIBSD), and also on-line at:
//      https://github.com/analogdevicesinc/hdl/blob/master/LICENSE_ADIBSD
//      This will allow to generate bit files and not release the source code,
//      as long as it attaches to an ADI device.
//
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_ad4858_lvds #(

  parameter       ILA_DEBUG = 1,
  parameter FPGA_TECHNOLOGY = 0,
  parameter IODELAY_GROUP = "dev_if_delay_group",
  parameter NEG_EDGE = 1
) (

  input                   rst,
  input                   clk,
  input                   fast_clk,
  input        [ 7:0]     adc_enable,
  input                   adc_crc_enable,

  // this is not required after the software will change the phase pf the
  // serial and paralel clocks at runtime
  /////
  input        [ 3:0]     delayed_bits,
  input        [ 3:0]     order,
  input        [ 3:0]     ch_index_delay,
  input        [ 3:0]     total_delay,
  /////



  // physical interface

  output                  scki_p,
  output                  scki_n,
  input                   scko_p,
  input                   scko_n,
  input                   sdo_p,
  input                   sdo_n,
  input                   busy,
  input                   cnvs,

  // format

  input       [ 1:0]      packet_format,
  input                   oversampling_en,

  // channel interface

  output     [255:0]      adc_data,
  output  reg             adc_valid,

  // delay interface (for IDELAY macros)
  input                   up_clk,
  input       [ 1:0]      up_adc_dld,
  input       [ 9:0]      up_adc_dwdata,
  output      [ 9:0]      up_adc_drdata,
  input                   delay_clk,
  input                   delay_rst,
  output                  delay_locked);

  localparam  SEVEN_SERIES = 1;
  localparam  ULTRASCALE = 2;
  localparam  ULTRASCALE_PLUS = 3;

  localparam DW = 32;
  localparam BW = DW - 1;

  // internal registers

  reg         [BW:0]  rx_data = 'h0;
  reg         [ 5:0]  data_counter_m2 = 'h0;
  reg         [ 5:0]  data_counter_m1 = 'h0;
  reg         [ 5:0]  data_counter = 'h0;
  reg         [ 3:0]  ch_counter = 'h0;
  reg                 new_data = 1'b0;

  reg                 scki_i;
  reg                 scki_d;

  reg                 busy_m1;
  reg                 busy_m2;
  reg                 cnvs_d;
  reg         [31:0]  period_cnt;

  reg                 conversion_quiet_time;
  reg                 run_busy_period_cnt;
  reg         [31:0]  busy_conversion_cnt;
  reg         [31:0]  busy_measure_value;
  reg                 busy_measure_valid;
  reg                 ch_valid;

  reg         [31:0]  adc_data_store[8:0];
  reg                 aquire_data;
  reg         [ 3:0]  if_data_d;
  reg         [ 3:0]  if_data_d_bits;
  reg                 clk_data_reduced;
  reg                 start_transfer;

  // internal wires

  wire        [ 8:0]  bursts = 24*8-1;
  wire        [ 3:0]  if_data;
  wire        [ 3:0]  clk_data;
  wire        [ 7:0]  double_if_data_d;
  wire        [ 3:0]  if_data_reoder;
  wire        [15:0]  crc_data;
  wire                conversion_completed;
  wire                conversion_quiet_time_s;
  wire        [ 5:0]  packet_lenght;
  wire        [ 3:0]  max_channel_transfer;


  reg  [15:0]  ch_index_dynamic_delay[3:0];
  reg  [15:0]  valid_dynamic_delay;

  wire [ 3:0]  ch_index_dn;
  wire         ch_valid_dn;

////////////////////////////////////////////////////////////////////
// DEBUG
    // instantiate the ILA core inside of a module in the IP (don't need to be the top module)

    generate
      if (ILA_DEBUG) begin
        lvds_if_ila i_ila (
          .clk(clk),
          .probe0(packet_lenght),
          .probe1(busy),
          .probe2(start_transfer),
          .probe3(aquire_data),
          .probe4(clk_data_reduced),
          .probe5(busy_measure_value),
          .probe6(conversion_quiet_time_s),
          .probe7(conversion_completed),
          .probe8(clk_data),
          .probe9(if_data),
          .probe10(ch_index_dn[3:0]),
          .probe11(ch_valid_dn),
          .probe12(adc_data_store[0]),
          .probe13(adc_data_store[7]),
          .probe14(adc_valid),
          .probe15(oversampling_en),
          .probe16(adc_crc_enable),
          .probe17(ch_counter),
          .probe18(max_channel_transfer),
          .probe19(data_counter),
          .probe20(adc_enable),
          .probe21(ch_valid),
          .probe22(valid_dynamic_delay)
        );
      end
    endgenerate

////////////////////////////////////////////////////////////////////


  // packet format selection (-4 becuse of the serdes factor)

  assign packet_lenght = packet_format == 2'd0 ? 6'd20 - 6'd4 :
                         packet_format == 2'd1 ? 6'd24 - 6'd4 :
                         packet_format == 2'd2 ? 6'd32 - 6'd4 : 6'd32 - 6'd4;

  assign max_channel_transfer = oversampling_en ? 8 : 7;

  // instantiations

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      busy_m1 <= 1'b0;
      busy_m2 <= 1'b0;
      start_transfer <= 1'b0;
    end else begin
      busy_m1 <= busy;
      busy_m2 <= busy_m1;
      start_transfer <= busy_m2 & !busy_m1;
    end
  end

  // busy period counter
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      run_busy_period_cnt <= 1'b0;
      busy_conversion_cnt <= 'd0;
      busy_measure_value <= 'd0;
      busy_measure_valid <= 1'b0;
    end else begin
      if (cnvs == 1'b1 && busy_m2 == 1'b1) begin
        run_busy_period_cnt <= 1'b1;
      end else if (start_transfer == 1'b1) begin
        run_busy_period_cnt <= 1'b0;
      end

      if (adc_cnvs_redge == 1'b1) begin
        busy_conversion_cnt <= 'd0;
      end else if (start_transfer == 1'b1) begin
        busy_measure_value <= busy_conversion_cnt;
        busy_measure_valid <= 1'b1;
      end else if (run_busy_period_cnt == 1'b1) begin
        busy_conversion_cnt <= busy_conversion_cnt + 'd1;
      end
    end
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      period_cnt <= 'd0;
      cnvs_d <= 'd0;
      conversion_quiet_time <= 1'b0;
    end else begin
      cnvs_d <= cnvs;
      if (oversampling_en == 1 && adc_cnvs_redge == 1'b1) begin
        conversion_quiet_time <= 1'b1;
      end else begin
        conversion_quiet_time <= conversion_quiet_time & ~conversion_completed;
      end
      if (adc_cnvs_redge == 1'b1) begin
        period_cnt <= 'd0;
      end else begin
        period_cnt <= period_cnt + 1;
      end
    end
  end

  assign conversion_quiet_time_s = (oversampling_en == 1) ? conversion_quiet_time | cnvs : 1'b0;
  assign conversion_completed = (period_cnt == busy_measure_value) ? 1'b1 : 1'b0;
  assign adc_cnvs_redge = ~cnvs_d & cnvs;

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      data_counter <= 2'h0;
      ch_counter <= 4'h0;
      ch_valid <= 1'b0;
      aquire_data <= 1'b0;
    end else begin
      if (aquire_data == 1'b0 || data_counter == packet_lenght) begin
        data_counter <= 2'h0;
      end else begin
        data_counter <= data_counter + 4;
      end

      if (start_transfer == 1'b1) begin
        ch_counter <= 4'h0;
        ch_valid <= 1'b0;
      end else begin
        if (data_counter == packet_lenght) begin
          if (ch_counter == max_channel_transfer) begin
            ch_counter <= 4'h0;
            ch_valid <= 1'b1;
          end else begin
            ch_counter <= ch_counter + 1;
            ch_valid <= 1'b1;
          end
        end else begin
          ch_counter <= ch_counter;
          ch_valid <= 1'b0;
        end
      end

      if (data_counter == packet_lenght && ch_counter == max_channel_transfer) begin
        aquire_data <= 1'b0;
      end else if (aquire_data || start_transfer) begin
        aquire_data <= ~conversion_quiet_time_s;
      end
    end
  end

  // because the fast clocks used by the iserdes is not the echoed clock, but
  // the clock used to generate the echoed one, bits from a frame might end up
  // in separate frames delimited by div_clk due to phase differences.
  always @(posedge clk) begin
    if_data_d <= if_data;
    clk_data_reduced <= |clk_data;

    if_data_d_bits[0] <= delayed_bits[0] ? if_data[0] : if_data_d[0];
    if_data_d_bits[1] <= delayed_bits[1] ? if_data[1] : if_data_d[1];
    if_data_d_bits[2] <= delayed_bits[2] ? if_data[2] : if_data_d[2];
    if_data_d_bits[3] <= delayed_bits[3] ? if_data[3] : if_data_d[3];
  end


  genvar i;
  generate
    // dynamic ch index delay (1 to 16)
    for (i = 0 ; i <= 3; i = i + 1) begin
      always @(posedge clk) begin
        ch_index_dynamic_delay[i] <= {ch_index_dynamic_delay[i][14:0], ch_counter[i]};
      end
      assign ch_index_dn[i] = ch_index_dynamic_delay[i][ch_index_delay];
    end
  endgenerate

  // dynamic valid delay (0 to 15)
  always @(posedge clk) begin
    valid_dynamic_delay <= {valid_dynamic_delay[14:0], ch_valid};
  end
  assign ch_valid_dn = valid_dynamic_delay[total_delay[3:0]];

  // because the data is not source synchronous with the fast and divided
  // clocks used by the iserdes, bit arrangement might not be correct.
  assign double_if_data_d = {if_data_d_bits, if_data_d_bits};
  assign if_data_reoder = double_if_data_d[order+3-:4];

  always @(posedge clk) begin
    rx_data <= {rx_data[BW-4:0], if_data_reoder};
  end

  // ch_counter_d clock domain crossing constraints
  always @(posedge clk) begin
    if (ch_valid_dn == 1'b1) begin
      adc_data_store[ch_index_dn] <= rx_data;
    end
    adc_valid <= (ch_valid_dn == 1'b1 && ch_index_dn == max_channel_transfer) ? 1'b1 : 1'b0;
  end

  //assign dev_statuts = adc_data_store[8][23:16];
  //assign dev_statuts = adc_data_store[8][31:24];
  assign crc_data = adc_data_store[8][15:0];
  assign adc_data = {adc_data_store[7],
                     adc_data_store[6],
                     adc_data_store[5],
                     adc_data_store[4],
                     adc_data_store[3],
                     adc_data_store[2],
                     adc_data_store[1],
                     adc_data_store[0]};

  // use the echoed clock signal for framing
  ad_serdes_in #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N(1'b1),
    .DATA_WIDTH(1),
    .IODELAY_CTRL (0),
    .SERDES_FACTOR(4)
  ) i_adc_clk_data (
    .rst(rst),
    .clk(fast_clk),
    .div_clk(clk),
    .data_s0(clk_data[3]),
    .data_s1(clk_data[2]),
    .data_s2(clk_data[1]),
    .data_s3(clk_data[0]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(scko_p),
    .data_in_n(scko_n),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[0]),
    .up_dwdata (up_adc_dwdata[4:0]),
    .up_drdata (up_adc_drdata[4:0]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked());

  ad_serdes_in #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N(1'b1),
    .DATA_WIDTH(1),
    .IODELAY_CTRL (1),
    .SERDES_FACTOR(4)
  ) i_adc_data (
    .rst(rst),
    .clk(fast_clk),
    .div_clk(clk),
    .data_s0(if_data[0]),
    .data_s1(if_data[1]),
    .data_s2(if_data[2]),
    .data_s3(if_data[3]),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_in_p(sdo_p),
    .data_in_n(sdo_n),
    .up_clk (up_clk),
    .up_dld (up_adc_dld[1]),
    .up_dwdata (up_adc_dwdata[9:5]),
    .up_drdata (up_adc_drdata[9:5]),
    .delay_clk(delay_clk),
    .delay_rst(delay_rst),
    .delay_locked(delay_locked));

  ad_serdes_out #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .DDR_OR_SDR_N(1'b1),
    .DATA_WIDTH(1),
    .SERDES_FACTOR(4)
  ) i_scki_out (
    .rst(rst),
    .clk(fast_clk),
    .div_clk(clk),
    .data_oe(1'b1),
    .data_s0(1'b0),
    .data_s1(aquire_data),
    .data_s2(1'b0),
    .data_s3(aquire_data),
    .data_s4(),
    .data_s5(),
    .data_s6(),
    .data_s7(),
    .data_out_p(scki_p),
    .data_out_n(scki_n));

endmodule
