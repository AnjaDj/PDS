-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     SEQUENTIAL MULTIPLIER
--
-- description:
--
--   This file implements a simple Sequential multiplier logic.
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
--! @file sequential_multiplier.vhd
--! @brief Sequential add-and-shift multiplier
-------------------------------------------------------

--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric types and conversions
use ieee.numeric_std.all;

--! Detailed description of this
--! sequential_multiplier.

entity sequential_multiplier is
  port (
     clk_i    : in  std_logic; --! Clock signal
     rst_i    : in  std_logic; --! Reset signal
     start_i  : in  std_logic; --! Signal to initiate the multiplication process
     a_i      : in  std_logic_vector(7 downto 0); --! Input data signal for operand A
     b_i      : in  std_logic_vector(7 downto 0); --! Input data signal for operand B
     c_o      : out std_logic_vector(15 downto 0); --! Output signal representing the result
     ready_o  : out std_logic --! Output signal indicating readiness for operation
   );
end sequential_multiplier;

architecture arch of sequential_multiplier is
  --! Enum for states
  type t_state_type is
       (idle, load, op);
  signal state_reg, state_next : t_state_type;
  --! Width of data
  constant  c_WIDTH        : integer := 8;
  signal count_next        : std_logic_vector(2 downto 0);
  signal count_reg         : std_logic_vector(2 downto 0);
  signal counter           : std_logic_vector(2 downto 0);
  signal sum_reg           : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal sum_next          : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal shift_reg         : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal shift_next        : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal added_and_shifted : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal shifted           : std_logic_vector(2*c_WIDTH-1 downto 0);
  signal shift_help        : std_logic_vector(c_WIDTH-1 downto 0) := (others => '0');
  signal max, value_a_1    : std_logic;

begin
  --! @brief Architecture Description
  --! The architecture is designed using a Finite State Machine (FSM) methodology,
  --! specifically employing a Moore state machine.
  --! It utilizes three processes to implement different functionalities: state transition,
  --! next-state determination, and register logic.

  --! @brief Updates the state based on clock and reset inputs.
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= state_next;
    end if;
  end process;

  --! @brief State transition logic based on current state and inputs.
  process(state_reg, start_i, max)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          state_next <= load;
        else
          state_next <= idle;
        end if;
      when load =>
        state_next <= op;
      when op =>
        if max = '1' then
          state_next <= idle;
        else
          state_next <= op;
        end if;
    end case;
  end process;

  --! Output signal ready_o logic
  --! @brief Indicates whether the module is ready for operation.
  ready_o <= '1' when state_reg = idle else '0';

  --! Register process
  --! @brief Registers data based on clock and reset inputs.
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      sum_reg <= (others => '0');
      shift_reg <= (others => '0');
      count_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      sum_reg <= sum_next;
      shift_reg <= shift_next;
      count_reg <= count_next;
    end if;
  end process;

  --! Multiplexer routing logic
  --! @brief Controls the data routing based on the state and input conditions.
  process(state_reg, count_reg, sum_reg, shift_reg, value_a_1, counter, b_i, shift_help, added_and_shifted, shifted)
  begin
    case state_reg is
      when idle =>
        shift_next <= shift_reg;
        sum_next <= sum_reg;
        count_next <= count_reg;
      when load =>
        shift_next <= shift_help & b_i;
        sum_next <= (others => '0');
        count_next <= (others => '0');
      when op =>
        if value_a_1 = '1' then
          sum_next <= added_and_shifted;
        else
          sum_next <= sum_reg;
        end if;
        shift_next <= shifted;
        count_next <= counter;
    end case;
  end process;

  --! Functional units logic
  --! @brief Performs arithmetic and logic operations.
  added_and_shifted <= std_logic_vector(unsigned(sum_reg) + unsigned(shift_reg));
  shifted <= shift_reg(14 downto 0) & '0';
  counter <= std_logic_vector(unsigned(count_reg) + 1 );

  --! Status signals logic
  --! @brief Determines and updates status flags.
  max <= '1' when count_reg = "111" else '0';
  value_a_1 <= '1' when a_i(to_integer(unsigned(count_reg))) = '1' else '0';

  --! Output assignment
  --! @brief Assigns the output value.
  c_o <= sum_reg;

end arch;
