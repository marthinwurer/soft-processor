-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

-- start with 9600 8-N-1
-- 8 bits of data, no parity, and one stop bit

entity rx_module is
	generic( 
		-- the maximum number of bits that can be recieved by a uart
		max_bits : integer:=8
	);
	port (
		rx: in std_logic;
		clk: in std_logic;
		reset: in std_logic;

		byte: out std_logic_vector(7 downto 0)
	);
end rx_module;

architecture behav of rx_module is
	-- the clock ticks to go from 100MHz to 9600Hz
	constant clk_ticks: integer := 10417; -- 10416.66667
	constant clk_bits: integer := i_log2(clk_ticks);
	constant half_ticks: integer := clk_ticks/2;
	constant half_slv: std_logic_vector(clk_bits-1 downto 0) 
								:= to_slv(half_ticks, clk_bits);

	constant bits_in: integer := 8; 
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
	
	component stabilizer
	generic (n: integer);
	port (
		clk, input: in std_logic;
		last, re, fe: out std_logic
	);
	end component;


	signal sr_enable, input, sr_reset, last, load: std_logic; 
	signal sr_data, load_data: std_logic_vector(7 downto 0);

	signal clk_counter: std_logic_vector(clk_bits-1 downto 0);
	signal cc_reset, cc_enable, cc_load: std_logic;

	signal bit_counter: std_logic_vector(3 downto 0);
	signal bc_enable, bc_reset: std_logic;

	signal input_fe, input_re: std_logic;

	signal aligned_clk, all_bits: std_logic;

	constant IDLE: std_logic_vector(2 downto 0)			:="001";
	constant ALIGNING: std_logic_vector(2 downto 0)		:="010";
	constant READING: std_logic_vector(2 downto 0)		:="100";
	signal c_state: std_logic_vector(2 downto 0);
begin

	clock_counter1: entity work.load_counter
	generic map(n=>clk_bits)
	port map(enable=>cc_enable, reset=>cc_reset, load=>cc_load, clk=>clk, 
			 load_data=>half_slv, val=>clk_counter);

	bit_counter1: entity work.counter
	generic map(n=>4)
	port map(enable=>bc_enable, reset=>bc_reset, clk=>clk, val=>bit_counter);

	stabilize: entity work.stabilizer
	generic map(n=>2)
	port map(
		clk=>clk, input=>rx, 
		last=>input, fe=>input_fe, re=>input_re);

	sr: entity work.shift_register
	generic map(n=>8)
	port map(
		enable=>sr_enable, clk=>clk, input=>input, reset=>sr_reset, load=>load, 
		load_data=>load_data, data=>sr_data, last=>last);


	aligned_clk <= '1' when to_integer(unsigned(clk_counter)) = clk_ticks else '0';
	all_bits <= '1' when bit_counter = to_slv(bits_in, 4) else '0';

	


	sr_enable <= '1' when c_state = READING and aligned_clk = '1' else '0';
	bc_enable <= '1' when c_state = READING and aligned_clk = '1' else '0';
	cc_enable <= '1';
	sr_reset <= '0';
	load <= '0';
	load_data <= (others=>'0');

	cc_reset <= '1' when aligned_clk = '1' else '0';
	cc_load <= '1' when input_fe = '1' and c_state /= reading else '0';
	bc_reset <= cc_load;

	byte(7 downto 3) <= sr_data(7 downto 3);
	byte(2 downto 0) <= c_state;


	process (clk, reset, aligned_clk, all_bits, input, input_fe, c_state) is
	begin
		if reset = '1' then
			c_state <= IDLE;
		elsif rising_edge(clk) then
			if input_fe = '1' and c_state = IDLE then
				c_state <= ALIGNING;
			elsif aligned_clk = '1' and c_state = ALIGNING then
				c_state <= READING;
			elsif all_bits = '1' then
				c_state <= IDLE;
				--byte <= sr_data;
			else
				c_state <= c_state;
			end if;
		end if;
	end process;

end behav;


