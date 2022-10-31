
source $ad_hdl_dir/projects/common/zed/zed_system_bd.tcl
source $ad_hdl_dir/projects/scripts/adi_pd.tcl

adi_project_files ad7134_fmc_zed [list \
  "$ad_hdl_dir/library/common/ad_edge_detect.v" \
  "$ad_hdl_dir/library/util_cdc/sync_bits.v" \
]

# specify ADC resolution -- the design supports 16/24/32 bit resolutions

set adc_resolution 24

# ADC number of channels

set adc_num_of_channels 8

#system ID
ad_ip_parameter axi_sysid_0 CONFIG.ROM_ADDR_BITS 9
ad_ip_parameter rom_sys_0 CONFIG.PATH_TO_FILE "[pwd]/mem_init_sys.txt"
ad_ip_parameter rom_sys_0 CONFIG.ROM_ADDR_BITS 9

set sys_cstring "ADC_RESOLUTION=$adc_resolution\
ADC_NUM_OF_CHANNELS=$adc_num_of_channels"
sysid_gen_sys_init_file $sys_cstring

source ../common/ad7134_bd.tcl
