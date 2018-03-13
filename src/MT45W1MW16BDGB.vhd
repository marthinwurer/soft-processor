-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity MT45W1MW16BDGB is
	port (
		A: in std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: in std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : out std_logic
	);
end MT45W1MW16BDGB;

architecture behav of MT45W1MW16BDGB is
begin
process (A, CLK, ADV, CRE, CE, OE, WE, LB, UB, DQ) is
	subtype word : std_logic_vector(15 downto 0);
	subtype memory : array(natural range <>) of word;
	variable memory_cells: memory(2**20-1 downto 0);
begin
	

end process;
end behav;

