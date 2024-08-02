library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity bcd_to_binary_tb is
end bcd_to_binary_tb;


architecture tb_arch of bcd_to_binary_tb is

  component bcd_to_binary
    port(
       clk_i    : in std_logic;
       rst_i    : in std_logic;
       start_i  : in std_logic;
       bcd1_i   : in std_logic_vector(3 downto 0);
       bcd2_i   : in std_logic_vector(3 downto 0);
       binary_o : out std_logic_vector(6 downto 0);
       ready_o  : out std_logic
    );
  end component;

  signal clk : std_logic;
  signal rst : std_logic;
  signal start : std_logic;
  signal bcd_h : std_logic_vector(3 downto 0);
  signal bcd_l : std_logic_vector(3 downto 0);
  signal binary : std_logic_vector(6 downto 0);
  signal ready :  std_logic;

  signal binary_test : std_logic_vector(6 downto 0);

  -- clock period definition and definition
  constant T : time := 5 ns;

  file input_buf : text;

begin

  uut : bcd_to_binary port map(
    clk_i    => clk,
    rst_i    => rst,
    start_i  => start,
    bcd1_i   => bcd_h,
    bcd2_i   => bcd_l,
    binary_o => binary,
    ready_o  => ready
  );     

  -- stimulus generator for reset
  rst <= '1', '0' after T/2;

  -- stimulus for contionous clock
  process
  begin
    clk <= '0';
     wait for T/2;
     clk <= '1';
     wait for T/2;
  end process;

  -- stimulus and verifier process
  process
    variable read_col_from_input_buf : line;
     variable val_comma : character;
     variable val1 : std_logic_vector(3 downto 0);
     variable val2 : std_logic_vector(3 downto 0);
     variable val3 : std_logic_vector(6 downto 0);

  begin  
     file_open(input_buf, "data_files/bcd_to_binary_input.csv", read_mode);

    wait for T;
    start <= '1';

     while not endfile(input_buf) loop

        wait on ready;

        if ready = '1' then

            readline(input_buf, read_col_from_input_buf);

            read(read_col_from_input_buf, val1);
            read(read_col_from_input_buf, val_comma);
            read(read_col_from_input_buf, val2);
            read(read_col_from_input_buf, val_comma);
            read(read_col_from_input_buf, val3);

            -- wait for one period T to simulate entering into load state
            wait for T;
            bcd_h <= val1;
            bcd_l <= val2;

            -- wait for two more periods (2T) for FSM to calculate output
            wait for 2*T;
            binary_test <= val3;

            -- wait for T/4 to make sure the output is set
            wait for T/4;
            report "BCD input : " & std_logic'image(bcd_h(3)) & std_logic'image(bcd_h(2)) & std_logic'image(bcd_h(1)) & std_logic'image(bcd_h(0)) &
            " " & std_logic'image(bcd_l(3)) & std_logic'image(bcd_l(2)) & std_logic'image(bcd_l(1)) & std_logic'image(bcd_l(0)) &
            " (dec : " & integer'image(to_integer(unsigned(bcd_h))) & integer'image(to_integer(unsigned(bcd_l))) & " ) " &
            ". Result in binary --> " & std_logic'image(binary(6)) & std_logic'image(binary(5)) & std_logic'image(binary(4)) & std_logic'image(binary(3))& 
            std_logic'image(binary(2)) & std_logic'image(binary(1)) & std_logic'image(binary(0)) &
            " (dec: " & integer'image(to_integer(unsigned(binary))) & " ) .";

            assert(binary = binary_test)
            report "Expected result is " & std_logic'image(binary_test(6)) & std_logic'image(binary_test(5)) & std_logic'image(binary_test(4)) &
            std_logic'image(binary_test(3)) & std_logic'image(binary_test(2)) & std_logic'image(binary_test(1)) & std_logic'image(binary_test(0)) &
            " (dec: " & integer'image(to_integer(unsigned(binary_test))) & " ),   but given result is " & 
            std_logic'image(binary(6)) & std_logic'image(binary(5)) & std_logic'image(binary(4)) &
            std_logic'image(binary(3)) & std_logic'image(binary(2)) & std_logic'image(binary(1)) & std_logic'image(binary(0)) &
            " (dec: " & integer'image(to_integer(unsigned(binary))) & " )."
            severity error;

            report "==========================================================================================================";
        end if; 
    end loop;
     file_close(input_buf);
    wait;    
  end process;
end tb_arch;