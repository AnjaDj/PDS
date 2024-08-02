library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity manchester_encoder_tb is
end manchester_encoder_tb;

architecture arch of manchester_encoder_tb is 
  component manchester_encoder
    port (
      clk_i : in  std_logic; 
      rst_i : in  std_logic;
      v_i   : in  std_logic; 
      d_i   : in  std_logic; 
      y_o   : out std_logic  
    );
  end component;
  
  signal clk1_i : std_logic;
  signal rst1_i : std_logic;
  signal v1_i   : std_logic := '0';
  signal d1_i   : std_logic := '0';
  signal y1_o   : std_logic := '0';

  signal output      : std_logic;

  signal i : integer := 0; 
  constant c_TIME : time := 20 ns;

  type t_test_vector is record
    valid_input_v : std_logic;
    data_stream_v : std_logic;
    output_v      : std_logic;
  end record t_test_vector;

  type t_test_vectors is array (natural range <>) of t_test_vector;
  constant c_TEST_VECTOR : t_test_vectors := (
    ('0','0','0'),
    ('0','1','0'),
    ('1','0','1'),
    ('1','1','1'),
	 ('0','0','0'),  
    ('1','1','0')   
  );

begin
  uut : manchester_encoder
    port map (
       clk_i => clk1_i,
       rst_i => rst1_i,
       v_i   => v1_i,
       d_i   => d1_i,
       y_o   => y1_o);

  process
  begin 
    clk1_i <= '0';
    wait for c_TIME/2;
    clk1_i <= '1';
    wait for c_TIME/2;
    
    if i = c_TEST_VECTOR'length then
      wait;
    end if;
  end process;

  process 
  begin
    rst1_i <= '0';
    wait for 40 ns;
    rst1_i <= '1';
    wait;
  end process;

  process
  begin
    v1_i <= c_TEST_VECTOR(i).valid_input_v;
    d1_i <= c_TEST_VECTOR(i).data_stream_v;
    output <= c_TEST_VECTOR(i).output_v;
    
    wait for 5 ns;
    
    if i < c_TEST_VECTOR'length then
      i <= i + 1;
    else
      wait;
    end if;
  end process;

  process
    variable error_status : boolean;
  begin
    wait until clk1_i'event and clk1_i = '1';
    wait for 5 ns;
    
    if y1_o = output then
      error_status := false;
      report "Test case " & integer'image(i) & " passed! Expected: " & std_logic'image(output) & " Actual: " & std_logic'image(y1_o);
    else
      error_status := true;
      report "Test case " & integer'image(i) & " failed! Expected: " & std_logic'image(output) & " Actual: " & std_logic'image(y1_o);
    end if;
    
    assert not error_status
      report "Test failed!"
      severity warning;
    
    if i = c_TEST_VECTOR'length then
      report "All test cases successfully completed!";
    end if;
  end process;
end arch;
