-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     BCD_TO_BINARY_TB
--
-- description:
--
--   This file represents test bench for BCD_TO_BINARY design unit.
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
-----------------------------------------------------------------------------
--! @file
--! @brief test bench for binary to bcd converter
-----------------------------------------------------------------------------

--! Use standard library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--! @brief empty entity definition
entity bcd_to_binary_second_tb is
end bcd_to_binary_second_tb;

--! @brief Testing functionality of bcd_to_binary design entity
architecture arch of bcd_to_binary_second_tb is
  signal clk_in     : std_logic := '0';
  signal rst_in     : std_logic := '0';
  signal start_in   : std_logic := '1';
  signal bcd1_in    : std_logic_vector(3 downto 0);
  signal bcd2_in    : std_logic_vector(3 downto 0);
  signal binary_out : std_logic_vector(6 downto 0);
  signal ready_out  : std_logic;

  component bcd_to_binary is
    port(
      clk_i    : in  std_logic;
      rst_i    : in  std_logic;
      start_i  : in  std_logic;
      bcd1_i   : in  std_logic_vector(3 downto 0);
      bcd2_i   : in  std_logic_vector(3 downto 0);
      binary_o : out std_logic_vector(6 downto 0);
      ready_o  : out std_logic
    );
  end component;
begin
  i1 : bcd_to_binary port map(
    clk_i    => clk_in,
    rst_i    => rst_in,
    start_i  => start_in,
    bcd1_i   => bcd1_in,
    bcd2_i   => bcd2_in,
    binary_o => binary_out,
    ready_o  => ready_out
  );
  l : process
  begin
    rst_in <= '1';
    wait for 200 ns;
    if binary_out = "0000000" then
      report "OK : rst_i = 1  -> binary_o = 0" severity note;
    else
      report "ERROR : rst_i = 1 -> EXPECTED OUTPUT TO BE 0 BUT GOT : " &
      "binary_o = " &
      std_logic'image(binary_out(6)) & std_logic'image(binary_out(5)) &
      std_logic'image(binary_out(4)) & std_logic'image(binary_out(3)) &
      std_logic'image(binary_out(2)) & std_logic'image(binary_out(1)) &
      std_logic'image(binary_out(0)) severity error;
    end if;
    rst_in <= '0';
    wait for 200 ns;

    for i in 1 to 100 loop --! idle
      bcd1_in <= std_logic_vector(to_unsigned((i/10),bcd1_in'length));
      bcd2_in <= std_logic_vector(to_unsigned((i mod 10),bcd2_in'length));

      clk_in <= '0';
      wait for 200 ns;

      clk_in <= '1'; --! load
      wait for 200 ns;

      clk_in <= '0';
      wait for 200 ns;

      clk_in <= '1'; --! op
      wait for 200 ns;

      clk_in <= '0';
      wait for 200 ns;

      if binary_out = std_logic_vector(to_unsigned(i-1,binary_out'length)) then
        report "OK #NO" & integer'image(i-1) & " GOT : " &
        "binary_o = " &
        std_logic'image(binary_out(6)) & std_logic'image(binary_out(5)) &
        std_logic'image(binary_out(4)) & std_logic'image(binary_out(3)) &
        std_logic'image(binary_out(2)) & std_logic'image(binary_out(1)) &
        std_logic'image(binary_out(0)) severity note;
      else
        report "ERROR #NO" & integer'image(i) & " GOT : " &
        "binary_o = " &
        std_logic'image(binary_out(6)) & std_logic'image(binary_out(5)) &
        std_logic'image(binary_out(4)) & std_logic'image(binary_out(3)) &
        std_logic'image(binary_out(2)) & std_logic'image(binary_out(1)) &
        std_logic'image(binary_out(0)) severity error;
      end if;

      clk_in <= '1'; --! idle
      wait for 200 ns;
      clk_in <= '0';
      wait for 200 ns;
    end loop;
    wait;
  end process l;
end arch;
