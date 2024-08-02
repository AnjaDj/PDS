## Generated SDC file "sequential_divider.sdc"

## Copyright (C) 2020  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 20.1.0 Build 711 06/05/2020 SJ Lite Edition"

## DATE    "Sun Dec 24 12:25:53 2023"

##
## DEVICE  "5CSEMA5F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name clk_i -period 20 [get_ports {clk_i}]
create_clock -name clk_virt -period 20

#**************************************************************
# Create Generated Clock
#**************************************************************



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

derive_clock_uncertainty


#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock clk_virt -min 0.550 [get_ports {start_i}]
set_input_delay -clock clk_virt -max 0.350 [get_ports {start_i}]
set_input_delay -clock clk_virt -min 1.000 [get_ports {a_i[*]}]
set_input_delay -clock clk_virt -max 1.200 [get_ports {a_i[*]}]
set_input_delay -clock clk_virt -min 1.000 [get_ports {b_i[*]}]
set_input_delay -clock clk_virt -max 1.200 [get_ports {b_i[*]}]



#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock clk_virt -max 0.550 [get_ports {q_o[*]}]
set_output_delay -clock clk_virt -min 0.350 [get_ports {q_o[*]}]
set_output_delay -clock clk_virt -max 0.550 [get_ports {r_o[*]}]
set_output_delay -clock clk_virt -min 0.350 [get_ports {r_o[*]}]
set_output_delay -clock clk_virt -max 0.550 [get_ports {ready_o}]
set_output_delay -clock clk_virt -min 0.350 [get_ports {ready_o}]


#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************

set_false_path -from [get_ports {rst_i}] -to [all_registers]

#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************


set_location_assignment PIN_AF14 -to clk_i
set_location_assignment PIN_AB12 -to rst_i
set_location_assignment PIN_AC12 -to start_i
set_location_assignment PIN_AC18 -to a_i[7]
set_location_assignment PIN_Y17 -to a_i[6]
set_location_assignment PIN_AD17 -to a_i[5]
set_location_assignment PIN_Y18 -to a_i[4]
set_location_assignment PIN_AK16 -to a_i[3]
set_location_assignment PIN_AK18 -to a_i[2]
set_location_assignment PIN_AK19 -to a_i[1]
set_location_assignment PIN_AJ19 -to a_i[0]
set_location_assignment PIN_AJ17 -to b_i[7]
set_location_assignment PIN_AJ16 -to b_i[6]
set_location_assignment PIN_AH18 -to b_i[5]
set_location_assignment PIN_AH17 -to b_i[4]
set_location_assignment PIN_AG16 -to b_i[3]
set_location_assignment PIN_AE16 -to b_i[2]
set_location_assignment PIN_AF16 -to b_i[1]
set_location_assignment PIN_AG17 -to b_i[0]
set_location_assignment PIN_AA18 -to q_o[7]
set_location_assignment PIN_AA19 -to q_o[6]
set_location_assignment PIN_AE17 -to q_o[5]
set_location_assignment PIN_AC20 -to q_o[4]
set_location_assignment PIN_AH19 -to q_o[3]
set_location_assignment PIN_AJ20 -to q_o[2]
set_location_assignment PIN_AH20 -to q_o[1]
set_location_assignment PIN_AK21 -to q_o[0]
set_location_assignment PIN_AD19 -to r_o[7]
set_location_assignment PIN_AD20 -to r_o[6]
set_location_assignment PIN_AE18 -to r_o[5]
set_location_assignment PIN_AE19 -to r_o[4]
set_location_assignment PIN_AF20 -to r_o[3]
set_location_assignment PIN_AF21 -to r_o[2]
set_location_assignment PIN_AF19 -to r_o[1]
set_location_assignment PIN_AG21 -to r_o[0]
set_location_assignment PIN_AF18 -to ready_o