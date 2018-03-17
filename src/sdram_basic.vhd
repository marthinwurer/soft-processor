-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity sdram_basic is
	port (
		A: in std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: in std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : out std_logic
	);
end sdram_basic;

architecture behav of sdram_basic is
constant tAA : time := 70 ns;
constant tAADV : time := 70 ns;
constant tAPA : time := 20 ns;
constant tAVH : time := 5 ns;
constant tAVS : time := 10 ns;
constant tBHZ : time := 8 ns;
constant tBLZ : time := 10 ns;
constant tCEM : time := 8      us;
constant tCEW_min : time := 1 ns;
constant tCEW_max : time := 7.5 ns;
constant tCO : time := 70 ns;
constant tCVS : time := 10 ns;
constant tHZ : time := 8 ns;
constant tLZ : time := 10 ns;
constant tOE : time := 20 ns;
constant tOH : time := 5 ns;
constant tOHZ : time := 8 ns;
constant tOLZ : time := 3 ns;
constant tPC : time := 20 ns;
constant tRC : time := 70 ns;
constant tVP : time := 10 ns;
constant tVPH : time := 10 ns;
constant tWHZ : time := 8 ns;
constant tAW : time := 70 ns;
constant tBW : time := 70 ns;
constant tCW : time := 70 ns;
constant tOW : time := 70 ns;
constant tDW : time := 23 ns;
constant tWP : time := 46 ns;

signal out_reg : std_logic_vector(15 downto 0) := "XXXXXXXXXXXXXXXX";
signal read_ready, write_ready : std_logic; -- changes when a read is ready
begin

memory: process( read_ready, write_ready) is

type mem_arr is array (natural range <>) of std_logic_vector(15 downto 0);

variable mem: mem_arr(2**20 - 1 downto 0);

begin
		if rising_edge(write_ready) then
			mem(to_integer(unsigned(A))) := DQ;
		elsif rising_edge(read_ready) then
			out_reg <= mem(to_integer(unsigned(A)));
			--out_reg <= A(15 downto 0);
		else
			out_reg <= (others=>'X');
		end if;
end process;


read_ready <= '1' when 
		A'STABLE(tAA) and 
			CE = '0' and CE'STABLE(tCO) and 
			OE = '0' and OE'stable(tOE)
			else '0';

write_ready <= '1' when 
		A'STABLE(tAA) and 
			CE = '0' and CE'STABLE(tCW) and 
			WE = '0' and WE'stable(tWP) and
			DQ'stable(tDW)
			else '0';

DQ <= out_reg when CE = '0' and CE'stable(tLZ) 
					and OE = '0' and OE'stable(tOLZ) 
					else (others=> 'Z');










end behav;




