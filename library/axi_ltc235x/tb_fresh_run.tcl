relaunch_sim
restart
run 20 ns
add_force {/axi_ltc235x_tb/i_ltc235x/i_up_adc_common/up_resetn} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[0].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[1].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[2].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[3].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[4].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[5].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[6].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
add_force {/axi_ltc235x_tb/i_ltc235x/\regmap_channels[7].i_up_adc_channel /adc_enable} -radix hex {1 0ns}
run 20000 ns
