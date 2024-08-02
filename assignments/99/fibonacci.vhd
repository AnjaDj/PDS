-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     FIBONACCI SEQUENCE GENERATOR
--
-- description:
--
--   This file implements fibonacci sequence generator circuit.
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
--! @file fibonacci.vhd
--! @brief Fibonacci sequence generator circuit
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric types and conversions
use ieee.numeric_std.all;

--! @brief Fibonacci sequence generator entity description
--! Entity is responsible for creating fibonacci sequence numbers using RT methodology.
--! It takes a clock signal, a reset signal, a start signal, and the sequence lenght parameter.
--! It outputs the last number for desired length and a ready flag to indicate completion.

--! @details Circiut starts generating when the start signal is set.

--! @structure
--! The entity has the following ports:
--! `clk_i` is the clock input, used to synchronize the circuit.
--! `rst_i` is the reset input, which resets the state machine and other signals when asserted.
--! `start_i` is a signal that starts fibonacci number generation.
--! `n_i` is the input which determines sequence length.
--! `y_o` is the output representing the last fibonacci number for desired length.

entity fibonacci is
  port(
    clk_i   : in  std_logic; --! Clock signal input
    rst_i   : in  std_logic; --! Asynchronous reset signal input
    start_i : in  std_logic; --! Start signal input
    n_i     : in  std_logic_vector(5 downto 0); --! Sequence length input vector
    r_o     : out std_logic_vector(42 downto 0); --! Last generated number output
    ready_o : out std_logic --! Ready flag output
  );
end fibonacci;

--! @brief Architecture definition of the fibonacci sequence generator
--! @details Architecture implemented using RT methodology with control and data paths
--! @details State machine has 4 states: idle, n0 (n_i is 0), load and op (operating)
architecture arch of fibonacci is
  type t_state is (idle, n0, load, op);

  signal state_reg  : t_state;
  signal state_next : t_state;
  signal done       : std_logic;
  signal n_is_0     : std_logic;
  signal n_reg      : unsigned(5 downto 0);
  signal n_next     : unsigned(5 downto 0);
  signal r_reg      : unsigned(42 downto 0);
  signal r_next     : unsigned(42 downto 0);
  signal prev_reg   : unsigned(42 downto 0);
  signal prev_next  : unsigned(42 downto 0);
  signal res_out    : unsigned(42 downto 0);
  signal sub_out    : unsigned(5 downto 0);
begin
  -- control path: state register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

  -- control path: next-state
  process(state_reg, start_i, done, n_is_0)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          if n_is_0 = '1' then
            state_next <= n0;
          else
            state_next <= load;
          end if;
        else
          state_next <= idle;
        end if;
      when n0 =>
        state_next <= idle;
      when load =>
        if done = '1' then
          state_next <= idle;
        else
          state_next <= op;
        end if;
      when op =>
        if done = '1' then
          state_next <= idle;
        else
          state_next <= op;
        end if;
    end case;
  end process;

  -- control path: output logic
  ready_o <= '1' when state_reg = idle else '0';
  -- data path: data register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      prev_reg <= (others => '0');
      n_reg     <= (others => '0');
      r_reg     <= (others => '0');
    elsif rising_edge(clk_i) then
      prev_reg <= prev_next;
      n_reg    <= n_next;
      r_reg    <= r_next;
    end if;
  end process;

  -- data path: routing multipexer
  process(state_reg, prev_reg, n_reg, r_reg, n_i, res_out, sub_out, start_i)
  begin
    case state_reg is
      when idle =>
        prev_next <= prev_reg;
        n_next    <= n_reg;
        if start_i = '1' then
          r_next <= (others => '0');
        else
          r_next <= r_reg;
        end if;
      when n0 =>
        prev_next <= prev_reg;
        n_next    <= n_reg;
        r_next    <= (others => '0');
      when load =>
        prev_next <= (others => '0');
        n_next    <= unsigned(n_i) - 1;
        r_next    <= (0 => '1', others => '0');
      when op =>
        prev_next <= r_reg;
        n_next    <= sub_out;
        r_next    <= res_out;
    end case;
  end process;

  -- data path: functional units
  res_out <= prev_reg + r_reg;
  sub_out <= n_reg - 1;
  -- data path: status
  n_is_0 <= '1' when n_i = "000000" else '0';
  done   <= '1' when n_next = "000000" else '0';
  -- data path: output
  r_o <= std_logic_vector(r_reg);
end arch;
