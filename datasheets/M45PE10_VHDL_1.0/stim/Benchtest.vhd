-----------------------------------------------------
-- Author: Hugues CREUSY
-- December 2003
-- VHDL model
-- project: M45PE10 25 MHz,
-- release: 1.0
-----------------------------------------------------
-- Unit   : Test Bench
-----------------------------------------------------

-------------------------------------------------------------
-- These VHDL models are provided "as is" without warranty
-- of any kind, included but not limited to, implied warranty
-- of merchantability and fitness for a particular purpose.
-------------------------------------------------------------


--------------------------------------------------------------
--				TEST BENCH
--------------------------------------------------------------
LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY WORK;
	USE WORK.MEM_UTIL_PKG.ALL;
LIBRARY STD;
	USE std.textio.ALL;

ENTITY Benchtest IS
END Benchtest;

------------------------------------------------------------
-- Test architecture:
------------------------------------------------------------
ARCHITECTURE test OF Benchtest IS

COMPONENT M45PE10_driver
  PORT( VCC: OUT REAL; 
	  clk: OUT std_logic;
        din: OUT std_logic;
	  cs_valid: OUT std_logic;
        hard_protect: OUT std_logic;
        reset: OUT std_logic
	     ) ;
END COMPONENT ;

COMPONENT M45PE10
GENERIC (init_file : string); 
PORT ( VCC : IN REAL; C, D, S, W,
             RESET: IN std_logic ;
	       	  Q : OUT std_logic);
END COMPONENT ;

SIGNAL Vcc: REAL:=0.0;	
SIGNAL clock, data, W,  Q, RESET: std_logic  ;
SIGNAL S: std_logic;

---------------------------------------------------------
-----------  body of structural architecture ------------
---------------------------------------------------------
BEGIN
Tester: M45PE10_driver
 PORT MAP(VCC=>Vcc,clk=>clock,din=>data,cs_valid=>S,hard_protect=>W, RESET=>RESET);

Memory: M45PE10
GENERIC MAP (init_file => string'("init.txt")) -- memory initialization with user memory content
 PORT MAP(VCC=>Vcc,C=>clock,D=>data,S=>s,W=>W,RESET =>RESET,Q=>Q);  
 
END test;










