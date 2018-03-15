-----------------------------------------------------
-- Author: Hugues CREUSY
-- December 2003
-- VHDL model
-- project: M45PE10 25 MHz,
-- release: 1.0
-----------------------------------------------------
-- Unit    : Top hierarchy
-----------------------------------------------------
-------------------------------------------------------------
-- These VHDL models are provided "as is" without warranty
-- of any kind, included but not limited to, implied warranty
-- of merchantability and fitness for a particular purpose.
-------------------------------------------------------------


---------------------------------------------------------
--
--			M45PE10 SERIAL FLASH MEMORY
--
---------------------------------------------------------

LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY STD;
	USE STD.TEXTIO.ALL;
LIBRARY WORK;
	USE WORK.MEM_UTIL_PKG.ALL;

-----------------------------------------------------
--			ENTITY	
-----------------------------------------------------
ENTITY M45PE10 IS

GENERIC (	init_file: string := string'("initM45PE10.txt");         -- Init file name
		SIZE : positive := 1048576*1;                           -- 1Mbit
		Plength : positive := 256;                              -- Page length (in Byte)
		SSIZE : positive := 524288;                             -- Sector size (in # of bits)
		NB_BPi: positive := 3;                                  -- Number of BPi bits
		NB_BIT_DATA : positive:= 8;
		signature : STD_LOGIC_VECTOR (7 downto 0):="00010001";  -- Electronic signature
		manufacturerID : STD_LOGIC_VECTOR (7 downto 0):="00100000"; -- Manufacturer ID
		memtype : STD_LOGIC_VECTOR (7 downto 0):="01000000"; -- Memory Type
		density : STD_LOGIC_VECTOR (7 downto 0):="00010001"; -- Density 
		Tc: TIME := 40 ns;                                      -- Minimum Clock period
		Tr: TIME := 50 ns;                                      -- Minimum Clock period for read instruction
		tSLCH: TIME:= 10 ns;                                    -- notS active setup time (relative to C)
		tCHSL: TIME:= 10 ns;                                    -- notS not active hold time
		tCH : TIME := 18 ns;                                    -- Clock high time
		tCL : TIME := 18 ns;                                    -- Clock low time
		tDVCH: TIME:= 5 ns;                                     -- Data in Setup Time
		tCHDX: TIME:= 5 ns;                                     -- Data in Hold Time
		tCHSH : TIME := 10 ns;                                  -- notS active hold time (relative to C)
	 	tSHCH: TIME := 10 ns;                                   -- notS not active setup  time (relative to C)
		tSHSL: TIME := 200 ns;                                  -- /S deselect time
		tSHQZ: TIME := 15 ns;                                   -- Output disable Time
		tCLQV: TIME := 15 ns;                                   -- clock low to output valid
		tDP: TIME := 3 us;                                      -- notS high to deep power down mode
		tRDP: TIME := 30 us;                                    -- notS high to stand-by power mode
		tPW: TIME := 25 ms;                                      -- write status register cycle time
		tPP: TIME := 5 ms;                                      -- page program cycle time
		tSE: TIME := 5 sec;                                     -- sector erase cycle time
		tPE: TIME := 20 ms;                                    -- bulk erase cycle time
		tVSL: TIME :=30 us;                                    -- Vcc(min) to /S low
		tPUW: TIME := 10 ms;                                    -- Time delay to write instruction
		tSHRH: TIME := 10 ns;
		tRHSL: TIME := 3 us;
		tRLRH: TIME := 10 us;
		Vwi: REAL := 2.5 ;                                      -- Write inhibit voltage (unit: V)
		Vccmin: REAL := 2.7 ;                                   -- Minimum supply voltage
		Vccmax: REAL := 3.6                                     -- Maximum supply voltage
		);

PORT(		VCC: IN REAL;
		C, D, S, W,RESET: IN std_logic ;
		Q : OUT std_logic);

BEGIN
END M45PE10;


---------------------------------------------------------------------
--				ARCHITECTURE
---------------------------------------------------------------------
-- This part implements three components: one of type Internal Logic,
-- one of type Memory Access and one of type ACDC check
---------------------------------------------------------------------
ARCHITECTURE structure OF M45PE10 IS
COMPONENT Internal_Logic
GENERIC (	SIZE : positive;
		Plength : positive;
		SSIZE : positive;
		Nb_BPi: positive;
		signature : STD_LOGIC_VECTOR (7 downto 0);
		manufacturerID : STD_LOGIC_VECTOR (7 downto 0);
		memtype : STD_LOGIC_VECTOR (7 downto 0);
		density : STD_LOGIC_VECTOR (7 downto 0); 
		NB_BIT_DATA: positive;
		NB_BIT_ADD: positive;
		NB_BIT_ADD_MEM: positive;
		Tc: TIME;
		tSLCH: TIME;
		tCHSL: TIME;
		tCH: TIME;
		tCL: TIME;
		tDVCH: TIME;
		tCHDX: TIME;
		tCHSH: TIME;
		tSHCH: TIME;
		tSHSL: TIME;
		tSHQZ: TIME;
		tCLQV: TIME;
		tDP:TIME;
		tRDP:TIME;
		tPW: TIME;
		tPP:TIME;
		tSE:TIME;
		tPE:TIME );
 PORT (	C, D, W,S, RESET: IN std_logic;
	data_to_read: IN std_logic_vector (NB_BIT_DATA-1 downto 0);
	Power_up: IN boolean;
	Q: OUT std_logic;
	p_prog: OUT page (0 TO (Plength-1));
	add_fin_pprog: OUT natural :=to_bit_code(size/NB_BIT_DATA); -- number of bytes to be written in page write
	add_mem: OUT std_logic_vector(NB_BIT_ADD_MEM-1 downto 0);
	write_op,read_op,PE_enable,SE_enable,add_pp_enable,PP_enable,add_pw_enable,PW_enable:OUT boolean;
	read_enable,data_request: OUT boolean
	);
END COMPONENT;


COMPONENT Memory_Access	
GENERIC(	init_file: string;
		SIZE : positive;
		Plength : positive;
		SSIZE : positive;
		NB_BIT_DATA: positive;
		NB_BIT_ADD: positive;
		NB_BIT_ADD_MEM: positive);
PORT(	add_mem: IN std_logic_vector(NB_BIT_ADD_MEM-1 downto 0);
	PE_enable,SE_enable,add_pp_enable,PP_enable,add_pw_enable,PW_enable: IN boolean;
	read_enable,data_request: IN boolean;
	p_prog: IN page (0 TO (Plength-1));
	add_fin_pprog: IN natural :=to_bit_code(size/NB_BIT_DATA); -- number of bytes to be written in page write

	data_to_read: OUT std_logic_vector (NB_BIT_DATA-1 downto 0));
END COMPONENT;


COMPONENT ACDC_check 
GENERIC (	Tc: TIME;
		Tr: TIME;
		tSLCH: TIME;
		tCHSL: TIME;
		tCH : TIME;
		tCL : TIME;
		tDVCH: TIME;
		tCHDX: TIME;
		tCHSH : TIME;
		tSHCH: TIME;
		tSHSL: TIME;
		tVSL: TIME ;
		tPUW: TIME ;
		tSHRH: TIME;
		tRHSL: TIME;
		tRLRH: TIME;
		Vwi: REAL;
		Vccmin: REAL;
		Vccmax: REAL);
		
PORT (	VCC: IN REAL;
	C, D, S, RESET: IN std_logic;
	write_op,read_op: IN boolean;
	Power_up: OUT boolean);
	
END COMPONENT;


 CONSTANT NOMBRE_BIT_ADRESSE_TOTAL: positive:= 24;
 CONSTANT NOMBRE_BIT_ADRESSE_SPI: positive := 8;
 CONSTANT NOMBRE_BIT_DONNEE_SPI: positive :=8;
 SIGNAL adresse: std_logic_vector(NOMBRE_BIT_ADRESSE_TOTAL-1 DOWNTO 0) ;
 SIGNAL dtr: std_logic_vector(NOMBRE_BIT_DONNEE_SPI-1 DOWNTO 0);
 SIGNAL page_prog:page (0 TO (Plength-1));
 SIGNAL add_fin_pprog: natural := to_bit_code(size/NB_BIT_DATA);
 SIGNAL wr_op,rd_op,s_en,pe_en,add_pp_en,pp_en,pw_en, add_pw_en,r_en,d_req,wrsr, srwd_wrsr,write_protect,p_up : boolean;
 SIGNAL clck : std_logic;


BEGIN

clck<=C;

SPI_decoder:Internal_Logic
GENERIC MAP(
		SIZE=>SIZE,
		Plength => Plength,
		SSIZE => SSIZE,
		NB_BPi => NB_BPi,
		signature => signature,
		manufacturerID => manufacturerID,
		memtype => memtype,
		density => density,
		NB_BIT_DATA => NOMBRE_BIT_DONNEE_SPI,
		NB_BIT_ADD => NOMBRE_BIT_ADRESSE_SPI,
		NB_BIT_ADD_MEM => NOMBRE_BIT_ADRESSE_TOTAL,
		Tc=>Tc,
		tSLCH => tSLCH,
		tCHSL => tCHSL,
		tCH => tCH,
		tCL => tCL,
		tDVCH => tDVCH,
		tCHDX => tCHDX,
		tCHSH => tCHSH,
		tSHCH => tSHCH,
		tSHSL => tSHSL,
		tSHQZ =>tSHQZ,
		tCLQV => tCLQV,
		tDP => tDP,
		tRDP => tRDP,
		tPW => tPW,
		tPP => tPP,
		tSE => tSE,
		tPE => tPE )
PORT MAP(	clck, D,W,S, RESET,
                       dtr,p_up,Q,page_prog,add_fin_pprog,adresse,wr_op,rd_op,pe_en,s_en,add_pp_en,pp_en,add_pw_en,pw_en,r_en,d_req);
	
Mem_access:Memory_Access
GENERIC MAP(	init_file => init_file,
		SIZE => SIZE,
 		Plength => Plength,
		SSIZE => SSIZE,
		NB_BIT_DATA => NOMBRE_BIT_DONNEE_SPI,
		NB_BIT_ADD => NOMBRE_BIT_ADRESSE_SPI,
		NB_BIT_ADD_MEM => NOMBRE_BIT_ADRESSE_TOTAL)

PORT MAP(	adresse,
		pe_en,
		s_en,
		add_pp_en,
		pp_en,
		add_pw_en,
		pw_en,
		r_en,
		d_req,
		page_prog,
		add_fin_pprog,
		dtr);

ACDC_watch:ACDC_check
GENERIC MAP(	Tc => Tc,
		Tr => Tr,
		tSLCH => tSLCH,
		tCHSL => tCHSL,
		tCH => tCH,
		tCL => tCL,
		tDVCH => tDVCH,
		tCHDX => tCHDX,
		tCHSH => tCHSH,
		tSHCH => tSHCH,
		tSHSL => tSHSL,
		tVSL => tVSL,
		tPUW => tPUW,
		tSHRH => tSHRH,
		tRHSL => tRHSL,
		tRLRH => tRLRH,
		Vwi => Vwi,
		Vccmin => Vccmin,
		Vccmax => Vccmax )
PORT MAP(	VCC,clck,D,S, reset ,wr_op,rd_op,p_up);

END structure;
