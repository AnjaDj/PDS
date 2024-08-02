library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eight_bit_divider_tb is
end eight_bit_divider_tb;

architecture tb_arch of eight_bit_divider_tb is
  signal A_tb, B_tb, Q_tb, R_tb : std_logic_vector(7 downto 0);
  signal initialized : boolean := false;
  
  -- Component declaration for the divider
  component eight_bit_divider
    port (
      A_i : in  std_logic_vector(7 downto 0);
      B_i : in  std_logic_vector(7 downto 0);
      Q_o : out std_logic_vector(7 downto 0);
      R_o : out std_logic_vector(7 downto 0)
    );
  end component;

begin
  -- Instantiate the eight_bit_divider
  UUT : eight_bit_divider
    port map (
      A_i => A_tb,
      B_i => B_tb,
      Q_o => Q_tb,
      R_o => R_tb
    );

  -- Process to initialize signals
  PROCESS   
  BEGIN
    wait for 1 ns;  -- Delay for initialization

    for i in 0 to 255 loop
      A_tb <= std_logic_vector(to_unsigned(i, 8));
      for j in 1 to 255 loop
        B_tb <= std_logic_vector(to_unsigned(j, 8));
        
        wait for 100 ns;  -- Simulate some processing time
        
        initialized <= true;  -- Set initialization flag
      end loop;
    end loop;
    wait;
  END PROCESS;

  -- Process for checking outputs after initialization
  PROCESS   
    variable error_status : boolean;                                
  BEGIN   
    wait until initialized;  -- Wait for initialization to complete

    wait for 100 ns;  
    
    if (Q_tb = std_logic_vector((unsigned(A_tb)) rem (unsigned(B_tb)))) then
      if (R_tb = std_logic_vector((unsigned(A_tb)) / (unsigned(B_tb)))) then
        error_status := false;
      else 
        error_status := true;
      end if;
    else 
      error_status := true;
    end if;

    assert not error_status
      report "Test failed"
      severity error;
    
    report "Test passed"
      severity note;
    
    WAIT;
  END PROCESS;                                          
END tb_arch;
