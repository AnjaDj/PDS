-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     ALTERNATING PRIORITY ARBITER CIRCUIT
--
-- description:
--
--   This file implements alternating priority arbiter circuit logic.
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
--! @brief Alternating priority arbiter circuit
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;

--! Alternating priority arbiter circuit design entity.
entity arbiter is
  port(
    clk_i : in  std_logic; --! Clock signal input
    rst_i : in  std_logic; --! Asynchronous reset signal input
    r_i   : in  std_logic_vector(1 downto 0); --! Data input vector
    g_o   : out std_logic_vector(1 downto 0) --! Data output vector
  );
end arbiter;

--! @brief Architecture definition of the arbiter
--! @details Architecture written using Moore FSM theory
architecture arch of arbiter is
  type t_state is (waitr0, waitr1, grant0, grant1); --! Type defining possible states of the machine
  signal reg_state  : t_state; --! Register state signal
  signal next_state : t_state; --! Next state signal
begin

  state_register : process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      reg_state <= waitr0;
    elsif rising_edge(clk_i) then
      reg_state <= next_state;
    end if;
  end process state_register;

  next_state_logic : process(r_i, reg_state)
  begin
    case reg_state is
      when waitr0 =>
        if r_i(0) = '1' then
          next_state <= grant0;
        elsif r_i = "10" then
          next_state <= grant1;
        else
          next_state <= waitr0;
        end if;
      when waitr1 =>
        if r_i(1) = '1' then
          next_state <= grant1;
        elsif r_i = "01" then
          next_state <= grant0;
        else
          next_state <= waitr1;
        end if;
      when grant0 =>
        if r_i(0) = '1' then
          next_state <= grant0;
        else
          next_state <= waitr1;
        end if;
      when grant1 =>
        if r_i(1) = '1' then
          next_state <= grant1;
        else
          next_state <= waitr0;
        end if;
    end case;
  end process next_state_logic;

  output_logic : process(reg_state)
  begin
    case reg_state is
      when waitr0 =>
        g_o <= "00";
      when waitr1 =>
        g_o <= "00";
      when grant0 =>
        g_o <= "01";
      when grant1 =>
        g_o <= "10";
    end case;
  end process output_logic;
end arch;
