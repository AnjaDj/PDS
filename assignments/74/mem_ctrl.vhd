-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     MEMORY CONTROLER CIRCUIT
--
-- description:
--
--   This file implements a memory controler logic.
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
--! @file
--! @brief Memory controler circuit
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! @details Controler entity
--! with 5 input ports and
--! 3 output ports(moore+mealy output logic)
entity mem_ctrl is
  port(
    clk_i   : in  std_logic; --! clock input
    rst_i   : in  std_logic; --! asynchronous reset input
    mem_i   : in  std_logic; --! control input for memory access permission
    rw_i    : in  std_logic; --! control input for read/write mode selection
    burst_i : in  std_logic; --! control input for burst mode selection
    oe_o    : out std_logic; --! moore output
    we_o    : out std_logic; --! moore output
    we_me_o : out std_logic  --! mealy output
  );
end mem_ctrl;

--! @brief Architecture definition of the mem_ctrl
--! @details Realized using FSM metodology with 7 states
--! idle - initial/neutral state
--! write - one state that represents writing functionality
--! single_read and multi_read - multiple read states depending on burst_i input selection
architecture arch of mem_ctrl is
  type t_mem_ctrl_states is
    (state_idle, state_write, state_single_read, state_multi_read1, state_multi_read2,
    state_multi_read3, state_multi_read4);
  signal state_next : t_mem_ctrl_states;
  signal state_reg  : t_mem_ctrl_states;
begin
  current : process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= state_idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process current;

  nexts : process(state_reg, mem_i, rw_i, burst_i)
  begin
    case state_reg is
      when state_idle =>
        if mem_i = '1' then
          if rw_i = '1' then
            if burst_i = '1' then
              state_next <= state_multi_read1;
            else
              state_next <= state_single_read;
            end if;
          else
            state_next <= state_write;
          end if;
        else
          state_next <= state_idle;
        end if;
      when state_multi_read1 =>
        state_next <= state_multi_read2;
      when state_multi_read2 =>
        state_next <= state_multi_read3;
      when state_multi_read3 =>
        state_next <= state_multi_read4;
      when others =>
        state_next <= state_idle;
    end case;
  end process nexts;

  moore : process(state_reg)
  begin
    we_o <= '0';
    oe_o <= '0';
    case state_reg is
      when state_idle =>
      when state_write =>
        we_o <= '1';
      when others =>
        oe_o <= '1';
    end case;
  end process moore;

  mealy : process(state_reg, mem_i, rw_i)
  begin
    we_me_o <= '0';
    case state_reg is
      when state_idle =>
        if (mem_i = '1') and (rw_i = '0') then
          we_me_o <= '1';
        end if;
      when others =>
    end case;
  end process mealy;
end arch;
