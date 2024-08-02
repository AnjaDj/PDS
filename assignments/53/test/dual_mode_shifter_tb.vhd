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
-- Generated on "11/14/2023 17:48:37"
                                                            
-- Vhdl Test Bench template for design  :  dual_mode_shifter
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

library ieee;                                               
use ieee.std_logic_1164.all;  
use ieee.numeric_std.all;                              

entity dual_mode_shifter_vhd_tst is
end dual_mode_shifter_vhd_tst;
architecture dual_mode_shifter_arch of dual_mode_shifter_vhd_tst is
-- constants                                                 
-- signals                                                   
signal MODE_i : std_logic;
signal SH_IN_i : std_logic_vector(15 downto 0);
signal SH_OUT_o : std_logic_vector(15 downto 0);
component dual_mode_shifter
	port(
	MODE_i : in std_logic;
	SH_IN_i : in std_logic_vector(15 downto 0);
	SH_OUT_o : out std_logic_vector(15 downto 0)
	);
end component;
begin
	i1 : dual_mode_shifter
	port map(
	  MODE_i => MODE_i,
	  SH_IN_i => SH_IN_i,
	  SH_OUT_o => SH_OUT_o
	);                                           
always : process  
begin                                              
SH_IN_i <= (others => '0');   
MODE_i <= '0';                                                             
  for i in 0 to (2 ** 16) loop
    SH_IN_i <= std_logic_vector(to_unsigned(i, 16));
	 wait for 10 ns;
	 assert SH_OUT_o = (SH_IN_i(0) & SH_IN_i(15 downto 1)) report "Expected " & integer'image(to_integer(unsigned(SH_IN_i(0) & SH_IN_i(15 downto 1)))) & "; Number: " & integer'image(to_integer(unsigned(SH_OUT_o))) severity error;
  end loop;
  MODE_i <= '1';
  for i in 0 to (2 ** 16) loop
    SH_IN_i <= std_logic_vector(to_unsigned(i, 16));
	 wait for 10 ns;
	 assert (SH_OUT_o = (SH_IN_i(14 downto 0) & SH_IN_i(15))) report "Expected " & integer'image(to_integer(unsigned(SH_IN_i(14 downto 0) & SH_IN_i(15)))) & "; Number: " & integer'image(to_integer(unsigned(SH_OUT_o))) severity error;
  end loop;
  report "Test completed.";
wait;                                                        
end process always;                                          
end dual_mode_shifter_arch;
