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
	
	signal stage : std_logic_vector(1 downto 0);
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
	
	signal writing_block : std_logic;
	signal reading_block : std_logic; -- "11" for done, "10" for reading, "00" for idle
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
			if (stage = "11") then
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
	FSM1: process(rst, clk)
	begin
		if (rst='0') then
			prev_state <= ready;
			prev_substate <= read_f;
		elsif (rising_edge(clk)) then
			prev_state <= next_state;
			prev_substate <= next_substate;
		end if;
	end process FSM1;
	
	process(prev_state, prev_substate, action, rst)
	begin
		if (rst='0') then
			next_state <= ready;
			stage <= "11";
			stage_counter <= "00000";
		else
			case prev_state is
			when ready =>
				if (action='1') then
					next_state <= stage0;
					next_substate <= read_f;
					stage <= "00"; 
					stage_counter <= "00000";
				else
					next_state <= ready;
				end if;
			when stage0 =>
				if (stage_counter > 7) then
					next_state <= stage1;
					next_substate <= read_f;
					stage <= "01";
					stage_counter <= "00000";
				else
					next_state <= stage0;
				end if;
			when stage1 =>
				if (stage_counter > 7) then
					next_state <= ready;
					stage <= "11";
				else
					next_state <= stage1;
				end if;
			when others => null;
			end case;
			
			-- sub state
			if (stage(1) = '0' and stage_counter < 8) then
				case prev_substate is
				when read_f =>
					next_substate <= idct_1d;
				when idct_1d =>
					next_substate <= write_p;
				when write_p =>
					next_substate <= read_f;
					stage_counter <= stage_counter + 1;
				when others => null;
				end case;
			end if;
		end if;
	end process;
	
	---------------------------------------------------------------------
    --  Data Path Begins Here
    ---------------------------------------------------------------------
	
	iram_addr1 <= ahbsi.haddr(6 downto 1) 	when stage = "11" else "000000";
	iram_addr2 <= ahbsi.haddr(6 downto 1)+1 when stage = "11" else "000000";
	iram_di1 <=  ahbsi.hwdata(31 downto 16) when stage = "11" else ( others => '0' );
	iram_di2 <=  ahbsi.hwdata(15 downto 0) 	when stage = "11" else ( others => '0' );
	iram_we1 <= '1' when ((ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and ahbsi.hready and ahbsi.hwrite) = '1' 
				and stage = "11" and ahbsi.haddr(7 downto 2) >= "000000" and ahbsi.haddr(7 downto 2) < "100000") else '0';
	iram_we2 <= iram_we1;

	
-- pragma translate_off
	bootmsg : report_version
	generic map ("Lab4 " & tost(ahbndx) & ": IDCT 2D Module rev 1");
-- pragma translate_on	
end rtl;