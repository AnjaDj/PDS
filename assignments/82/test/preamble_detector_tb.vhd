library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;

entity preamble_detector_tb is
end preamble_detector_tb;

architecture tb_arch of preamble_detector_tb is

    component preamble_detector
      port(
        clk_i   : in   std_logic;
        rst_i   : in   std_logic;
        data_i  : in   std_logic;
        match_o : out  std_logic
      );
    end component;


   signal clk_i  : std_logic := '0';
   signal rst_i  : std_logic := '0';
   signal data_i : std_logic := '0';

   signal match_o : std_logic;

	signal test_in : std_logic_vector(15 downto 0);

   -- clock period definitions and number of clocks
   constant T : time := 20 ns;
	constant num_of_clocks : integer := 170;

	signal i : integer := 0;	-- loop variable

	-- record where some characteristic bit_sequences will be stored and output that corresponds them
	type test_vector is record
	  bit_sequence : std_logic_vector(15 downto 0);
	  match    : std_logic;
	end record;

	type test_vector_array is array(natural range<>) of test_vector;
	constant test_vectors : test_vector_array := (
	  ("0000000110101010", '1'),
	  ("0000010010101010", '1'),
	  ("0000010110101010", '1'),
	  ("0001010010101010", '1'),
	  ("0001010110101010", '1'),
	  ("0101010010101010", '1'),
	  ("0101010110101010", '1'),
	  ("0000000010101010", '1'),
	  ("0110110110110110", '0')
	);


begin

 -- Instantiate the preamble detector in VHDL
   uut: preamble_detector PORT MAP (
          clk_i => clk_i,
          rst_i => rst_i,
          data_i => data_i,
          match_o => match_o
        );

   -- stimulus generator for reset
	rst_i <= '1', '0' after T/2;

   -- stimulus for continous clock
   process
   begin
     clk_i <= '0';
     wait for T/2;
     clk_i <= '1';
     wait for T/2;
	  if(i = num_of_clocks) then
	    wait;
	  else i <= i + 1;
	  end if;
   end process;

  -- stimulus and verifier process
  process
  begin

	 for i in test_vectors'range loop

	   test_in <= test_vectors(i).bit_sequence;
		wait for T;
		for j in 0 to 15 loop
		  data_i <= test_in(15-j);
		  wait for T;
		end loop;

		report "Test bit_sequence " & integer'image(i) & ", " &
		"for input bit_sequence " & std_logic'image(test_in(15)) & std_logic'image(test_in(14)) & std_logic'image(test_in(13)) &
	   std_logic'image(test_in(12)) & std_logic'image(test_in(10)) & std_logic'image(test_in(9)) & std_logic'image(test_in(8)) &
	   std_logic'image(test_in(7)) & std_logic'image(test_in(6)) & std_logic'image(test_in(5)) & std_logic'image(test_in(3)) &
		std_logic'image(test_in(3)) & std_logic'image(test_in(2)) & std_logic'image(test_in(1)) & std_logic'image(test_in(0)) &
 	   " Expected output is " & std_logic'image(test_vectors(i).match) & " and we get " & std_logic'image(match_o) & ".";

		assert(match_o = test_vectors(i).match)
		report "Test bit_sequence " & integer'image(i) & " failed " &
		"for bit_sequence given above. Test failed!"
	   severity failure;

	 end loop;
    wait;
  end process;

end tb_arch;