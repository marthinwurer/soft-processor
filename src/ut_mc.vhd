-- Benjamin Maitland
-- unit test the memory controller wrapper
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

ENTITY ut_mc IS
END ut_mc;

ARCHITECTURE behav of ut_mc IS
	component mc_wrapper
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
	end component;
	component MT45W1MW16BDGB
	port (
		A: in std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: in std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : out std_logic
	);
	end component;
	signal a: std_logic_vector(19 downto 0);
	signal dq: std_logic_vector(15 downto 0);
	signal clk, adv, cre, ce, oe, we, lb, ub, wait_p: std_logic;
	signal clock: std_logic := '0';
	signal inb, outb: std_logic_vector(7 downto 0);
	signal wb, rb, db, dispb: std_logic;

	constant clock_period : time := 10 ns;
begin


	mc: entity work.mc_wrapper
	port map (A=>a, CLK=>clk, ADV=>adv, CRE=>cre, CE=>ce, OE=>oe, WE=>we, LB=>lb, UB=>ub, DQ=>dq,
				WAIT_p=>wait_p, inb=>inb, write_button=>wb, read_button=>rb, 
				data_button=>db, display_button=>dispb, outb=>outb, clock=>clock);

	chip: entity work.MT45W1MW16BDGB
	port map (A=>a, CLK=>clk, ADV=>adv, CRE=>cre, CE=>ce, OE=>oe, WE=>we, LB=>lb, UB=>lb, DQ=>dq,
				WAIT_p=>wait_p);

	clock <= not clock after clock_period/2;

process is 
begin
	-- read in data to data

	inb <= "00001000";
	db <= '1';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;
	-- read data from address
	db <= '0';
	wb <= '0';
	rb <= '1';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;
	-- write data to address
	db <= '0';
	wb <= '1';
	rb <= '0';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;
	-- read data from address
	db <= '0';
	wb <= '0';
	rb <= '1';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;
	-- read data into data
	inb <= "00011000";
	db <= '1';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;
	-- write data into different address
	db <= '0';
	wb <= '1';
	rb <= '0';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	-- read data from new address
	wait for 100 ns;
	db <= '0';
	wb <= '0';
	rb <= '1';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;
	-- read data from old address
	inb <= "00001000";
	db <= '0';
	wb <= '0';
	rb <= '1';
	dispb <= '0';
	wait for 200 ns;
	db <= '0';
	wb <= '0';
	rb <= '0';
	dispb <= '0';
	wait for 100 ns;


	

	wait;
end process;
end behav;

