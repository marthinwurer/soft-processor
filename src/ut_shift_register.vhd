-- Benjamin Maitland
-- unit test the shift register
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;

ENTITY ut_shift_register IS
END ut_shift_register;

ARCHITECTURE behav of ut_shift_register IS
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

	process is 
		type io_record is record 
			enable: std_logic;
			input: std_logic;
			reset: std_logic;
			last: std_logic;
			data: std_logic_vector(7 downto 0);
		end record io_record;
		type io_data is array(natural range <>) of io_record;

		constant io: io_data := (
			('1','1','0','0',"00000001"),
			('1','1','0','0',"00000011"),
			('1','0','0','0',"00000110"),
			('1','0','0','0',"00001100"),
			('1','1','0','0',"00011001"),
			('1','0','0','0',"00110010"),
			('1','1','0','0',"01100101"),
			('1','0','0','0',"11001010"),
			('1','1','0','1',"10010101"),
			('1','1','0','1',"00101011"),
			('1','1','0','0',"01010111"),
			('1','0','0','0',"10101110"),
			('1','1','0','1',"01011101"),
			('1','0','0','0',"10111010"));

	begin
		reset <= '0';
		load <= '1';
		load_data <= "11111111";
		clk <= '0';
		wait for 50 ns;
		
		reset <= '0';
		clk <= '1';
		wait for 50 ns;
		assert data = "11111111" report "ERROR: load didn't work";
		load <= '0';

		reset <= '1';
		clk <= '0';
		wait for 50 ns;
		
		reset <= '0';
		clk <= '1';
		wait for 50 ns;

		for ii in io'range loop

			enable <= io(ii).enable;
			input <= io(ii).input;
			reset <= io(ii).reset;
			clk <= '0';
			wait for 50 ns;

			clk <= '1';
			wait for 50 ns;

			assert last = io(ii).last and data = io(ii).data report 
					"ERROR: (" 
					& std_logic'image(last) 	& ", " & toString(data) & 
					"); expected ("
					& std_logic'image(io(ii).last) 	& ", " & toString(io(ii).data) & ")";

		end loop;

		wait;
	end process;
	

end behav;

