library ieee;                                               
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;                                

entity leading_zero_counter_unit_tb is
end leading_zero_counter_unit_tb;

architecture arch of leading_zero_counter_unit_tb is
                                                  
signal INPUT_DATA1_i : std_logic_vector(15 downto 0);
signal OUTPUT_DATA1_o : std_logic_vector(4 downto 0);
signal temp : std_logic_vector(4 downto 0);

component leading_zero_counter_unit
	port (
	INPUT_DATA_i : in std_logic_vector(15 downto 0);
	OUTPUT_DATA_o : out std_logic_vector(4 downto 0)
	);
end component;


begin

	i1 : leading_zero_counter_unit
	port map ( INPUT_DATA_i => INPUT_DATA1_i, OUTPUT_DATA_o => OUTPUT_DATA1_o
	);
	
init : process                                              
variable error_status : boolean;                                    
begin
	INPUT_DATA1_i  <= "0000000000000000";	
    for i in 0 to 65534 loop
			temp <= "00000";
			for j in 0 to 15 loop
				wait for 10 ns;
				if(INPUT_DATA1_i(15-j) = '0') then
					temp <= std_logic_vector(unsigned(temp) +1);
					else
					exit;
				end if;	
			end loop;
			wait for 10 ns;
 			if(unsigned(OUTPUT_DATA1_o) = unsigned(temp)) then  
				error_status := false;
			else
				error_status := true;
			end if;
			
		assert not error_status
		report "Test Failed!"
		severity note;
		
		INPUT_DATA1_i <= std_logic_vector(unsigned(INPUT_DATA1_i) + 1);
	 end loop;
report "Test completed.";	 
	 wait;		
end process init;                                          
end arch;
