####################################################################################
## Copyright (c) 2018 - 2021 Analog Devices, Inc.
### SPDX short identifier: BSD-1-Clause
## Auto-generated, do not modify!
####################################################################################

hdl_generic_location := $(wildcard ../../../../hdl)
ifndef ADI_HDL_DIR
  ifeq ($(hdl_generic_location),)
    $(error ADI_HDL_DIR is not defined! e.g. export ADI_HDL_DIR=/media/data/github/hdl)
  else
    ADI_HDL_DIR := $(hdl_generic_location)
    export ADI_HDL_DIR=$(hdl_generic_location)
    export ADI_GHDL_DIR=$(dirname $(dirname $(dirname $(pwd))))
  endif
endif

ifndef ADI_GHDL_DIR
  export ADI_GHDL_DIR=$(dirname $(dirname $(dirname $(pwd))))
endif


PROJECT_NAME := ad4858_fmcz_zcu102

M_DEPS += ../common/ad4858_fmcz_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/scripts/adi_pd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/common/zcu102/zcu102_system_constr.xdc
M_DEPS += ${ADI_HDL_DIR}/projects/common/zcu102/zcu102_system_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/library/common/ad_iobuf.v

LIB_GHDL_DEPS += axi_ad4858

LIB_DEPS += axi_pwm_gen
LIB_DEPS += axi_dmac
LIB_DEPS += axi_sysid
LIB_DEPS += sysid_rom
LIB_DEPS += util_pack/util_cpack2
LIB_DEPS += util_rfifo

include ${ADI_HDL_DIR}/projects/scripts/project-xilinx.mk
