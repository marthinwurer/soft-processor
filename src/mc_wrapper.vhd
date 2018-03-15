-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity mc_wrapper is
	port (
		-- data from the on-chip memory (chip side)
		A: out std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: out std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : in std_logic;

		-- switch data
		inb: in std_logic_vector(7 downto 0);
		-- raw button input
		write_button, read_button, data_button, display_button: in std_logic;
		-- led output
		outb: out std_logic_vector(7 downto 0);

		-- system clock
		clock: in std_logic
);
end mc_wrapper;

architecture behav of mc_wrapper is
	component memory_controller 
	port (
		-- data from the on-chip memory (chip side)
		A: out std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: out std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : in std_logic;


	-- processor side 
		addr: in std_logic_vector(19 downto 0);
		clock: in std_logic;
		operation: in std_logic; -- if low, read; if high, write
		enable: in std_logic; -- enable high
		write: in std_logic_vector(15 downto 0);
		read: out std_logic_vector(15 downto 0);
		ready: out std_logic; -- high if ready

		-- debug
		write_r: out std_logic_vector(15 downto 0)
	);
	end component;

	component re_pulse
	port (
		a, clk: in std_logic;
		o : out std_logic
	);
	end component;

	-- addresses going off chip and into the controller
	signal addr: std_logic_vector(19 downto 0); 
	-- all from memory controller
	signal operation, enable, ready: std_logic;
	-- byte to display, byte from switches, latched address, latched data
	signal switch_addr, data: std_logic_vector(7 downto 0);

	-- I/O from controller and to chip
	signal write, read: std_logic_vector(15 downto 0);
	-- button pulse output
	signal write_pressed, read_pressed, data_pressed: std_logic;


begin
	mem_cont: entity work.memory_controller
	port map (A=>A, CLK=>CLK, ADV=>ADV, CRE=>CRE, CE=>CE, OE=>OE, WE=>WE, LB=>LB, UB=>UB,
				DQ=>Dq, WAIT_p=>WAIT_p, addr=>addr, clock=>clock, operation=>operation,
				enable=>enable, write=>write, read=>read, ready=>ready);

	wb: entity work.re_pulse
	port map (a=>write_button, clk=>clock, o=>write_pressed);
	rb: entity work.re_pulse
	port map (a=>read_button, clk=>clock, o=>read_pressed);
	db: entity work.re_pulse
	port map (a=>data_button, clk=>clock, o=>data_pressed);

	enable <= write_pressed or read_pressed;
	operation <= write_pressed;
	addr(19 downto 8) <= (others=>'0');
	addr(7 downto 0) <= switch_addr;
	write(15 downto 8) <= (others=>'0');
	write(7 downto 0) <= data;

	switch_addr <= inb;


	process (clock, data_pressed) is
	begin
		if rising_edge(clock) then
			if data_pressed = '1' then
				data <= inb;
			end if;
			if display_button = '1' then
				outb <= data;
			else
				outb <= read(7 downto 0);
			end if;

		end if;
	end process;
				
end behav;

