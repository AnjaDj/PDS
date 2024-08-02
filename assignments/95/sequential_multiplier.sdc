## Generated SDC file "sequential_multiplier.sdc"

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

## DATE    "Thu Dec 28 18:04:54 2023"

##
## DEVICE  "5CSEMA6F31C6"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name clk -period 20 [get_ports {clk_i}]
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
set_input_delay -clock clk_virt -max 0.550 [get_ports {start_i}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {start_i}]
set_input_delay -clock clk_virt -max 0.550 [get_ports {a_i[*]}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {a_i[*]}]
set_input_delay -clock clk_virt -max 0.550 [get_ports {b_i[*]}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {b_i[*]}]


#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock clk_virt -max 0.550 [get_ports {c_o[*]}]
set_output_delay -clock clk_virt -min 0.350 [get_ports {c_o[*]}]
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
set_location_assignment PIN_AB12 -to a_i[7]
set_location_assignment PIN_AC12 -to a_i[6]
set_location_assignment PIN_AF9 -to a_i[5]
set_location_assignment PIN_AD10 -to a_i[4]
set_location_assignment PIN_AD11 -to a_i[3]
set_location_assignment PIN_AC9 -to a_i[2]
set_location_assignment PIN_AD12 -to a_i[1]
set_location_assignment PIN_AE11 -to a_i[0]
set_location_assignment PIN_AA14 -to b_i[7]
set_location_assignment PIN_AA15 -to b_i[6]
set_location_assignment PIN_W15 -to b_i[5]
set_location_assignment PIN_Y16 -to b_i[4]
set_location_assignment PIN_V16 -to b_i[3]
set_location_assignment PIN_V17 -to b_i[2]
set_location_assignment PIN_W16 -to b_i[1]
set_location_assignment PIN_V18 -to b_i[0]
set_location_assignment PIN_W17 -to c_o[15]
set_location_assignment PIN_W19 -to c_o[14]
set_location_assignment PIN_Y19 -to c_o[13]
set_location_assignment PIN_W20 -to c_o[12]
set_location_assignment PIN_W21 -to c_o[11]
set_location_assignment PIN_Y21 -to c_o[10]
set_location_assignment PIN_AE26 -to c_o[9]
set_location_assignment PIN_AE28 -to c_o[8]
set_location_assignment PIN_AG27 -to c_o[7]
set_location_assignment PIN_AF28 -to c_o[6]
set_location_assignment PIN_AG28 -to c_o[5]
set_location_assignment PIN_AH29 -to c_o[4]
set_location_assignment PIN_AJ29 -to c_o[3]
set_location_assignment PIN_AH30 -to c_o[2]
set_location_assignment PIN_AG30 -to c_o[1]
set_location_assignment PIN_AD29 -to c_o[0]
set_location_assignment PIN_AD30 -to clk_i
set_location_assignment PIN_AC27 -to ready_o
set_location_assignment PIN_AD25 -to rst_i
set_location_assignment PIN_AC25 -to start_i
