
# cn0561 SPI configuration interface

set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS25} [get_ports cn0561_spi_sdi]       ; ## FMC_LPC_LA03_P
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS25} [get_ports cn0561_spi_sdo]       ; ## FMC_LPC_LA04_N
set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS25} [get_ports cn0561_spi_sclk]      ; ## FMC_LPC_LA01_CC_P
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS25} [get_ports cn0561_spi_cs]        ; ## FMC_LPC_LA05_P


# cn0561 data interface

set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS25} [get_ports cn0561_dclk]          ; ## FMC_LPC_CLK0_M2C_P
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS25} [get_ports cn0561_din[0]]        ; ## FMC_LPC_LA00_CC_N
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS25} [get_ports cn0561_din[1]]        ; ## FMC_LPC_LA06_N
set_property -dict {PACKAGE_PIN P17 IOSTANDARD LVCMOS25} [get_ports cn0561_din[2]]        ; ## FMC_LPC_LA02_P
set_property -dict {PACKAGE_PIN P18 IOSTANDARD LVCMOS25} [get_ports cn0561_din[3]]        ; ## FMC_LPC_LA02_N
set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS25} [get_ports cn0561_odr]           ; ## FMC_LPC_LA00_CC_P

# cn0561 GPIO lines

set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS25} [get_ports cn0561_resetn]        ; ## FMC_LPC_LA16_P
set_property -dict {PACKAGE_PIN T16 IOSTANDARD LVCMOS25} [get_ports cn0561_pdn]           ; ## FMC_LPC_LA07_P
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS25} [get_ports cn0561_mode]          ; ## FMC_LPC_LA04_P
set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio0]         ; ## FMC_LPC_LA10_P
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio1]         ; ## FMC_LPC_LA10_N
set_property -dict {PACKAGE_PIN N17 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio2]         ; ## FMC_LPC_LA11_P
set_property -dict {PACKAGE_PIN P20 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio4]         ; ## FMC_LPC_LA12_P
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio5]         ; ## FMC_LPC_LA12_N
set_property -dict {PACKAGE_PIN L17 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio6]         ; ## FMC_LPC_LA13_P
set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS25} [get_ports cn0561_gpio7]         ; ## FMC_LPC_LA13_N
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS25} [get_ports cn0561_pinbspi]       ; ## FMC_LPC_LA06_P

set_false_path -to [get_pins -hierarchical * -filter {NAME=~*busy_sync/inst/cdc_sync_stage1_reg[0]/D}]
