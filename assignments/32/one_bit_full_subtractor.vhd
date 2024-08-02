library ieee;
use ieee.std_logic_1164.all;


entity one_bit_full_subtractor is
    port (X : in std_logic;
          Y : in std_logic;
          B_in : in std_logic;
          Diff : out std_logic;
          B_out : out std_logic);
end one_bit_full_subtractor;

architecture onebit_arch of one_bit_full_subtractor is

begin

  Diff <= X xor Y xor B_in;
  B_out <= ((not X) and (B_in or Y)) or ( Y and B_in);
  
end onebit_arch;