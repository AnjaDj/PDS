-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name: eight_bit_divider
--
-- description:
--
--   This file implements a simple EIGHT BIT DIVIDER logic.
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

entity eight_bit_divider is
  port (
    A_i : in  std_logic_vector(7 downto 0);
    B_i : in  std_logic_vector(7 downto 0);
    Q_o : out std_logic_vector(7 downto 0);
    R_o : out std_logic_vector(7 downto 0)
  );
end eight_bit_divider;

architecture arch of eight_bit_divider is
begin
  calculate_division : process(A_i, B_i)
    variable A_tmp, B_tmp, Q_tmp, R_tmp : unsigned(7 downto 0);
  begin
    A_tmp := unsigned(A_i);
    B_tmp := unsigned(B_i);
    Q_tmp := (others => '0');
    R_tmp := (others => '0');
    if B_tmp = 0 then
      Q_o <= (others => '1');
      R_o <= (others => '1');
    elsif A_tmp = 0 then
      Q_o <= (others => '0');
      R_o <= (others => '0');
    else
      for i in 7 downto 0 loop
        R_tmp := shift_left(R_tmp, 1);
        R_tmp(0) := A_tmp(7);
        if R_tmp >= B_tmp then
          R_tmp := R_tmp - B_tmp;
          Q_tmp(i) := '1';
        end if;
        A_tmp := shift_left(A_tmp, 1);
      end loop;
      Q_o <= std_logic_vector(Q_tmp);
      R_o <= std_logic_vector(R_tmp);
    end if;
  end process calculate_division;
end architecture arch;
