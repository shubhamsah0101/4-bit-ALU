create_clock -name clk -period 12.0 [get_ports clk]

set_input_delay -clock clk 2.0 [get_ports {A[*] B[*] sel[*] rst}]

set_output_delay -clock clk 2.0 [get_ports {result[*] zero_flag overflow_flag div_by_zero_flag}]

set_false_path -from [get_ports rst]
