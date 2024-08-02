library ieee;
use ieee.std_logic_1164.all;

entity preamble_generator_tb is
end preamble_generator_tb;

architecture arch of preamble_generator_tb is
  component preamble_generator
    port (
      clk_i   : in std_logic;
      rst_i   : in std_logic;
      start_i : in std_logic;
      data_o  : out std_logic
    );
  end component;

  constant c_T : time := 20 ns;
  constant c_PREAMBLE : std_logic_vector(7 downto 0) := "10101010";

  signal test_clk   : std_logic;
  signal test_rst   : std_logic;
  signal test_start : std_logic;
  signal test_data  : std_logic;
begin

  -- Component instantiation
  uut : preamble_generator port map (
    clk_i      => test_clk,
    rst_i      => test_rst,
    start_i    => test_start,
    data_o     => test_data
  );

  test_rst <= '1', '0' after c_T/2;

  -- Clock generation
  process
  begin
    test_clk <= '0';
    wait for c_T/2;
    test_clk <= '1';
    wait for c_T/2;
  end process;

  -- Start generator
  process
  begin
    test_start <= '0';
    wait for c_T;
    test_start <= '1';
    wait for c_T;
    test_start <= '0';
    wait for c_T*10;
    test_start <= '1', '0' after c_T;
    wait for c_T*4;
    test_start <= '1', '0' after c_T;
  end process;

  -- Testbench process
  process
    variable v_count : natural range 0 to 8 := 0;
    variable v_enbl  : std_logic := '0';
  begin
    wait until rising_edge(test_clk);
    wait for c_T/5;

    if test_start = '1' then
      v_enbl := '1';
      v_count := 0;
    end if;

    if v_enbl = '1' then
      assert (test_data = c_PREAMBLE(v_count))
        report "Output bit " & std_logic'image(test_data) & " not equal to preamble bit " &
               std_logic'image(c_PREAMBLE(v_count))
               severity error;

      if v_count /= 7 then
        v_count := v_count + 1;
      else
        v_enbl := '0';
        v_count := 0;
      end if;
    end if;
  end process;

  -- Stop simulation process
  process
  begin
    wait for c_T*30;
    assert false
      report "Test completed."
      severity failure;
  end process;

end arch;
