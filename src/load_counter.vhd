-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity load_counter is
	generic (n: integer);
	port (
		enable, reset, load, clk: in std_logic;
		load_data: in std_logic_vector(n-1 downto 0);
		val: out std_logic_vector(n-1 downto 0)
	);
end load_counter;

architecture behav of load_counter is
signal state : std_logic_vector(n-1 downto 0);
begin
	val <= state;
	process(clk, reset, load, enable) is
	begin
		if rising_edge(clk) then
			if load = '1' then
				state <= load_data;
			elsif reset = '1' then
				state <= (others=>'0');
			elsif enable = '1' then
				state <= to_slv(to_integer(unsigned(state)) + 1, n);
			end if;
		end if;
	end process;
end behav;



