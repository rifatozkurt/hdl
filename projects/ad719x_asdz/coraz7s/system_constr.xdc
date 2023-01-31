# coraz7s

# ad719x spi connections

# connect through the PMOD pins
set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {adc_spi_sclk_pmod}];      # IO_L7N_T1_34  Sch=ja_n[2]
set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {adc_spi_miso_rdyn_pmod}]; # IO_L7P_T1_34  Sch=ja_p[2]; AD719X sch=DOUT/RDY_N
set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {adc_spi_mosi_pmod}];      # IO_L17N_T2_34 Sch=ja_n[1]; AD719X sch=DIN
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {adc_spi_csn_pmod}];       # IO_L17P_T2_34 Sch=ja_p[1]

# connect through the IO pins
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {adc_spi_sclk_io}];        # IO_L19N_T3_VREF_35 Sch=ck_io[13]
set_property -dict {PACKAGE_PIN J18 IOSTANDARD LVCMOS33} [get_ports {adc_spi_miso_rdyn_io}];   # IO_L14P_T2_AD4P_SRCC_35 Sch=ck_io[12]
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {adc_spi_mosi_io}];        # IO_L12N_T1_MRCC_35 Sch=ck_io[11]
set_property -dict {PACKAGE_PIN U15 IOSTANDARD LVCMOS33} [get_ports {adc_spi_csn_io}];         # IO_L11N_T1_SRCC_34 Sch=ck_io[10]
