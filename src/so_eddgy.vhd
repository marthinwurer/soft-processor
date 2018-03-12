--------------------------------------------------------------------
-- Benjamin Maitland
-- 
-- This package contains global constants (like bit width), as well as 
-- a number of utility functions (like toString, log2, etc).

library IEEE;
use IEEE.STD_LOGIC_1164.all;
USE ieee.numeric_std.all;
use IEEE.math_real.ALL;

package so_eddgy is
	constant N : integer := 8;
	constant n_regs : integer := 8;
	constant bit_width : integer := N;

	subtype data_width_n is std_logic_vector(N-1 downto 0);
	subtype data_width_8 is std_logic_vector(7 downto 0);
	type dwn_array is array (natural range <> ) of data_width_n;

-- type <new_type> is
--  record
--    <type_name>        : std_logic_vector( 7 downto 0);
--    <type_name>        : std_logic;
-- end record;
--
-- Declare constants
--
-- constant <constant_name>		: time := <time_unit> ns;
-- constant <constant_name>		: integer := <value;
--
-- Declare functions and procedure
--
-- function <function_name>  (signal <signal_name> : in <type_declaration>) return <type_declaration>;
-- procedure <procedure_name> (<type_declaration> <constant_name>	: in <type_declaration>);
--
	function i_log2 (x: positive) return natural;
	function to_slv (x: integer; len: integer) return std_logic_vector;
	function toString(x: std_logic_vector) return string;
end so_eddgy;
package body so_eddgy is
	function i_log2 (x: positive) return natural
	is begin
		return integer(ceil(log2(real(x))));
	end i_log2;

	function to_slv (x: integer; len: integer) return std_logic_vector
	is begin
		return std_logic_vector(to_unsigned(x,len));
	end to_slv;

	function toString(x: std_logic_vector) return string
	is 
		variable temp : string(1 to x'length):= (others =>NUL);
		variable index : integer :=1;
	begin
		for i in x'range loop
			temp(index) := std_logic'image(x(i))(2);
			index := index + 1;
		end loop;
		return temp;
	end toString;
---- Example 1
--  function <function_name>  (signal <signal_name> : in <type_declaration>  ) return <type_declaration> is
--    variable <variable_name>     : <type_declaration>;
--  begin
--    <variable_name> := <signal_name> xor <signal_name>;
--    return <variable_name>; 
--  end <function_name>;

---- Example 2
--  function <function_name>  (signal <signal_name> : in <type_declaration>;
--                         signal <signal_name>   : in <type_declaration>  ) return <type_declaration> is
--  begin
--    if (<signal_name> = '1') then
--      return <signal_name>;
--    else
--      return 'Z';
--    end if;
--  end <function_name>;

---- Procedure Example
--  procedure <procedure_name>  (<type_declaration> <constant_name>  : in <type_declaration>) is
--    
--  begin
--    
--  end <procedure_name>;
 
end so_eddgy;
