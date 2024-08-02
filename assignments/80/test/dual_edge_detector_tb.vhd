library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dual_edge_detector_tb is
end dual_edge_detector_tb;

architecture arch of dual_edge_detector_tb is

  component dual_edge_detector is
    port (
      clk_i    : in  std_logic;
      rst_i    : in  std_logic;  
      strobe_i : in  std_logic;
      p_o     : out std_logic
    );
  end component;

  signal clk_tb    : std_logic;
  signal rst_tb    : std_logic;  
  signal strobe_tb : std_logic;
  signal p1_tb     : std_logic;
  signal p1_comp   : std_logic;
  signal i         : integer := 0;

  type t_moore_test_vector is record
    strobe_v : std_logic;
    p1_v     : std_logic;
  end record t_moore_test_vector;

  type t_moore_test_vector_array is array (natural range <>) of t_moore_test_vector;

  constant c_MOORE_TEST_VECTORS : t_moore_test_vector_array := (
    ('0', '0'),
    ('1', '1'),
    ('1', '0'),
    ('1', '0'),
    ('0', '0'),
    ('1', '1'),
    ('0', '0')
  );

begin

  uut : dual_edge_detector
    port map(
      clk_i     => clk_tb,
      rst_i     => rst_tb,  
      strobe_i  => strobe_tb,
      p_o      => p1_tb
    );

  process
  begin
    clk_tb <= '0';
    rst_tb <= '0';
    wait for 10 ns;
    clk_tb <= '1';
    rst_tb <= '0';
    wait for 10 ns;

    if i = c_MOORE_TEST_VECTORS'length then
      report "Simulation finished.";
      wait;
    end if;

  end process;

  process
  begin
    strobe_tb <= c_MOORE_TEST_VECTORS(i).strobe_v;
    p1_comp   <= c_MOORE_TEST_VECTORS(i).p1_v;
    wait for 15 ns;

    if i < c_MOORE_TEST_VECTORS'length then
      i <= i + 1;
    else
      report "All test vectors processed.";
      wait;
    end if;

  end process;

  process
    variable error_status : boolean;
  begin

    wait until rising_edge(clk_tb);

    -- Add a delay after the clock edge for proper simulation
    wait for 5 ns;

    -- Check if the output matches the expected value
    if p1_tb = p1_comp then
      error_status := false;
      report "Test vector " & integer'image(i) & " passed.";
    else
      error_status := true;
      report "Test vector " & integer'image(i) & " failed. Expected: " & std_logic'image(p1_comp) & ", Got: " & std_logic'image(p1_tb);
    end if;

    -- Assert on the error status
    assert not error_status
      report "Test Failed!"
      severity error;

  end process;

end arch;
