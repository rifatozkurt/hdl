set script_dir [file dirname [info script]]

source "$script_dir/util_cdc_constr.tcl"

#send_message warning  "stie tata"
#send_message warning  "script_dir: $script_dir"

#util_cdc_sync_data_constr {*|sync_data:i_pwm_period_sync}
#util_cdc_sync_data_constr {*|sync_data:i_pwm_width_sync}
#util_cdc_sync_data_constr {*|sync_data:i_pwm_offset_sync}

#set_false_path -to [get_registers *axi_pwm_gen_regmap*cdc_sync_stage1*]
set_false_path -to [get_registers *axi_pwm_gen_regmap*cdc_sync_stage1*]
set_false_path -to [get_registers *axi_pwm_gen_regmap*sync_data*out_data*]
#set_false_path -to [get_registers *axi_pwm_gen_regmap*out_data*]

