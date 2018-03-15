-----------------------------------------------------
-- Author: Hugues CREUSY
-- December 2003
-- VHDL model
-- project: M45PE10 25 MHz,
-- release: 1.0
-----------------------------------------------------
-- Unit   : stimuli_spi
-----------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use WORK.ALL;

----------------------------------------------------------------------------------------------------
-- This package groups all stimuli procedures corresponding to each M45PE10 instruction. 
-- They can be used to write complete benchtest as the M45PE10 driver provided with this model.
-- 
-- tHIGH,tLOW: clock high and low times during the operation

PACKAGE stimuli_spi IS
  
  -- STOP: puts pin /H low after t0, high after t1
  PROCEDURE stop (CONSTANT t0,t1: IN TIME; SIGNAL nH: OUT STD_LOGIC); 

  -- WAITC: generation of dummy clock pulses (to introduce delays)
  PROCEDURE WAITC (CONSTANT thigh,tlow : IN TIME; CONSTANT n : IN INTEGER; SIGNAL C : OUT STD_LOGIC);

  -- PIN_W: put the /W pin to 0 during t time
  PROCEDURE pin_W (CONSTANT t: IN TIME; SIGNAL nW : OUT STD_LOGIC);

  -- RDSR: read status register instruction (loop mode if n>1)
  PROCEDURE RDSR (CONSTANT thigh,tlow : IN TIME; CONSTANT n : IN INTEGER; SIGNAL C,D,nS: OUT STD_LOGIC);

  -- WRSR: fill in status register with constant STATUS.
  PROCEDURE WRSR (CONSTANT thigh,tlow : IN TIME; CONSTANT status : IN STD_LOGIC_VECTOR (7 downto 0); SIGNAL C,D,nS : OUT STD_LOGIC);

  -- WRSR_wc0: fill in status register with constant STATUS toggling wc       debug only.
  PROCEDURE WRSR_wc0 (CONSTANT thigh,tlow : IN TIME; CONSTANT status : IN STD_LOGIC_VECTOR (7 downto 0); SIGNAL C,D,nS, nW : OUT STD_LOGIC);

  -- WREN: executes write enable instruction
  PROCEDURE WREN (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS : OUT STD_LOGIC); 

  -- WREN: executes write enable instruction with wc0                                debug only
  PROCEDURE WREN_wc0 (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS,nW : OUT STD_LOGIC); 

  -- WRDI: executes write disable instruction
  PROCEDURE WRDI (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS : OUT STD_LOGIC); 

  -- READ: reads n bytes from byte pointed by ADDRESS 
  PROCEDURE READ (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS : OUT STD_LOGIC);

  -- fast_READ: read n bytes from byte pointed by address at higher speed
  PROCEDURE FAST_READ (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS : OUT STD_LOGIC);

  -- PP: sends n times DATA from ADDRESS in page program mode. If n exceeds 256, DATA automatically becomes 00h (useful to test roll-over) 
  PROCEDURE PP (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT data : IN STD_LOGIC_VECTOR (7 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS, nRESET : OUT STD_LOGIC);

  -- PW: sends n times DATA from ADDRESS in page program mode. If n exceeds 256, DATA automatically becomes 00h (useful to test roll-over) 
  PROCEDURE PW (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT data : IN STD_LOGIC_VECTOR (7 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS, nRESET : OUT STD_LOGIC);

  -- SE: erases the sector defined by ADDRESS
  PROCEDURE SE (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); SIGNAL C,D,nS,nRESET : OUT STD_LOGIC);  

  -- PE: erases the Page defined by ADDRESS
  PROCEDURE PE (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); SIGNAL C,D,nS, nRESET: OUT STD_LOGIC);  


  -- DP: enters in deep power down mode
  PROCEDURE DP (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS : OUT STD_LOGIC); 

  -- RDP: releases from deep power down
  PROCEDURE RDP (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS : OUT STD_LOGIC); 

  -- Read_ID: reads JEDEC ID
  PROCEDURE Read_ID (CONSTANT thigh,tlow : IN TIME;CONSTANT n : IN INTEGER; SIGNAL C,D,nS : OUT STD_LOGIC);  

 -- ALIM: simulates a simple power up operation on VCC
  PROCEDURE ALIM (CONSTANT tinf,tmin,tmax,tend : IN TIME;  CONSTANT Vstart,Vinf,Vmin,Vmax,Vend : IN REAL;SIGNAL V : OUT REAL);

END stimuli_spi;


--------------------------------------------------------
-- 			PACKAGE BODY
--------------------------------------------------------
PACKAGE BODY stimuli_spi IS

	PROCEDURE stop (CONSTANT t0,t1: IN TIME; SIGNAL nH: OUT STD_LOGIC) IS
	BEGIN

	nH <= '1', '0' after t0, '1' after t1;

	END stop;


	PROCEDURE WAITC (CONSTANT thigh,tlow : IN TIME; CONSTANT n : IN INTEGER; SIGNAL C : OUT STD_LOGIC) IS
	BEGIN
	
	FOR i IN 0 TO (n-1) LOOP
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;
	END WAITC;


---------------------------------------------------------------------------------------
	PROCEDURE PIN_W (CONSTANT t: IN TIME; SIGNAL nW: OUT STD_LOGIC) IS
	BEGIN
		nW <= '0', '1' after t;
	END PIN_W;

---------------------------------------------------------------------------------------
	PROCEDURE RDSR (CONSTANT thigh,tlow : IN TIME; CONSTANT n : IN INTEGER; SIGNAL C,D,nS: OUT STD_LOGIC) IS
	BEGIN
	
	nS <= '1';
	C<='0';
	WAIT FOR tLOW;
	nS <= '0';
	C<='0';
	
	IF (n=1) THEN

		FOR i IN 0 to 15 LOOP
			IF (i=5) OR (i=7) THEN
				D <= '1';
			ELSE
				D <= '0';
			END IF;
			
			C <= '0';
			WAIT FOR tlow;
			C <= '1';
			WAIT FOR thigh;
		END LOOP;

	ELSE

		FOR i IN 0 to (8*(n+1)-1) LOOP

			IF (i=5) OR (i=7) THEN
				D <= '1';
			ELSE
				D <= '0';
			END IF;
			
			C <= '0';
			WAIT FOR tlow;
			C <= '1';
			WAIT FOR thigh;
		END LOOP;

	END IF;

	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END RDSR;

----------------------------------------------------------------------------------------
	PROCEDURE WRSR (CONSTANT thigh,tlow : IN TIME; CONSTANT status : IN STD_LOGIC_VECTOR (7 downto 0); SIGNAL C,D,nS : OUT STD_LOGIC) IS
	BEGIN
	
	nS <= '1'; 
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0'; 
	C <= '0';
	
	FOR i IN 0 to 15 LOOP
		IF (i=7) THEN
			D <= '1';
		ELSIF ((i>=8) AND (status(15-i)='1')) THEN
			D <= '1';
		ELSE D<='0';
		END IF;

		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;

	END LOOP;
	
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END WRSR;
	
	
----------------------------------------------------------------------------------------
  PROCEDURE WRSR_wc0 (CONSTANT thigh,tlow : IN TIME; CONSTANT status : IN STD_LOGIC_VECTOR (7 downto 0); SIGNAL C,D,nS, nW : OUT STD_LOGIC) IS

    BEGIN
	 -- nS <= '1'; 
	 -- C <= '0';
	--WAIT FOR tLOW;
	  nS <= '0'; 
	  C <= '0';
	  
      FOR i IN 0 to 15 LOOP
	
	IF (i=7) THEN
	  D <= '1';
	  --nW <='0';
	ELSIF ((i>=8) AND (status(15-i)='1')) THEN
	  nW <= '1';
	  D <= '1';
	ELSE D<='0';
	END IF;

	C <= '0';
	WAIT FOR tlow;
	C <= '1';
	WAIT FOR thigh;

      END LOOP;
          --nw <='0';
	  C <= '0';
      WAIT FOR tLOW;
	  nW <= '1';
          nS <= '1'; 
  END WRSR_wc0;	

------------------------------------------------------------------------------------------
	PROCEDURE WREN (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS: OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOr tLOW;

	FOR i IN 0 to 7  LOOP

		IF (i=0) THEN
			nS <= '0';
			D <='0';
		END IF;
	
		IF (i=5) OR (i=6) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;

		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;

	END LOOP;

	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END WREN;

------------------------------------------------------------------------------------------
  PROCEDURE WREN_wc0 (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS,nW: OUT STD_LOGIC) IS

    BEGIN
	--nS <= '1';
        --C <= '0';
        --nW <= '1';
	--WAIT FOr tLOW;

	FOR i IN 0 to 7  LOOP

      IF (i=0) THEN
	  nS <= '0';
	  D <='0';
	END IF;
      IF (i=7) THEN nW <= '1'; END IF;
      IF (i=5) OR (i=6) THEN
	  D <= '1';
	  nW <= '0';
      ELSE
	  D <= '0';
      END IF;
     
      wait for tlow/2;
     C <= '0';
     WAIT FOR tlow;
     C <= '1';
     WAIT FOR thigh;
 
      END LOOP;
       C <= '0';
       WAIT for tLOW;
       --nW <= '1';
        nS <= '1';
	  
  END WREN_wc0;	

------------------------------------------------------------------------------------------
	PROCEDURE WRDI (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS: OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <= '0';

	FOR i IN 0 to 7  LOOP
		IF (i=5) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	C <= '0';
	WAIT FOR tLOW;
	nS<='1';

	END WRDI;

--------------------------------------------------------------------------------------------
	PROCEDURE READ (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS: OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <= '0';
	
	FOR i IN 0 to 7  LOOP
		IF (i=0) THEN
		END IF;
		
		IF (i=6) OR (i=7) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to 23  LOOP
		IF (address(23-i) = '1') THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to (8*n-1) LOOP
		IF (i=0) THEN
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;

	END LOOP;
	
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';

	END READ;	

--------------------------------------------------------------------------------------------
	PROCEDURE FAST_READ (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS : OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <= '0';

	FOR i IN 0 to 7 LOOP
		IF (i=0) THEN
		END IF;
		
		IF ((i=4) OR (i=6) OR (i=7)) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to 23 LOOP
		IF (address(23-i) = '1') THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 TO 7 LOOP
		D<='0';
		C<='0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to (8*n-1) LOOP
		IF (i=0) THEN
			D <= '0';
		END IF;
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;

	END LOOP;
	
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END FAST_READ;	

----------------------------------------------------------------------------------------------------
	PROCEDURE PP (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT data : IN STD_LOGIC_VECTOR (7 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS, nRESET : OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <= '0';

	FOR i IN 0 to 7  LOOP
		IF (i=6) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to 23  LOOP
		IF (address(23-i) = '1') THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to (8*n-1)  LOOP
		IF i> 2047 THEN
			D <= '0';
		ELSIF (i rem 8 =0) AND (i/=(8*n)) AND (data(7) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =1) AND (data(6) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =2) AND (data(5) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =3) AND (data(4) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =4) AND (data(3) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =5) AND (data(2) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =6) AND (data(1) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =7) AND (data(0) = '1') THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
	        C <= '0';
		WAIT FOR tLOW;
		C <= '1';
		WAIT FOR tHIGH;
	END LOOP;
--        nRESET <= '0';
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END PP; 


----------------------------------------------------------------------------------------------------
	PROCEDURE PW (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); CONSTANT data : IN STD_LOGIC_VECTOR (7 downto 0); CONSTANT n : IN INTEGER; SIGNAL C,D,nS, nRESET : OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <= '0';

	FOR i IN 0 to 7  LOOP
		IF (i=6 or i=4) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to 23  LOOP
		IF (address(23-i) = '1') THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to (8*n-1)  LOOP
		IF i> 2047 THEN
			D <= '0';
		ELSIF (i rem 8 =0) AND (i/=(8*n)) AND (data(7) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =1) AND (data(6) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =2) AND (data(5) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =3) AND (data(4) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =4) AND (data(3) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =5) AND (data(2) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =6) AND (data(1) = '1') THEN
			D <= '1';
		ELSIF (i rem 8 =7) AND (data(0) = '1') THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		C <= '0';
		WAIT FOR tLOW;
		C <= '1';
		WAIT FOR tHIGH;
	END LOOP;
	C <= '0';
	WAIT FOR tLOW/2;
        -- nRESET <= '0';
	WAIT FOR tLOW/2;
	nS<='1';
	
	END PW; 


---------------------------------------------------------------------------------------------------------------------------------------------
	PROCEDURE SE (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); SIGNAL C,D,nS, nRESET : OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <='0';

	FOR i IN 0 to 7  LOOP
		IF (i=0 or i=1 OR i=3 OR i=4) THEN
			D <= '1';
		ELSE  D <= '0';
		END IF;

		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 to 23  LOOP
		IF ((address(23-i) = '1')) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;	
	END LOOP;
        nRESET <= '0';	
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';

	END SE;


---------------------------------------------------------------------------------------------------------------------------------------------
	PROCEDURE PE (CONSTANT thigh,tlow : IN TIME; CONSTANT address : IN BIT_VECTOR (23 downto 0); SIGNAL C,D,nS, nRESET : OUT STD_LOGIC) IS
	BEGIN

	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';
	C <='0';
        nRESET <='1';
	FOR i IN 0 to 7  LOOP
		IF (i=0 or i=1 OR i=3 OR i=4 OR i=6 OR i=7) THEN
			D <= '1';
		ELSE  D <= '0';
		END IF;

		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;
        nRESET <='1';
        WAIT FOR tLOW;
        nRESET <='0';
	FOR i IN 0 to 23  LOOP
		IF ((address(23-i) = '1')) THEN
			D <= '1';
		ELSE
			D <= '0';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;	
	END LOOP;
--        nRESET <='0';
	
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';

	END PE;
------------------------------------------------------------------------------------------- 
	PROCEDURE DP (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS: OUT STD_LOGIC) IS
	BEGIN

	nS<='1';
	C <='0';
	WAIT FOR tLOW;
	nS <= '0';
	
	FOR i IN 0 to 7  LOOP
		IF (i=1 OR i=5 OR i=6) THEN
			D <= '0';
		ELSE D <= '1';
		END IF;
		
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END DP;

-------------------------------------------------------------------------------------------
	PROCEDURE RDP (CONSTANT thigh,tlow : IN TIME; SIGNAL C,D,nS: OUT STD_LOGIC) IS
	BEGIN
	
	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';

	FOR i IN 0 to 7  LOOP
		IF (i=1 OR i=3 OR i=5) THEN
			D <= '0';
		ELSE D<='1';
		END IF;

		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;

	END LOOP;

	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END RDP;

-------------------------------------------------------------------------------------------
	PROCEDURE Read_ID (CONSTANT thigh,tlow : IN TIME; CONSTANT n : IN INTEGER; SIGNAL C,D,nS : OUT STD_LOGIC) IS
	BEGIN
	
	nS <= '1';
	C <= '0';
	WAIT FOR tLOW;
	nS <= '0';

	FOR i IN 0 to 7  LOOP
		IF (i=1 OR i=2) THEN
			D <= '0';
		ELSE D<='1';
		END IF;
		C <= '0';
		WAIT FOR tlow;
		C <= '1';
		WAIT FOR thigh;
	END LOOP;

	FOR i IN 0 TO n LOOP
		D <= '0';
		C <= '0';
		WAIT FOR tLOW;
		C <= '1';
		WAIT FOR tHIGH;
	END LOOP;
	C <= '0';
	WAIT FOR tLOW;
	nS<='1';
	
	END Read_ID;


-------------------------------------------------------------------------------------------
	PROCEDURE ALIM (CONSTANT tinf,tmin,tmax,tend : IN TIME;  CONSTANT Vstart,Vinf,Vmin,Vmax,Vend : IN REAL;SIGNAL V : OUT REAL)IS
	BEGIN
	V <= Vstart,Vinf AFTER tinf,Vmin AFTER tmin,
	Vmax AFTER tmax, Vend AFTER tend; 

	END ALIM;

END stimuli_spi;
