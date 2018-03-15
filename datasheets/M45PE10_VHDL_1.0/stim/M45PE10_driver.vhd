-----------------------------------------------------
-- Author: Hugues CREUSY
-- December 2003
-- VHDL model
-- project: M45PE10 25 MHz,
-- release: 1.0
-----------------------------------------------------
-- Unit   : M45PE10 driver
-----------------------------------------------------

-------------------------------------------------------------
-- These VHDL models are provided "as is" without warranty
-- of any kind, included but not limited to, implied warranty
-- of merchantability and fitness for a particular purpose.
-------------------------------------------------------------

-------------------------------------------------------------
--				M45PE10 DRIVER
-------------------------------------------------------------

LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY WORK;
	USE WORK.stimuli_spi.ALL;

-------------------------------------------------------------
--				ENTITY
-------------------------------------------------------------
ENTITY M45PE10_driver IS
  
 PORT(	VCC: OUT REAL;
	clk: OUT std_logic;
	din: OUT std_logic;
	cs_valid: OUT std_logic;
	hard_protect: OUT std_logic;
	reset: OUT std_logic
	);

END M45PE10_driver;

architecture BENCH of M45PE10_driver is 

begin
driver: process

	CONSTANT thigh : TIME := 22 ns;
	CONSTANT tlow  : TIME := 22 ns;

	begin

clk<='0';
din<='1';
cs_valid<='1';
hard_protect<='1';
reset <='1';
ALIM(1 ns ,5 ns, 100 ms,300 ms,0.0,2.5,2.7,3.5,3.3,Vcc);

WAIT FOR 15000 us;

READ_ID (thigh,tlow,23,clk,din,cs_valid); --n=23, 24 clock cycle, output ID = 20,40,12
	 WAIT FOR 10*tLOW;

-- Checking memory initialization at higher speed
fast_READ (thigh,tlow,"000000100000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000000110000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000001000000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000001010000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000001100000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000001110000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000010000000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000010010000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000010100000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000010110000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000011000000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000011010000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000011100000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
fast_READ (thigh,tlow,"000011110000000000000000", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;


		
-- WREN/WRDI test
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
WRDI(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW; 
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;


-- op_codes sent during Deep Power Down Mode + RDP test
DP(thigh,tlow,clk,din,cs_valid);
	  WAIT FOR 3 us;
--WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW; 
--RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
RDP ( thigh,tlow,clk,din,cs_valid);
        WAIT FOR 31 us;
WREN(thigh,tlow,clk,din,cs_valid);
         WAIT FOR 3 us;
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW; 
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW; 

-- PE + reset test
READ (thigh,tlow,"111111111111111100000000", 256, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
PE (thigh, tlow,"111111111111111100000000",clk,din, cs_valid, reset);	
	 WAIT FOR 10*tLOW;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
RESET <='1';                                                                                                -- wel should be reset
	  WAIT FOR 20001 us;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
READ (thigh,tlow,"111111111111111100000000", 256, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;

-- SE + reset test
READ (thigh,tlow,"111111111111111100000000", 256, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
SE (thigh, tlow,"111111111111111100000000",clk,din, cs_valid, reset);	
	 WAIT FOR 10*tLOW;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
RESET <='1';                                                                                                -- wel should be reset
	  WAIT FOR 20001 us;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
READ (thigh,tlow,"111111111111111100000000", 256, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;


-- PP + reset test
READ (thigh,tlow,"000000001111111111111111", 256, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
PP (thigh,tlow,  "000000001111111111111111","10101010", 15, clk,din,cs_valid, reset);
	 WAIT FOR 10*tLOW;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
RESET <='0';                                                                                              
	  WAIT FOR 4000 us;
RESET <='1';                                                                                                -- wel should be reset
	  WAIT FOR 4001 us;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
READ (thigh,tlow,"000000001111111111111111", 32, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;

-- PW + reset test
READ (thigh,tlow,"000000001111111111111111", 256, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
PW (thigh,tlow,  "000000001111111111111111","10101010", 15, clk,din,cs_valid, reset);
	 WAIT FOR 10*tLOW;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
RESET <='0';                                                                                               
	  WAIT FOR 12500 us;
RESET <='1';                                                                                               
	  WAIT FOR 12501 us;
RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;
READ (thigh,tlow,"000000001111111111111111", 32, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;

-- Reset pin timings
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
RDSR(thigh,tlow,1,clk,din,cs_valid);
        WAIT FOR 10*tLOW;
 PW (thigh,tlow,  "000000001111111111111111","10101010", 15, clk,din,cs_valid, reset);
        WAIT FOR 3 us;
       RDSR(thigh,tlow,1,clk,din,cs_valid);
	 WAIT FOR 3 ms;
        RESET <= '0';
        WAIT FOR 3 ms;
        RESET <= '1';
       WAIT FOR 5 us;
       RDSR(thigh,tlow,1,clk,din,cs_valid);
        WAIT FOR 19 ms;
        WAIT FOR 3 us;
       RDSR(thigh,tlow,1,clk,din,cs_valid);
        WAIT FOR 3 us;
        READ (thigh,tlow,"000000001111111111111111", 15, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  

---- READ programmed bytes preceded and followed by one non programmed byte
WREN(thigh,tlow,clk,din,cs_valid);
	 WAIT FOR 10*tLOW;  
READ (2*thigh,2*tlow,"000011111100001111000010", 17, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;

-- Program 55h on AAh
PW (thigh,tlow,  "000011111100001111000011","01010101", 15, clk,din,cs_valid, reset);
	  --WAIT FOR 4965 us; 
	  WAIT FOR 25 ms; 
RDSR(thigh,tlow,120,clk,din,cs_valid); 
	 WAIT FOR 10*tLOW;

-- READ: AAh+55h=>00h
--READ (2*thigh,2*tlow,"000011111100001111000010", 17, clk,din,cs_valid);
	 WAIT FOR 10*tLOW;

ALIM(25 ns ,100 ns, 1 ms,3 ms,3.2,2.7,2.5,0.2,0.05,Vcc);

WAIT;
end process;
	
end BENCH;