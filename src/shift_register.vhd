-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity shift_register is
	generic (n: integer);
	port (
		enable, clk, input, reset: in std_logic;
		data: out std_logic_vector(n-1 downto 0);
		last: out std_logic
	);
end shift_register;

architecture behav of shift_register is
signal state : std_logic_vector(n downto 0);
begin
	process(clk, reset,  input) is
	begin
		if reset = '1' then
			state <= (others=>'0');
		elsif rising_edge(clk) then
			if enable = '1' then
				state(n downto 1) <= state(n-1 downto 0);
				state(0) <= input;
			end if;
		end if;
	end process;


	data <= state(n-1 downto 0);
	last <= state(n);


end behav;

