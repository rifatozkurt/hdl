source $ad_hdl_dir/projects/scripts/adi_pd.tcl
source $ad_hdl_dir/projects/common/de10nano/de10nano_system_qsys.tcl


if [info exists ad_project_dir] {
  source ../../common/cn0579_qsys.tcl
} else {
  source ../common/cn0579_qsys.tcl
}

set_instance_parameter_value sys_spi {clockPolarity} {0}

#system ID

set_instance_parameter_value axi_sysid_0 {ROM_ADDR_BITS} {9}
set_instance_parameter_value rom_sys_0 {ROM_ADDR_BITS} {9}

set_instance_parameter_value rom_sys_0 {PATH_TO_FILE} "[pwd]/mem_init_sys.txt"

sysid_gen_sys_init_file;
