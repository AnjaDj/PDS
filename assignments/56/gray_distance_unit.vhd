-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     GRAY DISTANCE CIRCUIT
--
-- description:
--
--   This file implements a simple gray distance calculator logic.
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

entity gray_distance_unit is
  generic(
    g_N : natural := 4
  );
  port(
    A_i        : in  std_logic_vector(g_N-1 downto 0);
    B_i        : in  std_logic_vector(g_N-1 downto 0);
    DISTANCE_o : out std_logic_vector(g_N-1 downto 0)
  );
end gray_distance_unit;

architecture arch of gray_distance_unit is
begin
  circ_logic : process(A_i, B_i)
    variable diff    : integer;
    variable a_int   : integer;
    variable b_int   : integer;
    variable op1     : integer;
    variable op2     : integer;
    variable a_bin   : std_logic_vector(g_N-1 downto 0);
    variable b_bin   : std_logic_vector(g_N-1 downto 0);
  begin
    a_bin(g_N-1) := A_i(g_N-1);
    b_bin(g_N-1) := B_i(g_N-1);
    for i in g_N - 2 downto 0 loop
      a_bin(i) := a_bin(i+1) xor A_i(i);
      b_bin(i) := b_bin(i+1) xor B_i(i);
    end loop;
    a_int := to_integer(unsigned(a_bin));
    b_int := to_integer(unsigned(b_bin));
    if b_int >= a_int then
      op1 := b_int;
      op2 := a_int;
    else
      op1 := a_int;
      op2 := b_int;
    end if;
    diff  := op1 - op2;
    DISTANCE_o <= std_logic_vector(to_unsigned(diff, DISTANCE_o'length));
  end process circ_logic;
end arch;
