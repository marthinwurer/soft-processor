-- Benjamin Maitland
-- unit test the rising edge pulse
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

ENTITY ut_re_pulse IS
END ut_re_pulse;

ARCHITECTURE behav of ut_re_pulse IS
	component alu
	port (
		a, clk: in std_logic;
		o : out std_logic
	);
	end component;
	signal a, o, clk: std_logic; 
begin
	re_pulse1: entity work.re_pulse 
	port map( A=>a, O=>o, clk=>clk);

	process is 
		type io_record is record 
			a: std_logic;
			o: std_logic;
		end record io_record;
		type io_data is array(natural range <>) of io_record;

		constant io: io_data := (
		('0', '0'),
		('1', '1'),
		('1', '0'),
		('1', '0'),
		('1', '0'),
		('0', '0'),
		('1', '1'),
		('0', '0'),
		('0', '0'),
		('0', '0'),
		('0', '0'),
		('1', '1'),
		('1', '0'));

	begin
		for ii in io'range loop

			a <= io(ii).a;
			clk <= '0';
			wait for 50 ns;

			clk <= '1';
			wait for 50 ns;

			assert o = io(ii).o report "ERROR: " & std_logic'image(a)
					& " " & std_logic'image(o) & 
					"; expected " & std_logic'image(io(ii).o);

		end loop;

		wait;
	end process;
	

end behav;

