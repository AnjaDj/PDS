library ieee;
use ieee.std_logic_1164.all;

entity one_bit_full_adder is
port(
	a, b, c_in : in std_logic;
	s, c_out : out std_logic
);
end one_bit_full_adder;

architecture one_bit_full_adder_arch of one_bit_full_adder is
signal input : std_logic_vector(2 downto 0);
signal output : std_logic_vector(1 downto 0);
begin 
	input(0) <= a;
	input(1) <= b;
	input(2) <= c_in;
	with input select
		output <= "00" when "000",
					 "01" when "001" | "010" | "100",
					 "10" when "011" | "101" | "110",
					 "11" when others;
	s <= output(0);
	c_out <= output(1);
end one_bit_full_adder_arch;