## Generated SDC file "bcd_to_binary.sdc"

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

## DATE    "Tue Dec 26 12:26:16 2023"

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

create_clock -name clk_i -period 8 [get_ports {clk_i}]
create_clock -name clk_virt_i -period 8


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

set_input_delay -clock clk_virt_i -max 0.300 [get_ports {start_i}]
set_input_delay -clock clk_virt_i -min 0.250 [get_ports {start_i}]
set_input_delay -clock clk_virt_i -max 0.300 [get_ports {bcd1_i[*]}]
set_input_delay -clock clk_virt_i -min 0.250 [get_ports {bcd1_i[*]}]
set_input_delay -clock clk_virt_i -max 0.300 [get_ports {bcd2_i[*]}]
set_input_delay -clock clk_virt_i -min 0.250 [get_ports {bcd2_i[*]}]

#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock clk_virt_i -max 0.300 [get_ports {binary_o[*]}]
set_output_delay -clock clk_virt_i -min 0.250 [get_ports {binary_o[*]}]
set_output_delay -clock clk_virt_i -max 0.300 [get_ports {ready_o}]
set_output_delay -clock clk_virt_i -min 0.250 [get_ports {ready_o}]

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
set_location_assignment PIN_AJ19 -to bcd1_i[3]
set_location_assignment PIN_AK19 -to bcd1_i[2]
set_location_assignment PIN_AK18 -to bcd1_i[1]
set_location_assignment PIN_AK16 -to bcd1_i[0]
set_location_assignment PIN_Y18 -to bcd2_i[3]
set_location_assignment PIN_AD17 -to bcd2_i[2]
set_location_assignment PIN_Y17 -to bcd2_i[1]
set_location_assignment PIN_AC18 -to bcd2_i[0]
set_location_assignment PIN_AJ17 -to binary_o[0]
set_location_assignment PIN_AJ16 -to binary_o[1]
set_location_assignment PIN_AH18 -to binary_o[2]
set_location_assignment PIN_AH17 -to binary_o[3]
set_location_assignment PIN_AG16 -to binary_o[4]
set_location_assignment PIN_AE16 -to binary_o[5]
set_location_assignment PIN_AF16 -to binary_o[6]
set_location_assignment PIN_AG17 -to ready_o
set_location_assignment PIN_AB12 -to rst_i
set_location_assignment PIN_AC12 -to start_i