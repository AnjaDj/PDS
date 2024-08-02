library ieee;
use ieee.std_logic_1164.all;


entity four_bit_full_subtractor is
    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          i_C : in std_logic;
          o_SUB : out std_logic_vector(3 downto 0);
          o_C : out std_logic);
end four_bit_full_subtractor;

architecture fourbit_arch of four_bit_full_subtractor is

component one_bit_full_subtractor
port ( X,Y,B_in : in std_logic;
       Diff, B_out : out std_logic
	  );
end component;

signal B : std_logic_vector(2 downto 0);
begin
	s0 : one_bit_full_subtractor
	   port map (X => i_A (0), Y => i_B(0), B_in => i_C, Diff =>o_SUB(0), B_out => B(0));
	s1 : one_bit_full_subtractor
		port map (X => i_A (1), Y => i_B(1), B_in =>B(0) , Diff=>o_SUB(1) , B_out =>B(1));
	s2 : one_bit_full_subtractor
		port map (X => i_A (2), Y => i_B(2), B_in =>B(1), Diff=>o_SUB(2) , B_out =>B(2));
	s3 : one_bit_full_subtractor
		port map (X => i_A (3), Y => i_B(3), B_in =>B(2), Diff=>o_SUB(3) , B_out =>o_C);
end fourbit_arch;