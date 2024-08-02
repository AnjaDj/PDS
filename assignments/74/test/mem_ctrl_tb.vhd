-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     MEMORY CONTROLER TESTBENCH
--
-- description:
--
--   This file implements a memory controler testbench logic.
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
--! @file
--! @brief memory controler tb
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric lib
use ieee.numeric_std.all;

--! controler tb entity is empty
entity mem_ctrl_tb is
end mem_ctrl_tb;

--! @brief Testing functionality correctness of the memory controler design
architecture arch of mem_ctrl_tb is
  signal clk_in    : std_logic;
  signal rst_in    : std_logic;
  signal mem_in    : std_logic;
  signal rw_in     : std_logic;
  signal burst_in  : std_logic;
  signal oe_out    : std_logic;
  signal we_out    : std_logic;
  signal we_me_out : std_logic;

  component mem_ctrl is
    port(
      clk_i   : in  std_logic;
      rst_i   : in  std_logic;
      mem_i   : in  std_logic;
      rw_i    : in  std_logic;
      burst_i : in  std_logic;
      oe_o    : out std_logic;
      we_o    : out std_logic;
      we_me_o : out std_logic
    );
  end component;
begin
  i1 : mem_ctrl port map(
    clk_i   => clk_in,
    rst_i   => rst_in,
    mem_i   => mem_in,
    rw_i    => rw_in,
    burst_i => burst_in,
    oe_o    => oe_out,
    we_o    => we_out,
    we_me_o => we_me_out
  );

  l : process
  begin
    rst_in <= '1';
    wait for 5 ns;
    if oe_out = '0' and we_out = '0' and we_me_out = '0' then
      report "OK RESET = 1 -> ALL OUTPUTS = '0' - IN IDLE STATE- " severity note;
    else
      report "ERROR RESET = 1 -> EXPECTED ALL OUTPUTS = '0' -> GOT oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    rst_in <= '0';
    clk_in <= '0';
    wait for 5 ns;
    if oe_out = '0' and we_out = '0' and we_me_out = '0' then
      report "OK RESET = 0 and CLK = 0 -> ALL OUTPUTS = '0'" severity note;
    else
      report "ERROR RESET = 0 and CLK = 0 -> EXPECTED ALL OUTPUTS = '0' -> GOT" &
      " oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    mem_in <= '0';
    clk_in <= '1';
    wait for 5 ns;
    if oe_out = '0' and we_out = '0' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 0 -> ALL OUTPUTS = '0' - IN IDLE STATE- " severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 0 -> EXPECTED ALL OUTPUTS = '0' -> GOT" &
      " oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    clk_in <= '0';
    wait for 10 ns;

    mem_in <= '1';
    rw_in <= '0';
    wait for 5 ns;
    if oe_out = '0' and we_out = '0' and we_me_out = '1' then
      report "OK CLK = 0 and MEM_I = 1 and RW_I = 0 -> we_me_out = '1' still in IDLE"
      severity note;
    else
      report "ERROR CLK = 0 and MEM_I = 1 and RW_I = 0 -> EXPECTED we_me_out = '1', others = '0' -> GOT" &
      " oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    clk_in <= '1';
    wait for 5 ns;
    if oe_out = '0' and we_out = '1' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 1 and RW_I = 0 -> we_out = '1' others = '0' -in WRITE STATE-"
      severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 1 and RW_I = 0 -> expected we_out = '1' others = '0' -> GOT" &
      " oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    clk_in <= '0';
    wait for 10 ns;

    clk_in <= '1';
    wait for 10 ns;

    clk_in <= '0';
    wait for 10 ns;

    rw_in <= '1';
    burst_in <= '0';
    wait for 5 ns;
    clk_in <= '1';
    wait for 5 ns;
    if oe_out = '1' and we_out = '0' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 0 ->" &
      "oe_out = '1' others = '0' -in SINGLE READ STATE- " severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 0 ->" &
      " expected oe_out = '1' others = '0' -> GOT oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    clk_in <= '0';
    wait for 10 ns;

    clk_in <= '1';
    wait for 10 ns;

    clk_in <= '0';
    wait for 10 ns;

    burst_in <= '1';
    wait for 5 ns;
    clk_in <= '1';
    wait for 5 ns;
    if oe_out = '1' and we_out = '0' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->"&
      "oe_out = '1' others = '0' -in MULTI READ STATE- " severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " expected oe_out = '1' others = '0' -> GOT oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 5 ns;

    clk_in <= '0';
    wait for 10 ns;

    clk_in <= '1';
    if oe_out = '1' and we_out = '0' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " oe_out = '1' others = '0' -in MULTI READ STATE- " severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " expected oe_out = '1' others = '0' -> GOT oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 10 ns;

    clk_in <= '0';
    wait for 10 ns;

    clk_in <= '1';
    if oe_out = '1' and we_out = '0' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " oe_out = '1' others = '0' -in MULTI READ STATE- " severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " expected oe_out = '1' others = '0' -> GOT oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 10 ns;

    clk_in <= '0';
    wait for 10 ns;

    clk_in <= '1';
    if oe_out = '1' and we_out = '0' and we_me_out = '0' then
      report "OK CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " oe_out = '1' others = '0' -in MULTI READ STATE- " severity note;
    else
      report "ERROR CLK = 1 and MEM_I = 1 and RW_I = 1 and BURST = 1 ->" &
      " expected oe_out = '1' others = '0' -> GOT oe_out = " & std_logic'image(oe_out) &
      " , we_out = " & std_logic'image(we_out) &
      " , we_me_out = " & std_logic'image(we_me_out)
      severity error;
    end if;
    wait for 10 ns;

    clk_in <= '0';
    wait for 10 ns;
    wait;
  end process l;
end arch;
