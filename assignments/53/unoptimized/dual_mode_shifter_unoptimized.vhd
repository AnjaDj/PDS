-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     dual_mode_shifter_unoptimized
--
-- description:
--
-- This file implements unoptimized bit shifter logic that can shift left or
-- right 4 bits.
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

entity dual_mode_shifter_unoptimized is
  port (
  SH_IN_i  : in  std_logic_vector (15 downto 0);
  MODE_i   : in  std_logic;
  SH_OUT_o : out std_logic_vector (15 downto 0 )
);
end dual_mode_shifter_unoptimized;

architecture arch of dual_mode_shifter_unoptimized is
  component right_shifter is
    port (
    sh_i : in std_logic_vector(15 downto 0);
    sh_o : out std_logic_vector(15 downto 0)
  );
  end component;
  component left_shifter is
    port (
    sh_i : in std_logic_vector(15 downto 0);
    sh_o : out std_logic_vector(15 downto 0)
  );
  end component;
  signal right_out, left_out : std_logic_vector(15 downto 0);
begin
  u1 : right_shifter
    port map(
      sh_i => SH_IN_i,
      sh_o => right_out
    );
  u2 : left_shifter
    port map(
      sh_i => SH_IN_i,
      sh_o => left_out
    );
  with MODE_i select
   SH_OUT_o <= left_out when '0',
               right_out when others;
end arch;
