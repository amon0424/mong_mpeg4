library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

library techmap;
use techmap.gencomp.all;

entity idct2d is
	generic (
		ahbndx  : integer := 0;
		ahbaddr : integer := 0;
		addrmsk : integer := 16#fff#;
		verid   : integer := 0;
		irq_no  : integer := 0
	);

	port(
		rst	 : in  std_ulogic;
		clk	 : in  std_ulogic;
		ahbsi   : in  ahb_slv_in_type;
		ahbso   : out ahb_slv_out_type
	);
end entity idct2d;

architecture rtl of idct2d is
	constant hconfig : ahb_config_type := (
	  0	  => ahb_device_reg (VENDOR_NCTU, NCTU_IDCT, 0, verid, irq_no),
	  4	  => ahb_membar(ahbaddr, '1', '0', addrmsk),
	  others => X"00000000"
	);

	-- AMBA bus control signals
	signal wr_valid : std_logic; -- is the logic selected by a master
	signal addr_wr : std_logic_vector(31 downto 0);
	
	-----------------------------------------------------------------
	-- 1-D IDCT signals
	-----------------------------------------------------------------
	type state is (read_f, idct_1d, write_p, ready, stage0, stage1);

	signal prev_substate, next_substate: state;
	signal prev_state, next_state: state;
	
	--signal stage : std_logic_vector(1 downto 0);
	signal stage_counter: unsigned(4 downto 0);
	signal action : std_logic;
	
	-----------------------------------------------------------------
	-- BRAM
	-----------------------------------------------------------------
	component BRAM
	port(
		CLK1: in std_logic;
		WE1: in std_logic;
		Addr1: in std_logic_vector(5 downto 0);
		Data_In1: in std_logic_vector(15 downto 0);
		Data_Out1: out std_logic_vector(15 downto 0);
		CLK2: in std_logic;
		WE2: in std_logic;
		Addr2: in std_logic_vector(5 downto 0);
		Data_In2: in std_logic_vector(15 downto 0);
		Data_Out2: out std_logic_vector(15 downto 0)
	);
	end component;

	signal iram_addr1: std_logic_vector(5 downto 0);
	signal iram_addr2: std_logic_vector(5 downto 0);
	signal iram_we1	: std_logic;
	signal iram_we2	: std_logic;
	signal iram_di1 : std_logic_vector(15 downto 0);
	signal iram_di2 : std_logic_vector(15 downto 0);
	signal iram_do1 : std_logic_vector(15 downto 0);
	signal iram_do2 : std_logic_vector(15 downto 0);
	
	signal tram_addr1: std_logic_vector(5 downto 0);
	signal tram_addr2: std_logic_vector(5 downto 0);
	signal tram_we1	: std_logic;
	signal tram_we2	: std_logic;
	signal tram_di1 : std_logic_vector(15 downto 0);
	signal tram_di2 : std_logic_vector(15 downto 0);
	signal tram_do1 : std_logic_vector(15 downto 0);
	signal tram_do2 : std_logic_vector(15 downto 0);
	
	signal writing_block : std_logic;
	signal reading_block : std_logic; -- "11" for done, "10" for reading, "00" for idle
	
	signal row_index : std_logic_vector(6 downto 0);
	signal col_index : std_logic_vector(6 downto 0);
	signal F0, F1, F2, F3, F4, F5, F6, F7: std_logic_vector(15 downto 0);
	signal p0, p1, p2, p3, p4, p5, p6, p7: std_logic_vector(15 downto 0);
	signal p : std_logic_vector(31 downto 0);
	
	--------------------ken-----------------------------------------
	type state1 is (RDY, STAGE0, STAGE1);
	type state2 is (WRITE_p, READ_F, IDCT_1D);
	signal cr_state, nx_state: state1;
	signal sub_cr_state, sub_nx_state: state2;
	signal change_state:std_logic;
	signal run_sub: std_logic;
	signal count0, count1: std_logic_vector(4 downto 0);
	signal stage: std_logic_vector(1 downto 0);
	----------------------ken---------------------------------------
begin

	ahbso.hresp   <= "00";
	ahbso.hsplit  <= (others => '0');
	ahbso.hirq	<= (others => '0');
	ahbso.hcache  <= '0';
	ahbso.hconfig <= hconfig;
	ahbso.hindex  <= ahbndx;

	iram : BRAM
	port map (
		CLK1		=> clk,
		CLK2		=> clk,
		Addr1	=> iram_addr1,
		Addr2	=> iram_addr2,
		WE1		=> iram_we1,
		WE2		=> iram_we2,
		Data_In1	=> iram_di1,
		Data_In2	=> iram_di2,
		Data_Out1	=> iram_do1,
		Data_Out2	=> iram_do2
	);
	
	tram : BRAM
	port map (
		CLK1		=> clk,
		CLK2		=> clk,
		Addr1	=> tram_addr1,
		Addr2	=> tram_addr2,
		WE1		=> tram_we1,
		WE2		=> tram_we2,
		Data_In1	=> tram_di1,
		Data_In2	=> tram_di2,
		Data_Out1	=> tram_do1,
		Data_Out2	=> tram_do2
	);
	
	---------------------------------------------------------------------
	--  Register File Management Begins Here
	---------------------------------------------------------------------
	-- This process handles read/write of the following registers:
	--	1. Eight 16-bit input idct coefficient registers (F0 ~ F7)
	--	2. Eight 16-bit output pixel values (p0 ~ p7)
	--	3. A 1-bit register, action, signals the execution and
	--	   completion of the IDCT logic
	--
	ready_ctrl : process (clk, rst)
	begin
		if rst = '0' then
			ahbso.hready <= '1';
		elsif rising_edge(clk ) then
			if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1)) = '1' then
				-- if reading block, we need one more cycle
				if (ahbsi.hwrite = '0' and ahbsi.haddr(7 downto 2) >= "000000" and ahbsi.haddr(7 downto 2) < "100000") then
					ahbso.hready <= '0';
				else
					ahbso.hready <= '1';
				end if;
			elsif reading_block = '1' then
				ahbso.hready <= '1';
			end if;
		end if;
	end process;
	

	
	-- the wr_addr_fetch process latch the write address so that it
	-- can be used in the data fetch cycle as the destination pointer
	--
	wr_addr_fetch : process (clk, rst)
	begin
		if rst = '0' then
			addr_wr <= (others => '0');
			wr_valid <= '0';
			-- writing_block = '0';
		elsif rising_edge(clk) then
			if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and
				ahbsi.hready and ahbsi.hwrite) = '1' then
				addr_wr <= ahbsi.haddr;
				wr_valid <= '1';
			else
				wr_valid <= '0';
			end if;
		end if;
	end process;

	-- for register writing, data fetch (into registers) should happens one
	-- cycle after the address fetch process.
	--
	write_reg_process : process (clk, rst)
	begin
		if (rst = '0') then
			action <= '0';
		elsif rising_edge(clk) then
			if (cr_state = STAGE1 and nx_state = RDY) then
				action <= '0';
			end if;
			if (wr_valid = '1') then
				-- if addr/2 is 0~63 => addr/4 is 0~31
				if addr_wr(7 downto 2) >= "000000" and addr_wr(7 downto 2) < "100000" then
					-- write to bram	
				-- if addr/4 is 32
				elsif addr_wr(7 downto 2) = "100000" then
					action <= ahbsi.hwdata(0);
				end if;
			end if;
		end if;
	end process;
	
	-- for a read operation, we must start driving the data bus
	-- as soon as the device is selected; this way, the data will
	-- be ready for fetch during next clock cycle
	--
	read_reg_process : process (clk, rst)
	begin
		if (rst = '0') then
			ahbso.hrdata <= (others => '0');
			reading_block <= '0';
		elsif rising_edge(clk) then
			if ((ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and
				ahbsi.hready and (not ahbsi.hwrite)) = '1') then
				-- if addr/2 is 0~63 => addr/4 is 0~31, wait one cycle for ram reading
				if ahbsi.haddr(7 downto 2) >= "000000" and ahbsi.haddr(7 downto 2) < "100000" then
					reading_block <= '1';
				-- if addr/4 is 32
				elsif ahbsi.haddr(7 downto 2) = "100000" then
					ahbso.hrdata(31 downto 1) <= (others => '0');
					ahbso.hrdata(0) <= action;
				end if;
			elsif (reading_block = '1') then
				ahbso.hrdata(31 downto 16) <= iram_do1;
				ahbso.hrdata(15 downto 0) <= iram_do2;
				reading_block <= '0';
			end if;
		end if;
	end process;
	
	---------------------------------------------------------------------
	--  Controller (Finite State Machines) Begins Here
	---------------------------------------------------------------------
	------------------------ken------------------------------------
	FSM_2D: process(rst, clk, count0, count1)
	begin
		if rising_edge(clk) then
			if(rst = '0') then
				cr_state <= RDY;
				sub_cr_state <= READ_F;
				count0 <= "00000";
				count1 <= "00000";
			elsif change_state = '1' then
				sub_cr_state <= READ_F;
				cr_state <= nx_state;
			else
			cr_state <= nx_state;
			sub_cr_state <= sub_nx_state;
			end if;
			
			if count0 > "01000" then
				count0 <= "00000";
			end if;
			
			if count1 > "01000" then
				count1 <= "00000";
			end if;
		
			if ((sub_cr_state = WRITE_p and sub_nx_state = READ_F) and cr_state = STAGE0) then	
				count0 <= count0 + 1;
			end if;
		
			if ((sub_cr_state = WRITE_p and sub_nx_state = READ_F) and cr_state = STAGE1) then
				count1 <= count1 + 1;
			end if;
		end if;--rising_edge(clk) end
	end process FSM_2D;
	
	process (cr_state, action, count0, count1)
	begin 
		case cr_state is
		when RDY =>
			if (action = '1') then
				nx_state <= STAGE0;
				stage <= "00";
				change_state <= '1';
				run_sub <= '1';
			else
				nx_state <= RDY;
				change_state <= '0';
				run_sub <='0';
			end if;
		when STAGE0 =>
			if count0 > "00111" then 
				stage <= "01";
				nx_state <= STAGE1;
				change_state <= '1';
			else
				nx_state <= STAGE0;
				change_state <= '0';
			end if;
		when STAGE1 =>
			if count1 > "00111" then 
				stage <= "11";
				nx_state <= RDY;
			else
				nx_state <= STAGE1;
				change_state <= '0';
			end if;
		when others => NULL;
		end case;
	end process;	
	
	process (sub_cr_state, run_sub)
	begin 
		if run_sub = '1' then
		case sub_cr_state is
		when READ_F =>
			sub_nx_state <= IDCT_1D;
		when IDCT_1D =>
			sub_nx_state <= WRITE_p;
		when WRITE_p =>
			sub_nx_state <= READ_F;
		when others => null;
		end case;
		end if;
	end process;
	------------------------------ken----------------------------------

end rtl;