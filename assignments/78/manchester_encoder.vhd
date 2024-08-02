-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     manchester_encoder
--
-- description:
--
--   This file implements Manchester encoder circuit.
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
--! @file manchester_encoder.vhd
--! @brief  This file implements Manchester encoder circuit.
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! @brief Manchester encoder entity description
--! The `manchester_encoder` entity is responsible for encoding binary data using the Manchester encoding scheme.
--! It takes a clock signal (`clk_i`), a reset signal (`rst_i`), a valid signal (`v_i`), and the input binary data (`d_i`).
--! The output, `y_o`, represents the Manchester-encoded signal.

--! @details The Manchester encoding is performed when the `v_i` signal is set (valid).

--! @structure
--! The entity has the following ports:
--! `clk_i` is the clock input, used to synchronize the circuit.
--! `rst_i` is the reset input, which resets the state machine and other internal signals when asserted.
--! `v_i` is a signal that indicates whether the input data (`d_i`) is valid.
--!  When '1', the data is considered valid.
--! `d_i` is the input binary data that needs to be Manchester encoded.
--! `y_o` is the output representing the Manchester-encoded data.


entity manchester_encoder is
  port (
  clk_i : in  std_logic; --! Clock input signal
  rst_i : in  std_logic; --! Reset input signal
  v_i   : in  std_logic; --! Signal indicates whether input data is valid ('1' is true, '0' is false)
  d_i   : in  std_logic; --! Input binary data
  y_o   : out std_logic  --! Output data
);
end manchester_encoder;

--! @brief Architecture definition of Manchester encoder
--! @details Architecture is implemented using FSM with five states - idle, s0a, s0b, s1a, s1b.
--! @details Manchester encoding of input signal d_i is done when v_i signal is set (valid), otherwise output stays equal to zero
architecture arch of manchester_encoder is
  type t_fsm_type is (idle, s0a, s0b, s1a, s1b);
  signal state_reg, state_next : t_fsm_type;
begin


-- state register
  process(clk_i,rst_i)
  begin
    if rst_i = '1'then
      state_reg <= idle;
    elsif rising_edge(clk_i)then
      state_reg <= state_next;
    end if;
  end process;

-- next state
  process(state_reg,v_i,d_i)
  begin
    case state_reg is
      when idle =>
        if v_i = '0' then
          state_next <= idle;
        else
          if d_i = '0' then
            state_next <= s0a;
          else
            state_next <= s1a;
          end if;
        end if;
      when s0a =>
        state_next <= s0b;

      when s1a =>
        state_next <= s1b;
      when s0b =>
        if v_i = '0' then
          state_next <= idle;
        else
          if d_i = '0' then
            state_next <= s0a;
          else
            state_next <= s1a;
          end if;
        end if;
      when s1b =>
        if v_i = '0' then
          state_next <= idle;
        else
          if d_i = '0' then
            state_next <= s0a;
          else
            state_next <= s1a;
          end if;
        end if;
    end case;
  end process;

-- output

  y_o <= '1' when state_reg = s1a or state_reg = s0b  else '0';

end arch;
