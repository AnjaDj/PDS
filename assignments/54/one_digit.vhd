-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     ONE_DIGIT
--
-- description:
--
--   This file implements an one digit of BCD_ADDER.
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

entity one_digit is
  port (
        a_i     : in  std_logic_vector(3 downto 0);
        b_i     : in  std_logic_vector(3 downto 0);
        carry_i : in  std_logic;
        s_o     : out std_logic_vector(3 downto 0);
        carry_o : out std_logic
    );
end one_digit;

architecture arch of one_digit is
  signal temp1 : unsigned(4 downto 0);
  signal tempa : std_logic_vector(4 downto 0) := "00000";
  signal tempb : std_logic_vector(4 downto 0) := "00000";
  signal tempc : std_logic_vector(4 downto 0) := "00000";
  signal mask : unsigned(3 downto 0) := "0110";

begin
  tempa(3 downto 0) <= a_i;
  tempb(3 downto 0) <= b_i;
  tempc(0) <= carry_i;
  temp1 <= unsigned(tempa) + unsigned(tempb) + unsigned(tempc);
  carry_o <= '1' when temp1 > 9 else
'0';
  s_o <= std_logic_vector(temp1(3 downto 0) + mask) when temp1 > 9 else
std_logic_vector(temp1(3 downto 0));
end arch;
