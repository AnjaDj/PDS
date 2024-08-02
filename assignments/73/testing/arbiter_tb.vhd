library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter_tb is
end arbiter_tb;

architecture arch of arbiter_tb is

  component arbiter is
    port(
      clk_i : in  std_logic;
      rst_i : in  std_logic;
      r_i   : in  std_logic_vector(1 downto 0);
      g_o   : out std_logic_vector(1 downto 0)
    );
  end component;
  
  signal clk     : std_logic := '0';
  signal rst     : std_logic := '0';
  signal r_in    : std_logic_vector(1 downto 0) := "00";
  signal g_out   : std_logic_vector(1 downto 0);

begin
  u1 : arbiter port map(clk_i => clk, rst_i => rst, r_i => r_in, g_o => g_out);
  
  process
  begin
    rst <= '1';
	 wait for 50 ns;
	 rst <= '0';
	 wait for 50 ns;
	 
	 -- RST -> WAITR0
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "00") then
	   report "OK ! (RESET) r_i = 0x00, g_o = 0x00" severity note;
	 else
	   report "NOK ! (RESET) r_i = 0x00, expected g_o = 0x00, got g_o = 0x0" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "00";
	 wait for 50 ns;
	 
	 -- WAITR0 -> WAITRO
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "00") then
	   report "OK ! r_i = 0x0 -> r_i = 0x0, g_o = 0x0" severity note;
	 else
	   report "NOK ! r_i = 0x0 -> r_i = 0x0, expected g_o = 0x0, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "10";
	 wait for 50 ns;
	 
	 -- WAITR0 -> GRANT1
    clk <= '1';
	 wait for 50 ns;
	 if(g_out = "10") then
	   report "OK ! r_i = 0x0 -> r_i = 0x2, g_o = 0x2" severity note;
	 else
	   report "NOK ! r_i = 0x0 -> r_i = 0x2, expected g_o = 0x2, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "11";
	 wait for 50 ns;
	 
	 -- GRANT1 -> GRANT1
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "10") then
	   report "OK ! r_i = 0x2 -> r_i = 0x3, g_o = 0x2" severity note;
	 else
	   report "NOK ! r_i = 0x2 -> r_i = 0x3, expected g_o = 0x2, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "01";
	 wait for 50 ns;
	 
	 -- GRANT1 -> WAITR0
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "00") then
	   report "OK ! r_i = 0x3 -> r_i = 0x1, g_o = 0x0" severity note;
	 else
	   report "NOK ! r_i = 0x3 -> r_i = 0x1, expected g_o = 0x0, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "01";
	 wait for 50 ns;
	 
	 -- WAITR0 -> GRANT0
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "01") then
	   report "OK ! r_i = 0x1 -> r_i = 0x1, g_o = 0x1" severity note;
	 else
	   report "NOK ! r_i = 0x1 -> r_i = 0x1, expected g_o = 0x1, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "11";
	 wait for 50 ns;
	 
	 -- GRANT0 -> GRANT0
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "01") then
	   report "OK ! r_i = 0x1 -> r_i = 0x3, g_o = 0x1" severity note;
	 else
	   report "NOK ! r_i = 0x1 -> r_i = 0x3, expected g_o = 0x1, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "10";
	 wait for 50 ns;
	 
	 -- GRANT0 -> WAITR1
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "00") then
	   report "OK ! r_i = 0x3 -> r_i = 0x2, g_o = 0x0" severity note;
	 else
	   report "NOK ! r_i = 0x3 -> r_i = 0x2, expected g_o = 0x0, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "00";
	 wait for 50 ns;
	 
	 -- WAITR1 -> WAITR1
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "00") then
	   report "OK ! r_i = 0x2 -> r_i = 0x0, g_o = 0x0" severity note;
	 else
	   report "NOK ! r_i = 0x2 -> r_i = 0x0, expected g_o = 0x0, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "01";
	 wait for 50 ns;
	 
	 -- WAITR1 -> GRANT0
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "01") then
	   report "OK ! r_i = 0x0 -> r_i = 0x1, g_o = 0x1" severity note;
	 else
	   report "NOK ! r_i = 0x0 -> r_i = 0x1, expected g_o = 0x1, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 clk <= '0';
	 r_in <= "00";
	 wait for 50 ns;
	 
	 -- ALREADY TESTED (GRANT0 -> WAITR1) 
	 clk <= '1';
	 wait for 50 ns;
	 clk <= '0';
	 r_in <= "11";
	 wait for 50 ns;
	 
	 -- WAITR1 -> GRANT1
	 clk <= '1';
	 wait for 50 ns;
	 if(g_out = "10") then
	   report "OK ! r_i = 0x0 -> r_i = 0x3, g_o = 0x2" severity note;
	 else
	   report "NOK ! r_i = 0x0 -> r_i = 0x3, expected g_o = 0x2, got g_o = 0x" & 
		integer'image(to_integer(unsigned(g_out))) severity error;
	 end if;
	 
	 wait;
	 
  end process;

end arch;