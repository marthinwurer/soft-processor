-- Benjamin Maitland
-- unit test the memory controller wrapper
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

ENTITY ut_mc IS
END ut_mc;

ARCHITECTURE behav of ut_mc IS
	component mc_wrapper
	port (
		-- data from the on-chip memory (chip side)
		A: out std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: out std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : in std_logic;

		-- switch data
		inb: in std_logic_vector(7 downto 0);
		-- raw button input
		write_button, read_button, data_button, display_button: in std_logic;
		-- led output
		outb: out std_logic_vector(7 downto 0);

		-- system clock
		clock: in std_logic
);
	end component;
	signal read, write, data, display, clk, adv, 
		cre, ce, oe, we, lb, ub, wait_p, clock: std_logic;
	signal inb, outb: std_logic_vector(7 downto 0);

	constant clock_period : time := 10 ns;
begin

process is 
begin
	-- read in data to data
	-- write data to address
	-- read data from address
	-- read data into data
	-- write data into different address
	-- read data from new address
	-- read data from old address
	
	clock <= '0';
	wait for clock_period/2;
	clock <= '1';
	wait for clock_period/2;
	clock <= '0';
	wait for clock_period/2;

	

	

end process;
end behav;

