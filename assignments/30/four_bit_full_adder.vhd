-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023
-----------------------------------------------------------------------------
--
-- unit name:     FOUR BIT FULL ADDER
--
-- description:
--
--   This file implements four bit full adder circuit logic.
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

entity four_bit_full_adder is
  port (
    i_A   :  in std_logic_vector(3 downto 0);
    i_B   :  in std_logic_vector(3 downto 0);
    i_C   :  in std_logic;
    o_SUM : out std_logic_vector(3 downto 0);
    o_C   : out std_logic
  );
end four_bit_full_adder;

architecture arch of four_bit_full_adder is

  component one_bit_full_adder is
    port (
      i_Ai :  in std_logic;
      i_Bi :  in std_logic;
      i_Ci :  in std_logic;
      o_So : out std_logic;
      o_Co : out std_logic
    );
  end component;

  signal carry1 : std_logic := '0';
  signal carry2 : std_logic := '0';
  signal carry3 : std_logic := '0';

begin
  u1 : one_bit_full_adder
    port map(
      i_Ai => i_A(0),
      i_Bi => i_B(0),
      i_Ci => i_C,
      o_So => o_SUM(0),
      o_Co => carry1
    );
  u2 : one_bit_full_adder
    port map(
      i_Ai => i_A(1),
      i_Bi => i_B(1),
      i_Ci => carry1,
      o_So => o_SUM(1),
      o_Co => carry2
    );
  u3 : one_bit_full_adder
    port map(
      i_Ai => i_A(2),
      i_Bi => i_B(2),
      i_Ci => carry2,
      o_So => o_SUM(2),
      o_Co => carry3
    );
  u4 : one_bit_full_adder
    port map(
      i_Ai => i_A(3),
      i_Bi => i_B(3),
      i_Ci => carry3,
      o_So => o_SUM(3),
      o_Co => o_C
    );
end arch;
