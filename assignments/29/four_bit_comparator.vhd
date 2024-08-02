library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity four_bit_comparator is
    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          o_AGTB : out std_logic;
          o_AEQB : out std_logic;
          o_ALTB : out std_logic);
end four_bit_comparator;

architecture four_bit_comparator_arch of four_bit_comparator is

signal aGTb1, aEQb1, aLTb1, aGTb2, aEQb2, aLTb2 : std_logic;

component two_bit_comparator
	port(
		i_A2 : in std_logic_vector(1 downto 0);
		i_B2 : in std_logic_vector(1 downto 0);
		o_AGTB2 : out std_logic;
		o_AEQB2 : out std_logic;
		o_ALTB2 : out std_logic
		);
end component;

begin
u1 : two_bit_comparator
	port map(i_A2 =>i_A(1 downto 0),i_B2 => i_B(1 downto 0), o_AGTB2 => aGTb1, o_AEQB2 => aEQb1, o_ALTB2 => aLTb1);
u2 : two_bit_comparator
	port map(i_A2 =>i_A(3 downto 2),i_B2 => i_B(3 downto 2), o_AGTB2 => aGTb2, o_AEQB2 => aEQb2, o_ALTB2 => aLTb2);
o_AGTB <= aGTb2 or (aEQb2 and aGTb1);
o_AEQB <= aEQb1 and AEQb2;
o_ALTB <= aLTb2 or (aEQb2 and aLTb1);
end four_bit_comparator_arch;