-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     dual_mode_shifter
--
-- description:
--
-- This file implements bit shifter logic that can shift left or right 1 bit.
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

entity dual_mode_shifter is
  port (
  SH_IN_i  : in  std_logic_vector (15 downto 0);
  MODE_i   : in  std_logic;
  SH_OUT_o : out std_logic_vector (15 downto 0 )
);
end dual_mode_shifter;

architecture arch of dual_mode_shifter is
  component right_shifter is
    port (
    sh_i : in std_logic_vector(15 downto 0);
    sh_o : out std_logic_vector(15 downto 0)
  );
  end component;
  component bit_flipper is
    port (
    sh_i : in std_logic_vector(15 downto 0);
    mode_i : in std_logic;
    sh_o : out std_logic_vector(15 downto 0)
  );
  end component;
  signal temp1, temp2 : std_logic_vector(15 downto 0);
begin
  u1 : bit_flipper
    port map(
      sh_i   => SH_IN_i,
      mode_i => MODE_i,
      sh_o   => temp1
    );
  u2 : right_shifter
    port map(
      sh_i => temp1,
      sh_o => temp2
    );
  u3 : bit_flipper
    port map(
      sh_i   => temp2,
      mode_i => MODE_i,
      sh_o   => SH_OUT_o
    );
end arch;
