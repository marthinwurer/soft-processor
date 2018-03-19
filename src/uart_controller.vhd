-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity uart_controller is
	port (
		rx: in std_logic;
		clk: in std_logic;

		tx: out std_logic;
		byte: out std_logic_vector(7 downto 0)


	);
end uart_controller;

architecture behav of uart_controller is
	component shift_register
	generic (n: integer);
	port (
		enable, clk, input, reset: in std_logic;
		data: out std_logic_vector(n-1 downto 0);
		last: out std_logic
	);
	end component;
	signal enable, input, reset, last, clk: std_logic; 
	signal data: std_logic_vector(7 downto 0);
begin
	sr: entity work.shift_register
	generic map(n=>8)
	port map(
		enable=>enable, clk=>clk, input=>input, reset=>reset, 
		data=>data, last=>last);
end behav;
