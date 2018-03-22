-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

-- start with 9600 8-N-1
-- 8 bits of data, no parity, and one stop bit

entity simple_rx is
	generic( 
		-- the maximum number of bits that can be recieved by a uart
		max_bits : integer
	);
	port (
		rx: in std_logic;
		clk: in std_logic;

		byte: out std_logic_vector(7 downto 0)
	);
end simple_rx;

architecture behav of simple_rx is
	-- the clock ticks to go from 100MHz to 9600Hz
	constant clk_ticks: integer := 10417; -- 10416.66667
	constant half_ticks: integer := clk_ticks/2;
	constant half_slv: std_logic_vector(i_log2(half_ticks)-1 downto 0) 
								:= to_slv(half_ticks, i_log2(half_ticks));

	constant bits_in: integer := 9; 
	constant stable_width: integer := 2; 

	component shift_register
	generic (n: integer);
	port (
		enable, clk, input, reset, load: in std_logic;
		load_data: in std_logic_vector(n-1 downto 0);
		data: out std_logic_vector(n-1 downto 0);
		last: out std_logic
	);
	end component;

	component counter
	generic (n: integer);
	port (
		enable, reset, clk: in std_logic;
		val: out std_logic_vector(n-1 downto 0)
	);
	end component;

	component load_counter
	generic (n: integer);
	port (
		enable, reset, load, clk: in std_logic;
		load_data: in std_logic_vector(n-1 downto 0);
		val: out std_logic_vector(n-1 downto 0)
	);
	end component;

	signal sr_enable, input, sr_reset, last, load: std_logic; 
	signal sr_data, load_data: std_logic_vector(7 downto 0);

	signal clk_counter: std_logic_vector(7 downto 0);
	signal cc_reset, cc_enable, cc_load: std_logic;

	signal bit_counter: std_logic_vector(i_log2(max_bits) downto 0);
	signal bc_enable, bc_reset: std_logic;

	signal aligned_clk, all_bits: std_logic;

	signal st_load, st_data: std_logic_vector(stable_width-1 downto 0);

	type states is (IDLE, ALIGNING, READING);
	signal c_state: states;
begin

	clock_counter1: entity work.load_counter
	generic map(n=>i_log2(clk_ticks))
	port map(enable=>cc_enable, reset=>cc_enable, load=>cc_load, clk=>clk, 
			 load_data=>half_slv, val=>clk_counter);

	bit_counter1: entity work.counter
	generic map(n=>i_log2(max_bits))
	port map(enable=>bc_enable, reset=>bc_reset, clk=>aligned_clk, val=>bit_counter);

	stabilize: entity work.shift_register
	generic map(n=>2)
	port map(
		enable=>'1', clk=>clk, input=>rx, reset=>'0', load=>'0', 
		load_data=>st_load, data=>st_data, last=>input);

	sr: entity work.shift_register
	generic map(n=>8)
	port map(
		enable=>sr_enable, clk=>aligned_clk, input=>input, reset=>sr_reset, load=>load, 
		load_data=>load_data, data=>sr_data, last=>last);


	aligned_clk <= '1' when to_integer(unsigned(clk_counter)) = clk_ticks else '0';
	all_bits <= '1' when to_integer(unsigned(bit_counter)) = bits_in else '0';


	sr_enable <= '1' when c_state = READING else '0';
	bc_enable <= '1' when c_state = READING else '0';

	cc_enable <= '1' when st_data = (st_data'range => '0') and input = '1' else '0';


	process (aligned_clk, all_bits, input) is
	begin
		if falling_edge(input) and c_state = IDLE then
			c_state <= ALIGNING;
		elsif rising_edge(aligned_clk) then
			c_state <= READING;
		elsif rising_edge(all_bits) then
			c_state <= IDLE;
		end if;
	end process;

end behav;


