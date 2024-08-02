-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     dual_mode_comparator
--
-- description:
--
--   This file implements a logic of dual mode comparator.
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


entity dual_mode_comparator is
  port(
    A_i    : in  std_logic_vector(7 downto 0);
    B_i    : in  std_logic_vector(7 downto 0);
    MODE_i : in  std_logic;
    AGTB_o : out std_logic
   );
end dual_mode_comparator;


architecture arch of dual_mode_comparator is
  signal a1_b0, agtb_mag, posit : std_logic;
  signal comp_check : std_logic_vector(1 downto 0);
begin
  a1_b0      <= '1' when A_i(7) = '1' and B_i(7) = '0' else
                '0';
  posit      <= '1' when A_i(7) = '0' and B_i(7) = '0' else
                '0';
  comp_check <= "00" when A_i(6 downto 0) = B_i(6 downto 0) else
                "10" when A_i(6 downto 0) > B_i(6 downto 0) else
                "01";
  agtb_mag <=   '1' when comp_check = "01" and Mode_i = '1' and posit = '0'  else
                '1' when comp_check = "10" and (Mode_i = '0' or posit = '1') else
                '0';
  AGTB_o <= agtb_mag when A_i(7) = B_i(7)   else
            a1_b0    when Mode_i = '0'      else
            '0'      when A_i(6 downto 0) = "0000000" and B_i(6 downto 0) = "0000000" else
            not a1_b0;
end arch;
