-- Benjamin Maitland
-- This entity takes an input and an output. For the first clock cycle 
-- that the input is high, the output is high. The output is low the rest of the time.
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity re_pulse is
	port (
		a, clk: in std_logic;
		o : out std_logic
	);
end re_pulse;

architecture behav of re_pulse is
	signal previous: std_logic;
begin
process (clk, a) is
begin
	if rising_edge(clk) then
		if a = previous then
			o <= '0'; -- if prevoiusly the same, set to low.
		else
			o <= a; -- set to current
		end if;
		previous <= a;
	end if;

end process;
end behav;

