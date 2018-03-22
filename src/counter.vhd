-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity counter is
	generic (n: integer);
	port (
		enable, reset, clk: in std_logic;
		val: out std_logic_vector(n-1 downto 0)
	);
end counter;

architecture behav of counter is
signal state : std_logic_vector(n-1 downto 0);
begin
	val <= state;
	process(clk, reset) is
	begin
		if rising_edge(clk) then
			if reset = '1' then
				state <= (others=>'0');
			elsif enable = '1' then
				state <= to_slv(to_integer(unsigned(state)) + 1, n);
			end if;
		end if;
	end process;
end behav;


