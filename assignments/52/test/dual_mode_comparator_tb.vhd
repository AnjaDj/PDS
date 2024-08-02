-----------------------------------------------------------------------------
-- Faculty of Electrical Engineering
-- PDS 2023
-- https://github.com/etf-unibl/pds-2023/
-----------------------------------------------------------------------------
--
-- unit name:     dual_mode_comparator testbench
--
-- description:
--
--   This file is a testbench file, used for checking correctntes of implementation of dual_mode_comparator
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

entity dual_mode_comparator_tb is
end dual_mode_comparator_tb;

architecture arch of dual_mode_comparator_tb is

  signal A_i    : std_logic_vector(7 downto 0);
  signal AGTB_o : std_logic;
  signal B_i    : std_logic_vector(7 downto 0);
  signal MODE_i : std_logic;

  signal comp_test : std_logic;

  component dual_mode_comparator
    port (
      A_i    : in std_logic_vector(7 downto 0);
      AGTB_o : out std_logic;
      B_i    : in std_logic_vector(7 downto 0);
      MODE_i : in std_logic
    );
  end component;

begin
  i1 : dual_mode_comparator port map (
    A_i    => A_i,
    AGTB_o => AGTB_o,
    B_i    => B_i,
    MODE_i => MODE_i
  );

  init : process
  begin
    A_i    <= "00000000";
    B_i    <= "00000000";
    MODE_i <= '0';
    for k in 0 to 1 loop
      for i in 0 to 255 loop
        for j in 0 to 255 loop
          wait for 10 ns;
          B_i <= std_logic_vector(unsigned(B_i) + 1);
        end loop;
        A_i <= std_logic_vector(unsigned(A_i) + 1);
      end loop;
      if k = 0 then
        MODE_i <= '1';
      end if;
    end loop;
    wait;
  end process init;

  tb : process
    variable error_status : boolean;
  begin

    wait on A_i, B_i;
    if MODE_i = '0' then
      if unsigned(A_i) > unsigned(B_i) then
        comp_test <= '1';
      else
        comp_test <= '0';
      end if;
      wait for 5 ns;
      if comp_test = AGTB_o then
        error_status := false;
      else
        error_status := true;
      end if;
      assert not error_status
        report "Error in comparing unsigned numbers (MODE : 0)"
        severity failure;

    elsif MODE_i = '1' then
      if A_i(7) = B_i(7) and A_i(7) = '0' then
        if A_i(6 downto 0) > B_i(6 downto 0) then
          comp_test <= '1';
        else
          comp_test <= '0';
        end if;
      elsif A_i(7) = B_i(7) and A_i(7) = '1' then
        if A_i(6 downto 0) < B_i(6 downto 0) then
          comp_test <= '1';
        else
          comp_test <= '0';
        end if;
      elsif A_i(7) = '0' and B_i(7) = '1' then
        if A_i(6 downto 0) = B_i(6 downto 0) and A_i(6 downto 0) = "0000000" then
          comp_test <= '0';
        else
          comp_test <= '1';
        end if;
      else
        comp_test <= '0';
      end if;
      wait for 5 ns;
      if comp_test = AGTB_o then
        error_status := false;
      else
        error_status := true;
      end if;
      assert not error_status
        report "Error in comparing signed numbers (MODE : 1)"
        severity failure;
    end if;
  end process tb;
end arch;
