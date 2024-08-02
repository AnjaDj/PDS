library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_bit_comparator is
    port (i_A2 : in std_logic_vector(1 downto 0);
          i_B2 : in std_logic_vector(1 downto 0);
          o_AGTB2 : out std_logic;
          o_AEQB2 : out std_logic;
          o_ALTB2 : out std_logic
			 );
end two_bit_comparator;

architecture two_bit_comparator_arch of two_bit_comparator is

begin
	o_AGTB2 <= '1' when (unsigned(i_A2) > unsigned(i_B2))
				else '0';
	o_AEQB2 <= '1' when (unsigned(i_A2) = unsigned(i_B2))
				else '0';
	o_ALTB2 <= '1' when (unsigned(i_A2) < unsigned(i_B2))
				else '0';
end two_bit_comparator_arch; 
