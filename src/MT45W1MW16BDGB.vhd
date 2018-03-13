-- Benjamin Maitland
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
use work.so_eddgy.ALL;


entity MT45W1MW16BDGB is
	port (
		A: in std_logic_vector(19 downto 0);
		-- clock, address valid, chip enable, output enable, write enable, 
		-- lower byte enable, upper byte enable.
		CLK, ADV, CRE, CE, OE, WE, LB, UB: in std_logic;
		DQ: inout std_logic_vector(15 downto 0);
		WAIT_p : out std_logic
	);
end MT45W1MW16BDGB;

architecture behav of MT45W1MW16BDGB is
	component sram
  GENERIC (
    clear_on_power_up: boolean := FALSE;    -- if TRUE, RAM is initialized with zeroes at start of simulation
    download_on_power_up: boolean := TRUE;  -- if TRUE, RAM is downloaded at start of simulation 
    trace_ram_load: boolean := TRUE;        -- Echoes the data downloaded to the RAM on the screen
    enable_nWE_only_control: boolean := TRUE;  -- Read-/write access controlled by nWE only
    size:      INTEGER :=  8;  -- number of memory words
    adr_width: INTEGER :=  3;  -- number of address bits
    width:     INTEGER :=  8;  -- number of bits per memory word
    tAA_max:    TIME := 20 NS; -- Address Access Time
    tOHA_min:   TIME :=  3 NS; -- Output Hold Time
    tACE_max:   TIME := 20 NS; -- nCE/CE2 Access Time
    tDOE_max:   TIME :=  8 NS; -- nOE Access Time
    tLZOE_min:  TIME :=  0 NS; -- nOE to Low-Z Output
    tHZOE_max:  TIME :=  8 NS; --  OE to High-Z Output
    tLZCE_min:  TIME :=  3 NS; -- nCE/CE2 to Low-Z Output
    tHZCE_max:  TIME := 10 NS; --  CE/nCE2 to High Z Output
    tWC_min:    TIME := 20 NS; -- Write Cycle Time
    tSCE_min:   TIME := 18 NS; -- nCE/CE2 to Write End
    tAW_min:    TIME := 15 NS; -- tAW Address Set-up Time to Write End
    tHA_min:    TIME :=  0 NS; -- tHA Address Hold from Write End
    tSA_min:    TIME :=  0 NS; -- Address Set-up Time
    tPWE_min:   TIME := 13 NS; -- nWE Pulse Width
    tSD_min:    TIME := 10 NS; -- Data Set-up to Write End
    tHD_min:    TIME :=  0 NS; -- Data Hold from Write End
    tHZWE_max:  TIME := 10 NS; -- nWE Low to High-Z Output
    tLZWE_min:  TIME :=  0 NS  -- nWE High to Low-Z Output
  );
  PORT (
    nCE: IN std_logic := '1';  -- low-active Chip-Enable of the SRAM device; defaults to '1' (inactive)
    nOE: IN std_logic := '1';  -- low-active Output-Enable of the SRAM device; defaults to '1' (inactive)
    nWE: IN std_logic := '1';  -- low-active Write-Enable of the SRAM device; defaults to '1' (inactive)
    A:   IN std_logic_vector(adr_width-1 downto 0); -- address bus of the SRAM device
    D:   INOUT std_logic_vector(width-1 downto 0);  -- bidirectional data bus to/from the SRAM device
    CE2: IN std_logic := '1';  -- high-active Chip-Enable of the SRAM device; defaults to '1'  (active) 
    download: IN boolean := FALSE;    -- A FALSE-to-TRUE transition on this signal downloads the data
    download_filename: IN string := "sram_load.dat";  -- name of the download source file
    dump: IN boolean := FALSE;       -- A FALSE-to-TRUE transition on this signal dumps
    dump_start: IN natural := 0;     -- Written to the dump-file are the memory words from memory address 
    dump_end: IN natural := size-1;  -- dump_start to address dump_end (default: all addresses)
    dump_filename: IN string := "sram_dump.dat"  -- name of the dump destination file
  );
	end component;
begin


	sram1: entity work.sram
	generic map(clear_on_power_up=> TRUE, download_on_power_up=>FALSE, trace_ram_load=>FALSE,
				enable_nWE_only_control=>FALSE, size=>2**20, adr_width=>20, width=>16,
				tAA_max=>70 ns, tOHA_min=>5 ns, tACE_max=>70 ns, tDOE_max=>20 ns,
				tLZOE_min=>3 ns, tHZOE_max=>8 ns, tLZCE_min=>10 ns, tHZCE_max=>8 ns,
				tWC_min=>70 ns, tSCE_min=>70 ns, tAW_min=>70 ns, tSA_min=>0 ns,
				tPWE_min=>46 ns, tSD_min=>23 ns, tHD_min=>0 ns, tHZWE_max=>8 ns,
				tLZWE_min=>10 ns)
	port map(nCE=>CE, nOE=>OE, nWE=>WE, A=>A, D=>DQ);

end behav;

