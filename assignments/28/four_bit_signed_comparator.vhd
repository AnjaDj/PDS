library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity four_bit_signed_comparator is 
	port (
		i_A : in std_logic_vector(3 downto 0);
      i_B : in std_logic_vector(3 downto 0);
      o_AGTB : out std_logic
	);
end four_bit_signed_comparator;

architecture four_bit_signed_comparator_arch of four_bit_signed_comparator is
begin
	
	o_AGTB <= '1' when signed(i_A) > signed(i_B) else
				 '0';
	
end four_bit_signed_comparator_arch;