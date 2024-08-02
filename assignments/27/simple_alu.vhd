library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
entity simple_alu is
    port (i_A : in std_logic_vector(3 downto 0);
          i_B : in std_logic_vector(3 downto 0);
          i_SEL : in std_logic_vector(1 downto 0);
          o_RES : out std_logic_vector(3 downto 0);
          o_C : out std_logic);
end simple_alu;

architecture beh_arch of simple_alu is
signal sum, diff, sarA, shlB : std_logic_vector(3 downto 0);  
signal carry1, carry2, carry_sar2, carry_shl4 : std_logic := '0'; 
signal tmp1 : std_logic_vector(4 downto 0);
signal tmp2 : std_logic; 

begin
		sum <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
		diff <= std_logic_vector(unsigned(i_A) - unsigned(i_B));
		shlB <= (others=>'0');
		
		tmp1<= std_logic_vector(unsigned('0'&i_A)+unsigned('0'&i_B));
		tmp2<=i_A(3); 
		
		sarA <= "00"&i_A(3 downto 2) when tmp2='0' else 
				  "11"&i_A(3 downto 2) when tmp2='1';
		
		carry1 <= tmp1(4);

		carry2 <= '1' when ((unsigned(i_A) < unsigned(i_B))  ) else
					 '0';

		o_C <= carry1 when (i_SEL = "00") else
				 carry2 when (i_SEL = "01") else
				 carry_sar2 when (i_SEL = "10") else
				 carry_shl4; 
		
		o_RES <= sum when i_SEL(1 downto 0) ="00" else
					diff when i_SEL(1 downto 0) ="01" else
					sarA when i_SEL(1 downto 0) ="10" else
					shlB;		 
end beh_arch;