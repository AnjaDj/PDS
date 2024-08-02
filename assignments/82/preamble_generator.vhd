-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     PREAMBLE GENERATOR
--
-- description:
--
--   This file implements a simple PREAMBLE GENERATOR logic.
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

-------------------------------------------------------
--! @file preamble_generator.vhd
--! @brief Preamble detector for the sequence "10101010"
-------------------------------------------------------

--! Use standard logic library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! @brief Entity for the preamble generator
entity preamble_generator is
  port (
        clk_i   : in  std_logic;   --! Clock input
        rst_i   : in  std_logic;   --! Reset input
        start_i : in  std_logic;   --! Start input
        data_o  : out std_logic    --! Output data
    );
end preamble_generator;

--! @brief Architecture defining the preamble generator
--! @details Architecture designed using Moore FSM methodology with three segments:
--! register, next-state, and output.
--! It utilizes a finite set of states ('idle', 'zero', 'one') to generate a specific output pattern.

architecture arch of preamble_generator is
  type t_state_type is (idle, zero, one);   --! State type definition
  signal state_reg, state_next : t_state_type;   --! State signals
  signal data_next, data_buff_reg : std_logic;   --! Data signals
begin

  --! @brief Process to handle the state register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;   --! Reset state to idle
    elsif rising_edge(clk_i) then
      state_reg <= state_next;   --! Update state based on next state
    end if;
  end process;

   --! @brief Process for the output buffer
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      data_buff_reg <= '0';   --! Reset data buffer
    elsif rising_edge(clk_i) then
      data_buff_reg <= data_next;   --! Update data buffer based on next data
    end if;
  end process;

  --! @brief Process for the next-state logic
  process(state_reg, start_i, data_buff_reg)
    variable count : natural range 0 to 8 := 0;   --! Variable for counting
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          state_next <= zero;   --! Move to zero state on start signal
          count := 0;   --! Reset count
        else
          state_next <= idle;   --! Stay idle
          count := 0;   --! Reset count
        end if;
      when zero =>
        if start_i = '1' then
          state_next <= zero;   --! Stay at zero state on start signal
          count := 0;   --! Reset count
        else
          state_next <= one;   --! Move to one state
          count := count + 1;   --! Increment count
        end if;
      when one =>
        if start_i = '1' then
          state_next <= zero;   --! Move to zero state on start signal
          count := 0;   --! Reset count
        else
          state_next <= zero;   --! Move back to zero state
          count := count + 1;   --! Increment count
        end if;
    end case;

    if count = 8 then
      state_next <= idle;   --! Move to idle state after 8 counts
      count := 0;   --! Reset count
    end if;
  end process;

    --! @brief Look-ahead output
  data_next <= '1' when state_next = one else '0';   --! Generate data lookahead

    --! @brief Output assignment
  data_o <= data_buff_reg;   --! Output buffered data

end arch;
