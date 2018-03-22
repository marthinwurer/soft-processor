-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity stabilizer is
	generic (n: integer);
	port (
		clk, input: in std_logic;
		last, re, fe: out std_logic
	);
end stabilizer;

architecture behav of stabilizer is
signal state: std_logic_vector(n downto 0);
signal data_i : std_logic_vector(n-1 downto 0);
signal last_i: std_logic;
begin
	process(clk, input) is
	begin
		if rising_edge(clk) then
			state(n downto 0) <= state(n-1 downto 0) & input;
		end if;
	end process;


	data_i <= state(n-1 downto 0);
	last_i <= state(n);

	re <= '1' when data_i = (data_i'range=>'1') and last_i = '0' else '0'; 
	fe <= '1' when data_i = (data_i'range=>'0') and last_i = '1' else '0'; 


	last <= last_i;


end behav;

