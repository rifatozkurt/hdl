# ip

source ../../scripts/adi_env.tcl

source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

global VIVADO_IP_LIBRARY

adi_ip_create axi_ad4858
    create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name channel_ila
    set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_NUM_OF_PROBES {10}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_DATA_DEPTH {1024}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_TRIGIN_EN {false}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_ADV_TRIGGER {true}] [get_ips channel_ila]
    set_property -dict [list CONFIG.ALL_PROBE_SAME_MU_CNT {2}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE0_WIDTH {1}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE4_WIDTH {32}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE5_WIDTH {32}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE6_WIDTH {24}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE7_WIDTH {32}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] [get_ips channel_ila]
    set_property -dict [list CONFIG.C_PROBE9_WIDTH {7}] [get_ips channel_ila]
    generate_target {all} [get_files axi_ad4858.srcs/sources_1/ip/channel_ila/channel_ila.xci]

    create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name cmos_if_ila
    set_property -dict [list CONFIG.C_MONITOR_TYPE {Native}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_NUM_OF_PROBES {18}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_DATA_DEPTH {1024}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_TRIGIN_EN {false}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_EN_STRG_QUAL {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_ADV_TRIGGER {true}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.ALL_PROBE_SAME_MU_CNT {2}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE0_WIDTH {6}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE1_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE2_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE3_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE4_WIDTH {6}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE5_WIDTH {32}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE6_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE7_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE8_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE9_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE10_WIDTH {32}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE11_WIDTH {32}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE12_WIDTH {32}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE13_WIDTH {32}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE14_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE15_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE16_WIDTH {1}] [get_ips cmos_if_ila]
    set_property -dict [list CONFIG.C_PROBE17_WIDTH {8}] [get_ips cmos_if_ila]
    generate_target {all} [get_files axi_ad4858.srcs/sources_1/ip/cmos_if_ila/cmos_if_ila.xci]


adi_ip_files axi_ad4858 [list \
    "$ad_hdl_dir/library/common/ad_edge_detect.v" \
    "$ad_hdl_dir/library/common/ad_datafmt.v" \
    "$ad_hdl_dir/library/common/up_axi.v" \
    "$ad_hdl_dir/library/common/ad_rst.v" \
    "$ad_hdl_dir/library/common/up_adc_common.v" \
    "$ad_hdl_dir/library/common/up_adc_channel.v" \
    "$ad_hdl_dir/library/common/up_xfer_cntrl.v" \
    "$ad_hdl_dir/library/common/up_xfer_status.v" \
    "$ad_hdl_dir/library/common/up_clock_mon.v" \
    "$ad_hdl_dir/library/common/up_delay_cntrl.v" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_cntrl_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_rst_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_xfer_status_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/up_clock_mon_constr.xdc" \
    "$ad_hdl_dir/library/xilinx/common/ad_serdes_in.v" \
    "$ad_hdl_dir/library/xilinx/common/ad_serdes_out.v" \
    "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
    "$ad_hdl_dir/library/util_cdc/sync_event.v" \
    "axi_ad4858_tb.v" \
    "axi_ad4858_cmos.v" \
    "axi_ad4858_channel.v" \
    "axi_ad4858_lvds.v" \
    "axi_ad4858.v" ]

adi_ip_properties axi_ad4858

set cc [ipx::current_core]

## Customize XGUI layout

set page0 [ipgui::get_pagespec -name "Page 0" -component $cc]

adi_init_bd_tcl
adi_ip_bd axi_ad4858 "bd/bd.tcl"

set_property company_url {https://wiki.analog.com/resources/fpga/docs/axi_ad4858} [ipx::current_core]

ipgui::add_param -name "EXTERNAL_CLK" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "EXTERNAL_CLK_EN" \
  "tooltip" "External clock for interface logic, must be 2x faster than IF clk" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "EXTERNAL_CLK" -component $cc]

ipgui::add_param -name "ECHO_CLK_EN" -component $cc -parent $page0
set_property -dict [list \
  "display_name" "Echoed clock enabled" \
  "widget" "checkBox" \
] [ipgui::get_guiparamspec -name "ECHO_CLK_EN" -component $cc]

ipgui::add_param -name "LVDS_CMOS_N" -component $cc -parent $page0
set_property -dict [list \
	"value_validation_type" "pairs" \
	"value_validation_pairs" { \
		"CMOS" "0" \
		"LVDS" "1" \
	} \
] [ipx::get_user_parameters "LVDS_CMOS_N" -of_objects $cc]

set_property -dict [list \
	"display_name" "Interface type" \
	"widget" "comboBox" \
] [ipx::get_user_parameters "LVDS_CMOS_N" -of_objects $cc]

for {set i 0} {$i < 8} {incr i} {
  ipgui::add_param -name "LANE_${i}_ENABLE" -component $cc -parent $page0
  set_property -dict [list \
    "display_name" "LANE_${i}_ENABLE" \
    "tooltip" "Lane $i is used" \
    "widget" "checkBox" \
  ] [ipgui::get_guiparamspec -name "LANE_${i}_ENABLE" -component $cc]

  set_property value true [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects [ipx::current_core]]
  set_property value true [ipx::get_hdl_parameters LANE_${i}_ENABLE -of_objects [ipx::current_core]]
  set_property enablement_tcl_expr {expr $LVDS_CMOS_N == 0} [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects [ipx::current_core]]
  set_property value_format bool [ipx::get_user_parameters LANE_${i}_ENABLE -of_objects [ipx::current_core]]
  set_property value_format bool [ipx::get_hdl_parameters LANE_${i}_ENABLE -of_objects [ipx::current_core]]

  adi_set_ports_dependency "lane_$i" \
    "(spirit:decode(id('MODELPARAM_VALUE.LANE_${i}_ENABLE')) == 1)"

  adi_set_ports_dependency "lane_$i" \
    "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0)"

  set_property DRIVER_VALUE "0" [ipx::get_ports lane_$i]
}

# CMOS dependency
adi_set_ports_dependency "scki" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0)"
adi_set_ports_dependency "scko" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 0) and \
   (spirit:decode(id('MODELPARAM_VALUE.ECHO_CLK_EN')) = 1)"

# LVDS dependency
adi_set_ports_dependency "scki_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"
adi_set_ports_dependency "scki_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"

adi_set_ports_dependency "scko_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.ECHO_CLK_EN')) = 1)"
adi_set_ports_dependency "scko_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1) and \
   (spirit:decode(id('MODELPARAM_VALUE.ECHO_CLK_EN')) = 1)"

adi_set_ports_dependency "sdo_p" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"
adi_set_ports_dependency "sdo_n" \
  "(spirit:decode(id('MODELPARAM_VALUE.LVDS_CMOS_N')) == 1)"

adi_set_ports_dependency "external_clk" \
  "(spirit:decode(id('MODELPARAM_VALUE.EXTERNAL_CLK')) = 1)" 0

set_property driver_value 0 [ipx::get_ports -filter "direction==in" -of_objects $cc]

# UNCOMENT when entering hdl repo
adi_add_auto_fpga_spec_params

## Save the modifications

ipx::create_xgui_files $cc

ipx::save_core [ipx::current_core]
