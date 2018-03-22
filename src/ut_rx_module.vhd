-- Benjamin Maitland
-- unit test the rx module
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

ENTITY ut_rx_module IS
END ut_rx_module;

ARCHITECTURE behav of ut_rx_module IS
	component rx_module
	generic( 
		-- the maximum number of bits that can be recieved by a uart
		max_bits : integer
	);
	port (
		rx: in std_logic;
		clk: in std_logic;
		reset: in std_logic;

		byte: out std_logic_vector(7 downto 0)
	);
	end component;
	signal clock: std_logic := '0';
	signal outb: std_logic_vector(7 downto 0);
	signal rx, reset: std_logic;

	constant clock_period : time := 10 ns;
	constant uart_clk_period : time := 104 us;
begin

	rx_mod: entity work.rx_module
	generic map (max_bits=>9)
	port map(rx=>rx, clk=>clock, reset=>reset, byte=>outb);


	clock <= not clock after clock_period/2;

process is 

	constant data : std_logic_vector(7 downto 0) := "10010010";
begin
	-- read in data to data
	reset <= '1';
	rx <= '1';
	wait for 10 us;
	reset <= '0';
	wait for 305 us;
	
	rx <= '0';
	wait for uart_clk_period;

	for ii in data'reverse_range loop
		rx <= data(ii);
		wait for uart_clk_period;
	end loop;

	rx <= '1';
	wait for uart_clk_period;
	

	



	

	wait;
end process;
end behav;


