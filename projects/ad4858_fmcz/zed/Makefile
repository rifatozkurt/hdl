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
    ADI_HDL_DIR := $(realpath $(hdl_generic_location))
    export ADI_HDL_DIR=$(realpath $(hdl_generic_location))
  endif
endif

ifndef ADI_GHDL_DIR
  export ADI_GHDL_DIR=$(shell dirname $(shell dirname $(shell dirname $(shell pwd))))
endif

PROJECT_NAME := ad4858_fmcz_zed

M_DEPS += ../common/ad4858_fmcz_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/scripts/adi_pd.tcl
M_DEPS += ${ADI_HDL_DIR}/projects/common/zed/zed_system_constr.xdc
M_DEPS += ${ADI_HDL_DIR}/projects/common/zed/zed_system_bd.tcl
M_DEPS += ${ADI_HDL_DIR}/library/common/ad_iobuf.v

LIB_DEPS += axi_ad4858

LIB_DEPS += axi_clkgen
LIB_DEPS += axi_dmac
LIB_DEPS += axi_hdmi_tx
LIB_DEPS += util_i2c_mixer
LIB_DEPS += axi_i2s_adi
LIB_DEPS += axi_spdif_tx
LIB_DEPS += axi_sysid
LIB_DEPS += sysid_rom
LIB_DEPS += sysid_rom
LIB_DEPS += axi_pwm_gen
LIB_DEPS += util_pack/util_cpack2
LIB_DEPS += util_pack/util_upack2

include ${ADI_HDL_DIR}/projects/scripts/project-xilinx.mk
