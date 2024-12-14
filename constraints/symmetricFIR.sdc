##########################
## Set deriving cells
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_4 [all_inputs]
 
# set the output load to BUFF
set_load -max [expr 1* {[load_of SV1T2/sky130_fd_sc_hd__ss_n40C_1v60/sky130_fd_sc_hd__dfxtp_4/D]}] [all_outputs]
#set_load -max 0.0106 [all_outputs]

# Set the clok freq
# required clock speed = 1000/5.0 = 200.00MHz 
create_clock -name fir_clk -period 5.0 -waveform {2.5 5.0} [get_ports clk_i]

set_clock_uncertainty -setup 0.2 [get_clocks fir_clk]
set_clock_uncertainty -hold 0.2 [get_clocks fir_clk]
set_clock_transition -max 0.2 [get_clocks fir_clk]
#report_timing -group fir_clk

# define false paths
#####set_false_path -from {clk_en} -to [all_registers]

# set_input_delay => synhronus paths, input port delay
set_input_delay -clock fir_clk -max 0.5 [all_inputs]
set_input_delay -clock fir_clk -min 0.2 [all_inputs]
remove_input_delay [get_ports clk_i] 

# Set output delay
set_output_delay -clock fir_clk -max 0.5 [all_outputs]


