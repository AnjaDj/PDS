-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     LEADING ZERO COUNTER UNIT
--
-- description:
--
--   This file implements a circuit for counting the leading zeros of an input 16 bit number.
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

entity leading_zero_counter_unit is
  port (
  INPUT_DATA_i  : in  std_logic_vector(15 downto 0);
  OUTPUT_DATA_o : out std_logic_vector(4 downto 0)
);
end entity leading_zero_counter_unit;

architecture arch of leading_zero_counter_unit is
  component leading_zero_counter_unit4
    port(
INPUT_i : in std_logic_vector(3 downto 0);
OUTPUT_o : out std_logic_vector(2 downto 0)
);
  end component;
  signal OUTPUT_DATA1_o, OUTPUT_DATA2_o, OUTPUT_DATA3_o, OUTPUT_DATA4_o : std_logic_vector(2 downto 0);

begin
  lzc1 : leading_zero_counter_unit4
port map(
                           INPUT_i(3) => INPUT_DATA_i(15),
                           INPUT_i(2) => INPUT_DATA_i(14),
                           INPUT_i(1) => INPUT_DATA_i(13),
                           INPUT_i(0) => INPUT_DATA_i(12),
                           OUTPUT_o   => OUTPUT_DATA1_o);
  lzc2 : leading_zero_counter_unit4
port map(
                           INPUT_i(3) => INPUT_DATA_i(11),
                           INPUT_i(2) => INPUT_DATA_i(10),
                           INPUT_i(1) => INPUT_DATA_i(9),
                           INPUT_i(0) => INPUT_DATA_i(8),
                           OUTPUT_o   => OUTPUT_DATA2_o);
  lzc3 : leading_zero_counter_unit4
port map(                  INPUT_i(3) => INPUT_DATA_i(7),
                           INPUT_i(2) => INPUT_DATA_i(6),
                           INPUT_i(1) => INPUT_DATA_i(5),
                           INPUT_i(0) => INPUT_DATA_i(4),
                           OUTPUT_o   => OUTPUT_DATA3_o);
  lzc4 : leading_zero_counter_unit4
port map(
                           INPUT_i(3) => INPUT_DATA_i(3),
                           INPUT_i(2) => INPUT_DATA_i(2),
                           INPUT_i(1) => INPUT_DATA_i(1),
                           INPUT_i(0) => INPUT_DATA_i(0),
                           OUTPUT_o   => OUTPUT_DATA4_o);
  OUTPUT_DATA_o <=
                     ("00" & OUTPUT_DATA1_o) when OUTPUT_DATA1_o /= "100" else
std_logic_vector(unsigned("00" & OUTPUT_DATA1_o) +
                unsigned("00" & OUTPUT_DATA2_o)) when OUTPUT_DATA2_o /= "100" else
std_logic_vector(unsigned("00" & OUTPUT_DATA1_o) +
                                      unsigned("00" & OUTPUT_DATA2_o) +
                                      unsigned("00" & OUTPUT_DATA3_o)) when OUTPUT_DATA3_o /= "100" else
std_logic_vector(unsigned("00" & OUTPUT_DATA1_o) +
                                      unsigned("00" & OUTPUT_DATA2_o) +
                                      unsigned("00" & OUTPUT_DATA3_o) +
                                      unsigned("00" & OUTPUT_DATA4_o));
end arch;
