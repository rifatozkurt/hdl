
create_bd_intf_port -mode Master -vlnv analog.com:interface:spi_master_rtl:1.0 ad713x_di
create_bd_port -dir O ad713x_odr
create_bd_port -dir O ad713x_sdpclk

# create a SPI Engine architecture for the parallel data interface of AD713x
# this design supports AD7132/AD7134/AD7136

source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

if {$adc_resolution == 16 || $adc_resolution == 24} {
  set data_width 32
} elseif {$adc_resolution == 32} {
  set data_width 64
};

set async_spi_clk 1
set num_cs        1
set num_sdi       $adc_num_of_channels
set num_sdo       0
set sdi_delay     0
set echo_sclk     0

set hier_spi_engine dual_ad7134

spi_engine_create $hier_spi_engine $data_width $async_spi_clk $num_cs $num_sdi $num_sdo $sdi_delay $echo_sclk

# clkgen

ad_ip_instance axi_clkgen axi_ad7134_clkgen
ad_ip_parameter axi_ad7134_clkgen CONFIG.VCO_DIV 5
ad_ip_parameter axi_ad7134_clkgen CONFIG.VCO_MUL 48
ad_ip_parameter axi_ad7134_clkgen CONFIG.CLK0_DIV 10

# dma to receive data stream

ad_ip_instance axi_dmac axi_ad7134_dma
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_TYPE_SRC 1
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_TYPE_DEST 0
ad_ip_parameter axi_ad7134_dma CONFIG.CYCLIC 0
ad_ip_parameter axi_ad7134_dma CONFIG.SYNC_TRANSFER_START 0
ad_ip_parameter axi_ad7134_dma CONFIG.AXI_SLICE_SRC 0
ad_ip_parameter axi_ad7134_dma CONFIG.AXI_SLICE_DEST 1
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_2D_TRANSFER 0
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_DATA_WIDTH_SRC [expr $data_width * $adc_num_of_channels]
ad_ip_parameter axi_ad7134_dma CONFIG.DMA_DATA_WIDTH_DEST 128

# odr generator

ad_ip_instance axi_pwm_gen odr_generator
ad_ip_parameter odr_generator CONFIG.N_PWMS 1
ad_ip_parameter odr_generator CONFIG.PULSE_0_PERIOD 10000
ad_ip_parameter odr_generator CONFIG.PULSE_0_WIDTH 4
ad_ip_parameter odr_generator CONFIG.ASYNC_CLK_EN 0

create_bd_cell -type module -reference sync_bits busy_sync
create_bd_cell -type module -reference ad_edge_detect busy_capture
set_property -dict [list CONFIG.EDGE 1] [get_bd_cells busy_capture]

ad_connect odr_generator/pwm_0 ad713x_odr

ad_connect axi_ad7134_clkgen/clk_0 busy_capture/clk
ad_connect axi_ad7134_clkgen/clk_0 busy_sync/out_clk
ad_connect busy_capture/rst GND
ad_connect  $hier_spi_engine/${hier_spi_engine}_axi_regmap/spi_resetn busy_sync/out_resetn

ad_connect ad713x_odr busy_sync/in_bits
ad_connect busy_sync/out_bits busy_capture/signal_in
ad_connect busy_capture/signal_out $hier_spi_engine/trigger

# sdpclk clock generator - default clk0_out is 50 MHz

ad_ip_instance axi_clkgen axi_sdp_clkgen
ad_ip_parameter axi_sdp_clkgen CONFIG.CLKIN_PERIOD 10
ad_ip_parameter axi_sdp_clkgen CONFIG.VCO_MUL 12
ad_ip_parameter axi_sdp_clkgen CONFIG.VCO_DIV 2
ad_ip_parameter axi_sdp_clkgen CONFIG.CLK0_DIV 12

ad_connect  axi_ad7134_clkgen/clk_0 $hier_spi_engine/spi_clk
ad_connect  $sys_cpu_clk axi_ad7134_clkgen/clk 
ad_connect  $sys_cpu_clk $hier_spi_engine/clk
ad_connect  axi_ad7134_clkgen/clk_0 axi_ad7134_dma/s_axis_aclk
ad_connect  $sys_cpu_clk axi_sdp_clkgen/clk
ad_connect  sys_cpu_resetn $hier_spi_engine/resetn
ad_connect  sys_cpu_resetn axi_ad7134_dma/m_dest_axi_aresetn

ad_connect  $hier_spi_engine/m_spi ad713x_di
ad_connect  axi_ad7134_dma/s_axis $hier_spi_engine/M_AXIS_SAMPLE
ad_connect  ad713x_sdpclk axi_sdp_clkgen/clk_0

ad_cpu_interconnect 0x44a00000 $hier_spi_engine/${hier_spi_engine}_axi_regmap
ad_cpu_interconnect 0x44a30000 axi_ad7134_dma
ad_cpu_interconnect 0x44a40000 axi_sdp_clkgen
ad_cpu_interconnect 0x44b00000 odr_generator
ad_cpu_interconnect 0x44b10000 axi_ad7134_clkgen

ad_cpu_interrupt "ps-13" "mb-13" axi_ad7134_dma/irq
ad_cpu_interrupt "ps-12" "mb-12" $hier_spi_engine/irq

ad_mem_hp2_interconnect sys_cpu_clk sys_ps7/S_AXI_HP2
ad_mem_hp2_interconnect sys_cpu_clk axi_ad7134_dma/m_dest_axi

