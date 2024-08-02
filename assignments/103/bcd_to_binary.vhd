-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     bcd_to_binary
--
-- description:
--
--   This file implements a 2 digit BCD code to binary code converter.
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
--! @bcd_to_binary.vhd
--! @brief 2 digit BCD code to binary converter
-------------------------------------------------------
--! Use standard library
library ieee;
--! Use logic elements
use ieee.std_logic_1164.all;
--! Use numeric elements
use ieee.numeric_std.all;


-- ! Entity that describes the inputs and outputs of the BCD to binary converter
-- ! Converts 2 BCD digits, where one is the most significant and the other the
-- ! least significant, into a 7 bit binary number.
entity bcd_to_binary is
  port (
  clk_i    : in  std_logic;                    -- ! Clock signal input
  rst_i    : in  std_logic;                    -- ! Asynchronous reset input
  start_i  : in  std_logic;                    -- ! Used to signal when the conversion can start
  bcd1_i   : in  std_logic_vector(3 downto 0); -- ! Input bcd digit 1; most significant bcd digit
  bcd2_i   : in  std_logic_vector(3 downto 0); -- ! Input bcd digit 2; least significant bcd digit
  binary_o : out std_logic_vector(6 downto 0); -- ! Binary output
  ready_o  : out std_logic                     -- ! Output that signalized readiness of binary output signal
);
end bcd_to_binary;

--! @brief Architecture definition of the BCD to binary converter
--! @details Architecture consists of 4 processes:
--! 1) control path : state register - Register for storing the current state of the control path logic
--! 2) control path : next state logic - Implementation of next state logic for the control path
--! 3) data path: data register - Register for storing the values regarding the data path, i.e. the input and output values
--! 4) data path: routing multiplexer - Logic that changed the next value of the data path registers based on the control path state
--! There is also combinational logic that addresses the output values and the data path status variable
architecture arch of bcd_to_binary is
  type t_state is
    (idle, load, finished);
  signal state_reg : t_state;
  signal next_reg : t_state := idle;
  signal data_in_reg1, data_in_reg2 : unsigned(3 downto 0);
  signal data_in_reg1_next, data_in_reg2_next : unsigned(3 downto 0);
  signal data_out_reg : unsigned(6 downto 0);
  signal data_out_reg_next : unsigned(6 downto 0);
  signal converter_out : unsigned(6 downto 0);
  signal internal_status : std_logic := '0';
  signal sum : integer := 0;
begin
--! control path : state register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      state_reg <= idle;
    elsif rising_edge(clk_i) then
      state_reg <= next_reg;
    end if;
  end process;
--! control path : next state logic
  process(start_i, internal_status, state_reg)
  begin
    case state_reg is
      when idle =>
        if start_i = '1' then
          next_reg <= load;
        else
          next_reg <= idle;
        end if;
      when load =>
        if internal_status = '1' then
          next_reg <= finished;
        else
          next_reg <= load;
        end if;
      when finished =>
        next_reg <= idle;
    end case;
  end process;
--! control path output logic
  ready_o <= '1' when state_reg = idle else '0';
--! data path: data register
  process(clk_i, rst_i)
  begin
    if rst_i = '1' then
      data_in_reg1 <= (others => '0');
      data_in_reg2 <= (others => '0');
      data_out_reg <= (others => '0');
    elsif rising_edge(clk_i) then
      data_in_reg1 <= data_in_reg1_next;
      data_in_reg2 <= data_in_reg2_next;
      data_out_reg <= data_out_reg_next;
    end if;
  end process;
--! data path: routing multiplexer
  process(state_reg, data_in_reg1, data_in_reg2,
    data_out_reg, converter_out, bcd1_i, bcd2_i)
  begin
    case state_reg is
      when idle =>
        data_in_reg1_next <= data_in_reg1;
        data_in_reg2_next <= data_in_reg2;
        data_out_reg_next <= data_out_reg;
      when load =>
        data_in_reg1_next <= unsigned(bcd1_i);
        data_in_reg2_next <= unsigned(bcd2_i);
        data_out_reg_next <= data_out_reg;
      when finished =>
        data_in_reg1_next <= data_in_reg1;
        data_in_reg2_next <= data_in_reg2;
        data_out_reg_next <= converter_out;
    end case;
  end process;
--! data path: functional units
  converter_out <= to_unsigned(to_integer(data_in_reg1) * 10 + to_integer(data_in_reg2), 7);
--! data path: status
  internal_status <= '1' when state_reg = load else '0';
--! data_path: output
  binary_o <= std_logic_vector(data_out_reg);
end arch;
