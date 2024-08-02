-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "01/11/2024 11:18:05"
                                                            
-- Vhdl Test Bench template for design  :  sequential_multiplier
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;     
use ieee.numeric_std.all;                           

ENTITY sequential_multiplier_vhd_tst IS
END sequential_multiplier_vhd_tst;
ARCHITECTURE sequential_multiplier_arch OF sequential_multiplier_vhd_tst IS
-- constants         
constant T : time := 20 ns;                                        
-- signals                                                   
SIGNAL a_i : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL b_i : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL c_o : STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL clk_i : STD_LOGIC;
SIGNAL ready_o : STD_LOGIC;
SIGNAL rst_i : STD_LOGIC;
SIGNAL start_i : STD_LOGIC;
COMPONENT sequential_multiplier
	PORT (
	a_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	b_i : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
	c_o : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	clk_i : IN STD_LOGIC;
	ready_o : OUT STD_LOGIC;
	rst_i : IN STD_LOGIC;
	start_i : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : sequential_multiplier
	PORT MAP (
-- list connections between master ports and signals
	a_i => a_i,
	b_i => b_i,
	c_o => c_o,
	clk_i => clk_i,
	ready_o => ready_o,
	rst_i => rst_i,
	start_i => start_i
	);
init : PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once    
  for i in 1 to 1000000 loop
    clk_i <= '1';
    wait for T/2;
	 clk_i <= '0';
	 wait for T/2;
  end loop;
WAIT;                                                       
END PROCESS init;                                           
always : PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         
        -- code executes for every event on sensitivity list  
  start_i <= '1';
  rst_i <= '0';
  a_i <= "00000000";
  b_i <= "00000000";
  wait for T/2;
  for i in 0 to 255 loop
    for j in 0 to 255 loop
	   rst_i <= '0';
	   a_i <= std_logic_vector(to_unsigned(i, 8));
		b_i <= std_logic_vector(to_unsigned(j, 8));
		wait for 5 * T;
		assert(ready_o = '0') report "Error ready signal; Expected: '0', Actual: '1';" severity failure;
		wait for 5 * T;
		assert(c_o = std_logic_vector(to_unsigned(i * j, 16))) report "Error; Expected: " & integer'image(i * j) & "; Actual: " & integer'image(to_integer(unsigned(c_o))) & ";" severity failure;
      assert(ready_o = '1') report "Error ready signal; Expected: '1', Actual: '0';" severity failure;
		report "Successful assertion; c_o = " & integer'image(to_integer(unsigned(c_o))) & "; ready_o = '1';";
		rst_i <= '1';
		wait for T;
		assert(c_o = "0000000000000000") report "Reset error; Expected: 0" & "; Actual: " & integer'image(to_integer(unsigned(c_o))) & ";" severity failure;
		wait for 1.5 * T;
	 end loop;
  end loop;
WAIT;                                                        
END PROCESS always;                                          
END sequential_multiplier_arch;
