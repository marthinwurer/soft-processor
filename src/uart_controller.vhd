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
		enable, clk, input, reset, load: in std_logic;
		load_data: in std_logic_vector(n-1 downto 0);
		data: out std_logic_vector(n-1 downto 0);
		last: out std_logic
	);
	end component;
	signal enable, input, reset, last, load, clk: std_logic; 
	signal data, load_data: std_logic_vector(7 downto 0);
begin
	sr: entity work.shift_register
	generic map(n=>8)
	port map(
		enable=>enable, clk=>clk, input=>input, reset=>reset, load=>load, 
		load_data=>load_data, data=>data, last=>last);


end behav;
