-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     HAMMING DISTANCE CIRCUIT TESTBENCH
--
-- description:
--
--   This file tests a hamming distance circuit functionality.
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

entity hamming_distance_unit_tb is
end hamming_distance_unit_tb;

architecture arch of hamming_distance_unit_tb is
  constant c_WIDTH : natural := 8;

  signal a_in      : std_logic_vector(c_WIDTH-1 downto 0);
  signal b_in      : std_logic_vector(c_WIDTH-1 downto 0);
  signal y_out     : std_logic_vector(3 downto 0);

  component hamming_distance_unit is
    generic(
      g_WIDTH : natural := 8
    );
    port(
      A_i : in  std_logic_vector(g_WIDTH-1 downto 0);
      B_i : in  std_logic_vector(g_WIDTH-1 downto 0);
      Y_o : out std_logic_vector(3 downto 0)
    );
  end component;

begin
  i1 : hamming_distance_unit port map(
    A_i => a_in,
    B_i => b_in,
    Y_o => y_out
  );
  label2 : process
    variable temp         : std_logic_vector(c_WIDTH-1 downto 0);
    variable bit_value    : std_logic_vector(1 downto 0) := "00";
    variable inc_value    : integer := 0;
    variable temp_counter : integer := 0;
    variable counter      : integer := 0;
  begin
    for i in 0 to (2**c_WIDTH-1) loop
      a_in <= std_logic_vector(to_unsigned(i, a_in'length));
      for j in 0 to (2**c_WIDTH-1) loop
        b_in <= std_logic_vector(to_unsigned(j, b_in'length));
        temp := a_in xor b_in;
        for k in 0 to (c_WIDTH-1) loop
          bit_value(0) := temp(k);
          inc_value    := to_integer(unsigned(bit_value));
          temp_counter := counter + inc_value;
          counter      := temp_counter;
        end loop;
        assert(y_out = std_logic_vector(to_unsigned(counter,y_out'length))) severity error;
        wait for 100 ns;
        temp_counter := 0;
        counter      := 0;
      end loop;
    end loop;
    wait;
  end process label2;
end arch;
