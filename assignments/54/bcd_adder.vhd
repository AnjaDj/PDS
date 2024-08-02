-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     BCD_ADDER
--
-- description:
--
--   This file implements a simple BCD ADDER logic.
--
-----------------------------------------------------------------------------
-- Copyright (c) 2023 Faculty of Electrical Engineering
-----------------------------------------------------------------------------
-- The MIT License
-----------------------------------------------------------------------------
-- Copyright 2023 Faculty of Electrical Engineering
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom
-- the Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
-- ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE
-----------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_adder is
  port (
        A_i   : in  std_logic_vector(11 downto 0);
        B_i   : in  std_logic_vector(11 downto 0);
        SUM_o : out std_logic_vector(15 downto 0)
    );
end bcd_adder;

architecture arch of bcd_adder is
  component one_digit is
    port(
         a_i :     in  std_logic_vector(3 downto 0);
         b_i :     in  std_logic_vector(3 downto 0);
         carry_i : in  std_logic;
         s_o :     out std_logic_vector(3 downto 0);
         carry_o : out std_logic
        );
  end component;
  signal sum1, sum2, sum3 : std_logic_vector(3 downto 0);
  signal temp : std_logic_vector(3 downto 0) := "0000";
  signal carry1, carry2, carry3 : std_logic;
begin
  d1 : one_digit port map (
                           a_i       => A_i(3 downto 0),
                           b_i       => B_i(3 downto 0),
                           carry_i   => '0',
                           carry_o   => carry1,
                           s_o       => sum1
                          );
  d2 : one_digit port map (
                           a_i       => A_i(7 downto 4),
                           b_i       => B_i(7 downto 4),
                           carry_i   => carry1,
                           carry_o   => carry2,
                           s_o       => sum2
                          );
  d3 : one_digit port map (
                           a_i       => A_i(11 downto 8),
                           b_i       => B_i(11 downto 8),
                           carry_i   => carry2,
                           carry_o   => carry3,
                           s_o       => sum3
                           );
  temp(0) <= carry3;
  SUM_o(3 downto 0) <= sum1;
  SUM_o(7 downto 4) <= sum2;
  SUM_o(11 downto 8) <= sum3;
  SUM_o(15 downto 12) <= temp;
end arch;
