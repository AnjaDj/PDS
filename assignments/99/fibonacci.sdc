## Generated SDC file "fibonacci.sdc"

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

## DATE    "Wed Dec 20 17:46:42 2023"

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

create_clock -name clk -period 20.000 [get_ports {clk_i}]
create_clock -name clk_virt -period 20.000

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
set_input_delay -clock clk_virt -max 0.550 [get_ports {n_i[*]}]
set_input_delay -clock clk_virt -min 0.350 [get_ports {n_i[*]}]

#**************************************************************
# Set Output Delay
#**************************************************************

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
set_location_assignment PIN_AB12 -to n_i[0]
set_location_assignment PIN_AC12 -to n_i[1]
set_location_assignment PIN_AF9 -to n_i[2]
set_location_assignment PIN_AF10 -to n_i[3]
set_location_assignment PIN_AD11 -to n_i[4]
set_location_assignment PIN_AD12 -to n_i[5]
set_location_assignment PIN_AE11 -to rst_i
set_location_assignment PIN_AC9 -to start_i
set_location_assignment PIN_V16 -to ready_o
set_location_assignment PIN_AC18 -to r_o[0]
set_location_assignment PIN_Y17 -to r_o[1]
set_location_assignment PIN_AD17 -to r_o[2]
set_location_assignment PIN_Y18 -to r_o[3]
set_location_assignment PIN_AK16 -to r_o[4]
set_location_assignment PIN_AK18 -to r_o[5]
set_location_assignment PIN_AK19 -to r_o[6]
set_location_assignment PIN_AJ19 -to r_o[7]
set_location_assignment PIN_AJ17 -to r_o[8]
set_location_assignment PIN_AJ16 -to r_o[9]
set_location_assignment PIN_AH18 -to r_o[10]
set_location_assignment PIN_AH17 -to r_o[11]
set_location_assignment PIN_AG16 -to r_o[12]
set_location_assignment PIN_AE16 -to r_o[13]
set_location_assignment PIN_AF16 -to r_o[14]
set_location_assignment PIN_AG17 -to r_o[15]
set_location_assignment PIN_AA18 -to r_o[16]
set_location_assignment PIN_AA19 -to r_o[17]
set_location_assignment PIN_AE17 -to r_o[18]
set_location_assignment PIN_AC20 -to r_o[19]
set_location_assignment PIN_AH19 -to r_o[20]
set_location_assignment PIN_AJ20 -to r_o[21]
set_location_assignment PIN_AH20 -to r_o[22]
set_location_assignment PIN_AK21 -to r_o[23]
set_location_assignment PIN_AD19 -to r_o[24]
set_location_assignment PIN_AD20 -to r_o[25]
set_location_assignment PIN_AE18 -to r_o[26]
set_location_assignment PIN_AE19 -to r_o[27]
set_location_assignment PIN_AF20 -to r_o[28]
set_location_assignment PIN_AF21 -to r_o[29]
set_location_assignment PIN_AF19 -to r_o[30]
set_location_assignment PIN_AG21 -to r_o[31]
set_location_assignment PIN_AF18 -to r_o[32]
set_location_assignment PIN_AJ21 -to r_o[33]
set_location_assignment PIN_AB17 -to r_o[34]
set_location_assignment PIN_AA21 -to r_o[35]
set_location_assignment PIN_AB21 -to r_o[36]
set_location_assignment PIN_AC23 -to r_o[37]
set_location_assignment PIN_AD24 -to r_o[38]
set_location_assignment PIN_AE23 -to r_o[39]
set_location_assignment PIN_AE24 -to r_o[40]
set_location_assignment PIN_AF25 -to r_o[41]
set_location_assignment PIN_AF26 -to r_o[42]