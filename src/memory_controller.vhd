-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity memory_controller is
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
end memory_controller;

architecture behav of memory_controller is
	type states is (C_READY, STABILIZING, READING, WRITING);
type i_state is record 
	state: states;
	nstate: states;
	duration: integer;
	address: std_logic_vector(19 downto 0);
	write_register: std_logic_vector(15 downto 0);
	read_register: std_logic_vector(15 downto 0);
end record;

constant read_cycles: integer := 8;
constant write_cycles: integer := 8;

signal current_state, next_state: i_state;

begin

	main: process(current_state, addr, DQ, WAIT_p, write, operation, enable) is
		variable n : i_state;
		variable c : i_state;
	begin
		n := current_state;
		c := current_state;

		-- if ready, if enable is high, then latch the next address no matter what. 
		if n.state = C_READY then
			if enable = '1' then
				n.address := addr;
				n.duration := 0;
				--n.state := STABILIZING;

			-- if the operation is high, then change state to write
				if operation = '1' then 
					n.state := WRITING;
					n.write_register := write;
				else
					-- by default read
					n.state := READING;
				end if;
			end if;
		elsif n.state = STABILIZING then 
			n.state := c.nstate;
		elsif n.state = WRITING then
			n.duration := n.duration + 1;
			if n.duration = write_cycles then
				n.state := C_READY;
			end if;
			
		else -- read state
			n.duration := n.duration + 1;

			if n.duration = read_cycles then
				n.state := C_READY;
				n.read_register := DQ;
			end if;
		end if;

		-- outputs
		read <= current_state.read_register;
		CLK <= '0';
		write_r <= current_state.write_register;

		--A: out std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		--CLK, ADV, CRE, CE, OE, WE, LB, UB: out std_logic;
		
		if c.state = C_READY then
			A <= (others => 'Z');
			ADV <= '1';
			LB <= '0';
			UB <= '0';
			CE <= '1';
			CRE <= '0'; -- should always be low
			OE <= '1';
			WE <= '1';
			ready <= '1';
			DQ <= (others => 'Z');
		elsif c.state = STABILIZING then
			A <= c.address;
			ADV <= '1';
			LB <= '0';
			UB <= '0';
			CE <= '1';
			CRE <= '0'; -- should always be low
			OE <= '1';
			WE <= '1';
			ready <= '1';
			DQ <= (others => 'Z');
		
		elsif c.state = WRITING then
			A <= c.address;
			ADV <= '0';
			LB <= '0';
			UB <= '0';
			CE <= '0';
			CRE <= '0'; -- should always be low
			OE <= '1';
			WE <= '0';
			ready <= '0';
			DQ <= c.write_register;
		else -- reading
			A <= c.address;
			ADV <= '0';
			LB <= '0';
			UB <= '0';
			CE <= '0'; -- should always be low
			CRE <= '0'; -- should always be low
			OE <= '0';
			WE <= '1';
			ready <= '0';
			DQ <= (others => 'Z');
		end if;

			



		next_state <= n;
	end process;

	tick: process (clock) is
	begin
		if rising_edge(clock) then
			current_state <= next_state;
		end if;
	end process;

end behav;


