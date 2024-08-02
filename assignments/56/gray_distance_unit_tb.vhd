-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     GRAY DISTANCE CIRCUIT TESTBENCH
--
-- description:
--
--   This file implements a testbench code for gray distance calculator.
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

entity gray_distance_unit_tb is
end gray_distance_unit_tb;

architecture arch of gray_distance_unit_tb is
  constant c_N        : natural := 4;

  signal   a_in       : std_logic_vector(c_N-1 downto 0);
  signal   b_in       : std_logic_vector(c_N-1 downto 0);
  signal   dist_out   : std_logic_vector(c_N-1 downto 0);

  component gray_distance_unit is
    generic(
      g_N : natural := 4
    );
    port(
      A_i        : in  std_logic_vector(g_N-1 downto 0);
      B_i        : in  std_logic_vector(g_N-1 downto 0);
      DISTANCE_o : out std_logic_vector(g_N-1 downto 0)
    );
  end component;

begin
  u1 : gray_distance_unit port map(
    A_i        => a_in,
    B_i        => b_in,
    DISTANCE_o => dist_out
  );
  tb_proc : process
    variable   a_tmp      : std_logic_vector(c_N-1 downto 0);
    variable   b_tmp      : std_logic_vector(c_N-1 downto 0);
    variable   a_gray     : std_logic_vector(c_N-1 downto 0);
    variable   b_gray     : std_logic_vector(c_N-1 downto 0);
    variable   dist_tmp   : integer;
  begin
    for i in 0 to 2**c_N - 1 loop
      a_tmp           := std_logic_vector(to_unsigned(i, a_tmp'length));
      a_gray(c_N - 1) := a_tmp(c_N - 1);
      for k in c_N - 2 downto 0 loop
        a_gray(k) := a_tmp(k+1) xor a_tmp(k);
      end loop;

      for j in 0 to 2**c_N - 1 loop
        b_tmp := std_logic_vector(to_unsigned(j, b_tmp'length));
        b_gray(c_N - 1) := b_tmp(c_N - 1);
        for k in c_N - 2 downto 0 loop
          b_gray(k)  := b_tmp(k+1) xor b_tmp(k);
        end loop;
        a_in <= a_gray;
        b_in <= b_gray;
        wait for 10 ns;
        if j >= i then
          dist_tmp := j - i;
        else
          dist_tmp := i - j;
        end if;
        assert(dist_tmp = to_integer(unsigned(dist_out))) severity error;
      end loop;
    end loop;
    wait;
  end process tb_proc;
end arch;
