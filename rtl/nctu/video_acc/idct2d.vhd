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
	signal read_count : std_logic_vector(2 downto 0);
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
			if (prev_state = stage1 and next_state = ready) then
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
			prev_substate <= ready;
			stage <= "11";
		elsif (rising_edge(clk)) then
			prev_state <= next_state;
			prev_substate <= next_substate;
			case next_state is
			when ready =>
				stage <= "11";
			when stage0 =>
				stage <= "00";
			when stage1 =>
				stage <= "01";
			when others => null;
			end case;
		end if;
	end process FSM1;
	
	process(prev_state, prev_substate, row_index, col_index, action, rst)
	begin
		if (rst='0') then
			next_state <= ready;
			next_substate <= ready;
			stage_counter <= "00000";
		else
			case prev_state is
			when ready =>
				if (action='1') then
					next_state <= stage0;
					next_substate <= read_f;
					stage_counter <= "00000";
				else
					next_state <= ready;
				end if;
			when stage0 =>
				if(col_index(5 downto 3) = "110" and stage_counter = 7) then	-- if we reach the last row and column
					stage_counter <= "00000";	-- change to next stage
					next_state <= stage1;
				else
					next_state <= stage0;
				end if;
			when stage1 =>
				if(col_index(5 downto 3) = "110" and stage_counter = 7) then	-- if we reach the last row and column
					stage_counter <= "00000";	-- change to next stage
					next_state <= ready;
				else
					next_state <= stage1;
				end if;
			when others => null;
			end case;
			
			-- sub state
			if (stage(1) = '0' and stage_counter < 8) then
				case prev_substate is
				when read_f =>
					if(read_count = "011")then
						next_substate <= idct_1d;
					else
						next_substate <= read_f;
					end if;
				when idct_1d =>
					next_substate <= write_p;
				when write_p =>
					--if(stage_counter < 8) then
						if(col_index(5 downto 3) = "110")then		-- if col_index reach last row
							if( stage_counter < 7) then					-- if we not reach the last column
								stage_counter <= stage_counter + 1;
							end if;
							next_substate <= read_f;					-- go to read next row
						else
							next_substate <= write_p;				-- else continue write 
						end if;
					--else
					--	stage_counter <= stage_counter + 1;
					--	next_substate <= ready;
					--end if;
					
				when others => null;
				end case;
			end if;
		end if;
	end process;
	
	---------------------------------------------------------------------
    --  Data Path Begins Here
    ---------------------------------------------------------------------
	
	-- for interface block ram
	iram_addr1 <= 	ahbsi.haddr(6 downto 1) when stage = "11" else 	--write
					row_index(5 downto 0) when stage = "00" else	--read, first write
					col_index(5 downto 0) when stage = "01" else	--write
					"000000";
	iram_addr2 <= 	iram_addr1 + 1 when stage="11" or stage="00" else	--read, first write
					iram_addr1 + 8 when stage="01" else					--write
					"000000";
	
	iram_di1 <=	ahbsi.hwdata(31 downto 16) when stage = "11" else
				p0 when stage = "01" and col_index(5 downto 3)="000" else
				p2 when stage = "01" and col_index(5 downto 3)="010" else
				p4 when stage = "01" and col_index(5 downto 3)="100" else
				p6 when stage = "01" and col_index(5 downto 3)="110" else
				( others => '0' );
	iram_di2 <=  ahbsi.hwdata(15 downto 0) 	when stage = "11" else
				p1 when stage = "00" and col_index(5 downto 3)="000" else	
				p3 when stage = "00" and col_index(5 downto 3)="010" else
				p5 when stage = "00" and col_index(5 downto 3)="100" else
				p7 when stage = "00" and col_index(5 downto 3)="110" else
				( others => '0' );
	iram_we1 <= '1' when (stage = "11" and(ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and ahbsi.hready and ahbsi.hwrite) = '1' 
							and stage = "11" and ahbsi.haddr(7 downto 2) >= "000000" and ahbsi.haddr(7 downto 2) < "100000") 
						or
						(stage="01" and  prev_substate=write_p)
				else '0';
	iram_we2 <= iram_we1;

	-- for transpose block ram
	tram_addr1 <= 	col_index(5 downto 0) when stage = "00" else	--write
					row_index(5 downto 0) when stage = "01" else	--read
					"000000";
	tram_addr2 <= 	tram_addr1 + 8 when stage = "00" else
					tram_addr1 + 1 when stage = "01" else
					"000000";
	
	tram_di1 <=	p0 when stage = "00" and col_index(5 downto 3)="000" else
				p2 when stage = "00" and col_index(5 downto 3)="010" else
				p4 when stage = "00" and col_index(5 downto 3)="100" else
				p6 when stage = "00" and col_index(5 downto 3)="110" else
				( others => '0' );
	tram_di2 <= p1 when stage = "00" and col_index(5 downto 3)="000" else
				p3 when stage = "00" and col_index(5 downto 3)="010" else
				p5 when stage = "00" and col_index(5 downto 3)="100" else
				p7 when stage = "00" and col_index(5 downto 3)="110" else
				( others => '0' );
	tram_we1 <= '1' when stage = "00" and prev_substate=write_p else '0';
	tram_we2 <= tram_we1;
	
	row_agu: process(rst, clk)
	begin
		if (rst='0') then
			row_index <= (others => '0');
			read_count <= "000";
			-- f_index <= 0;
		elsif (rising_edge(clk)) then
			if ( next_state = stage0 or next_state = stage1) then	-- if we will change to stage0/1 or in the same stage
				--if(stage_counter < 8)then
					if(next_state = prev_state and next_substate = read_F) then	-- if we are in the same stage
						if( prev_substate = read_F )then
							read_count <= read_count + 1;
						else
							read_count <= "000";
						end if;
						row_index <= row_index + 2;
					elsif(next_state /= prev_state)then				-- if we will change to stage0/1
						row_index <= (others => '0');				-- re-count the row_index, read_count
						read_count <= "000";
					end if;
				--else
				--	row_index <= (others => '0');
				--end if;	
			end if;
		end if;
	end process row_agu;
	
	col_agu: process(rst, clk)
	begin
		if (rst='0') then
			col_index <= (others => '0');
			-- f_index <= 0;
		elsif (rising_edge(clk)) then
			if ( next_state = stage0 or next_state = stage1) then		-- if we will change to stage0/1 or in the same stage
				--if(stage_counter < 8)then
					if(prev_substate = write_p) then		-- if we are writing
						if( next_substate = write_p) then	-- and if we are in the same column
							col_index <= col_index + 16;
						elsif(next_state = prev_state and next_substate = read_f) then		-- if next substate is read_f and next state is the same,
																							-- col_index reach end
							col_index <= (6 downto 3 => '0') & (col_index(2 downto 0)+1);	-- back to first row
						else
							col_index <= (others => '0');
						end if;
					end if;
				--else
				--	col_index <= (others => '0');
				--end if;
			end if;
		end if;
	end process col_agu;
	
	
	read_f_process: process(rst, clk)
	variable ram_out1 : std_logic_vector(15 downto 0);
	variable ram_out2 : std_logic_vector(15 downto 0);
	begin
		if (rst='0') then
			F0 <= (others => '0'); F1 <= (others => '0');
            F2 <= (others => '0'); F3 <= (others => '0');
            F4 <= (others => '0'); F5 <= (others => '0');
            F6 <= (others => '0'); F7 <= (others => '0');
		elsif (rising_edge(clk)) then
			if(prev_substate = read_f) then
				if prev_state = stage0 then 
					ram_out1 := iram_do1; 
					ram_out2 := iram_do2;
				else 
					ram_out1 := tram_do1;
					ram_out2 := tram_do2;
				end if;
				case read_count(1 downto 0) is
				when "00" =>
					F0 <= ram_out1;
					F1 <= ram_out2;
				when "01" =>
					F2 <= ram_out1;
					F3 <= ram_out2;
				when "10" =>
					F4 <= ram_out1;
					F5 <= ram_out2;
				when "11" =>
					F6 <= ram_out1;
					F7 <= ram_out2;
				when others => null;
				end case;
			end if;
		end if;
	end process read_f_process;
	
	
	write_p_process: process(rst, clk)
	begin
		if (rst='0') then
			p0 <= (others => '1'); p1 <= (others => '0');
            p2 <= (others => '1'); p3 <= (others => '0');
            p4 <= (others => '1'); p5 <= (others => '0');
            p6 <= (others => '1'); p7 <= (others => '0');
		end if;
	end process write_p_process;

-- pragma translate_off
	bootmsg : report_version
	generic map ("Lab4 " & tost(ahbndx) & ": IDCT 2D Module rev 1");
-- pragma translate_on	
end rtl;