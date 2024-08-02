library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity sequential_divider_tb is
end sequential_divider_tb;

architecture arch of sequential_divider_tb is
	
	component sequential_divider is
	  port(
			clk_i   : in  std_logic; 
			rst_i   : in  std_logic; 
			start_i : in  std_logic; 
			a_i     : in  std_logic_vector(7 downto 0);  
			b_i     : in  std_logic_vector(7 downto 0);  
			q_o     : out std_logic_vector(7 downto 0);  
			r_o     : out std_logic_vector(7 downto 0);  
			ready_o : out std_logic                    
			);
	end component;

	constant T : time := 40 ns;
	file input_buf : text;
	
	signal clk, rst, start, ready : std_logic := '0';
	signal a, b, q, r : std_logic_vector(7 downto 0);

begin 

	uut : sequential_divider port map(
		clk_i => clk,
		rst_i => rst,
		start_i => start,
		a_i => a,
		b_i => b,
		q_o => q,
		r_o => r,
		ready_o => ready
	);
	
	process
		
		procedure execute(
			constant expect_div : std_logic_vector(7 downto 0);
			constant expect_rem : std_logic_vector(7 downto 0);
			variable result : out std_logic
		) is
		begin
			while ready = '0' loop
				clk <= '0';
				wait for T/2;
				clk <= '1';
				wait for T/2;
			end loop;
			clk <= '0';
			if ((expect_div = q) and (expect_rem = r)) then
				report "[OK] a_i = " & integer'image(to_integer(unsigned(a))) &
				", b_i = " & integer'image(to_integer(unsigned(b))) &
				". Expected q = " & integer'image(to_integer(unsigned(expect_div))) &
				", r = " & integer'image(to_integer(unsigned(expect_rem))) &
				". Got q = " & integer'image(to_integer(unsigned(q))) &
				", r = " & integer'image(to_integer(unsigned(r))) & ".";
				result := '1';
			else
				report "[ERROR] a_i = " & integer'image(to_integer(unsigned(a))) &
				", b_i = " & integer'image(to_integer(unsigned(b))) &
				". Expected q = " & integer'image(to_integer(unsigned(expect_div))) &
				", r = " & integer'image(to_integer(unsigned(expect_rem))) &
				". Got q = " & integer'image(to_integer(unsigned(q))) &
				", r = " & integer'image(to_integer(unsigned(r))) & ".";
				result := '0';
			end if;
		end execute;	
		
		variable read_col_from_input_buf : line;
		variable val_comma : character;
		variable val_a : std_logic_vector(7 downto 0);
		variable val_b : std_logic_vector(7 downto 0);
		variable expected_div : std_logic_vector(7 downto 0);
		variable expected_rem : std_logic_vector(7 downto 0);
		variable passed_tests : integer := 0; 
		variable failed_tests : integer := 0;
		variable res : std_logic;
		
	begin
		-- Path to the test data might need reconfiguration
		file_open(input_buf, "../../data_files/data.csv", read_mode); 	
		while not endfile(input_buf) loop
			readline(input_buf, read_col_from_input_buf);
			read(read_col_from_input_buf, val_a);			
			read(read_col_from_input_buf, val_comma);	
			read(read_col_from_input_buf, val_b);			
			read(read_col_from_input_buf, val_comma);
			read(read_col_from_input_buf, expected_div);			
			read(read_col_from_input_buf, val_comma);	
			read(read_col_from_input_buf, expected_rem);			
			rst <= '1';
			wait for T/2;
			rst <= '0';
			wait for T/2;
			a <= val_a;
			b <= val_b;
			start <= '1';
			clk <= '0';
			wait for T/2;
			clk <= '1';
			wait for T/2;
			start <= '0';
			execute(expected_div, expected_rem, res);
			if res = '1' then
				passed_tests := passed_tests + 1;
			else
				failed_tests := failed_tests + 1;
			end if;
		end loop;
		report "Total tests: 65536, passed: " & integer'image(passed_tests) &
		", failed: " & integer'image(failed_tests) & ".";
		wait;
	end process;
	
end arch;