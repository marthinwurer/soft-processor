-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity shift_register is
	generic (n: integer);
	port (
		enable, clk, input, reset, load: in std_logic;
		load_data: in std_logic_vector(n-1 downto 0);
		data: out std_logic_vector(n-1 downto 0);
		last: out std_logic
	);
end shift_register;

architecture behav of shift_register is
signal state : std_logic_vector(n downto 0);
begin
	process(clk, reset, input, load) is
	begin
		if reset = '1' then
			state <= (others=>'0');
		elsif rising_edge(clk) then
			if load = '1' then
				state(n downto 0) <= '0' & load_data;
			elsif enable = '1' then
				state(n downto 0) <= input & state(n downto 1);
			end if;
		end if;
	end process;


	data <= state(n downto 1);
	last <= state(0);


end behav;

