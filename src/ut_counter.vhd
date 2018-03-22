-- Benjamin Maitland
-- unit test the counter
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

ENTITY ut_counter IS
END ut_counter;

ARCHITECTURE behav of ut_counter IS
	component counter
	port (
		enable, reset, clk: in std_logic;
		val: out std_logic_vector(n-1 downto 0)
	);
	end component;
	signal enable, reset, clk: std_logic; 
	signal value, val: std_logic_vector(7 downto 0);
begin
	sr: entity work.counter
	generic map(n=>8)
	port map(
		enable=>enable, reset=>reset, clk=>clk, val=>value);

	process is 
	begin
		reset <= '1';
		clk <= '0';
		wait for 5 ns;
		
		clk <= '1';
		wait for 5 ns;

		enable <= '1';
		reset <= '0';

		for ii in 1 to 255 loop

			clk <= '0';
			wait for 5 ns;

			clk <= '1';
			wait for 5 ns;

			assert to_integer(unsigned(value)) = ii report 
							"ERROR: " & integer'image(to_integer(unsigned(value))) & " != "
							& integer'image(ii);


		end loop;

		wait;
	end process;
	

end behav;


