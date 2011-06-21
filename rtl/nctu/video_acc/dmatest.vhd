---------------------------------------------------------------------------
-- mcomp.vhd
--
-- Motion Compensation Hardware for HW/SW Co-Design
--     Created:  YCC 03-31-2008
--     Modified: CJT 04-21-2008
--
-- This code is for the class "Embedded Firmware and Hardware/Software
-- Co-design" in Spring, 2008.
-- Dept. of Computer Science and Information Engineering
-- National Chiao Tung University
-- 1001 Ta-Hsueh Rd., Hsinchu, 300, Taiwan
--
---------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;
use grlib.DMA2AHB_Package.all;

library gaisler;
use gaisler.misc.all;

library techmap;
use techmap.gencomp.all;

entity dmatest is
  generic (
    slvidx  : integer := 0;	-- slave index
    ahbaddr : integer := 0;
    addrmsk : integer := 16#fff#;
    verid   : integer := 0;
    irq_no  : integer := 0;
	
	-- for dma
	mstidx : integer := 0;	-- master index
	dbuf   : integer := 4
  );

  port (
    rst     : in  std_ulogic;
    clk     : in  std_ulogic;
    ahbsi   : in  ahb_slv_in_type;
    ahbso   : out ahb_slv_out_type;
	
	-- for dma
	ahbmi : in  ahb_mst_in_type;
	ahbmo : out ahb_mst_out_type 
  );
end;

architecture rtl of dmatest is


constant hconfig : ahb_config_type := (
  0      => ahb_device_reg ( VENDOR_NCTU, NCTU_MCOMP, 0, verid, irq_no),
  4      => ahb_membar(ahbaddr, '1', '0', addrmsk),
  others => X"00000000"
);

-- for dma
-- constant pconfig : apb_config_type := (
  -- 0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_AHBDMA, 0, 0, pirq),
  -- 1 => apb_iobar(paddr, pmask));

type dma_state_type is (readc, writec, write_r, write_mode);

subtype word32 is std_logic_vector(31 downto 0);
type datavec is array (0 to dbuf-1) of word32;

type reg_type is record
  srcaddr : std_logic_vector(31 downto 0);
  srcinc  : std_logic_vector(1 downto 0);
  dstaddr : std_logic_vector(31 downto 0);
  dstinc  : std_logic_vector(1 downto 0);
  len     : std_logic_vector(15 downto 0);
  enable  : std_logic;
  write   : std_logic;
  inhibit : std_logic;
  status  : std_logic_vector(1 downto 0);
  dstate  : dma_state_type;
  data    : datavec;
  cnt     : integer range 0 to dbuf-1; --additional one for r, one for action
  readCountInRow : integer range 0 to 16;
  src_stride : std_logic_vector(31 downto 0);
  dst_stride : std_logic_vector(31 downto 0);
  src_width : std_logic_vector(3 downto 0);			-- 0~9
  dst_width : std_logic_vector(3 downto 0);			-- 0~9
  --write_rfactor : std_logic;
 -- write_action : std_logic;
  src_mcomp : std_logic;
  rfactor : std_logic_vector(31 downto 0);
  mcomp_mode : std_logic_vector(1 downto 0);
  beat : integer range 0 to 4;
  
  write_valid : std_logic; -- is the logic selected by a master
  write_addr : std_logic_vector(31 downto 0);
end record;

signal r, rin : reg_type;
signal dmai : dma_in_type;
signal dmao : dma_out_type;
----------------------------------

--signal readCountInRow : std_logic_vector(3 downto 0);	-- 0~9
--signal width : std_logic_vector(3 downto 0);			-- 0~9
type Data_Vector  is array (Natural range <> ) of Std_Logic_Vector(32-1 downto 0);
begin

	
	---------------------ahb dma----------------------
	comb : process(ahbsi, dmao, rst, r)
		variable v       : reg_type;
		variable regd    : std_logic_vector(31 downto 0);   -- data from registers
		variable start   : std_logic;
		variable burst   : std_logic;
		variable write   : std_logic;
		variable ready   : std_logic;
		variable retry   : std_logic;
		variable mexc    : std_logic;
		variable irq     : std_logic;
		variable address : std_logic_vector(31 downto 0);   -- DMA address
		variable size    : std_logic_vector( 1 downto 0);   -- DMA transfer size
		variable newlen  : std_logic_vector(15 downto 0);
		variable oldaddr : std_logic_vector(9 downto 0);
		variable newaddr : std_logic_vector(9 downto 0);
		variable oldsize : std_logic_vector( 1 downto 0);
		variable ainc    : std_logic_vector( 3 downto 0);
		variable write_length : integer range 0 to dbuf;
		variable read_length : integer range 0 to dbuf;
		variable data 	: Data_Vector(26 downto 0);
		variable TP 		: Boolean;
		variable trans_size : integer range 0 to 32;
		variable DataPart:            Integer := 0;
	begin
		v := r; 
		regd := (others => '0'); 
		burst := '0'; 
		start := '0';
		write := '0'; 
		ready := '0'; 
		mexc := '0';
		size := r.srcinc; 
		irq := '0'; 
		v.inhibit := '0';
		start := r.enable;
		burst := '0'; 
		
		if v.src_mcomp = '0' then	-- read from ram, write to mcomp
			read_length := dbuf;
			write_length := dbuf;
		else					-- read from mcomp, write to ram, we just need (2*8=16)
			read_length := 16;
			write_length := 16;
		end if;
		
		if r.write = '0' then 
			address := r.srcaddr;
		else 
			address := r.dstaddr; 
		end if;
		
		newlen := r.len - 1;
		
		if r.write = '0' then 
			oldaddr := r.srcaddr(9 downto 0); 
			oldsize := r.srcinc;
		else 
			oldaddr := r.dstaddr(9 downto 0); 
			oldsize := r.dstinc; 
		end if;
		
		ainc := decode(oldsize);
		trans_size := conv_integer(ainc);
		
		
		
		-- transfer size
		if trans_size=4 then
			dmai.Size <= HSIZE32;
		elsif trans_size=2 then
			dmai.Size <= HSIZE16;
			if address(1 downto 0) = "00" then
				DataPart := 0;
			else
				DataPart := 1;
			end if;
		elsif trans_size=1 then
			dmai.Size <= HSIZE8;
			if address(1 downto 0) = "00" then
				DataPart := 0;
			elsif address(1 downto 0) = "01" then
				DataPart := 1;
			elsif address(1 downto 0) = "10" then
				DataPart := 2;
			else
				DataPart := 3;
			end if;
		--else
		--	report "Unsupported data width"
		--	severity Failure;
		end if;

		if r.enable = '1' then	-- skip the 4th beat data
			if r.write = '0' then	-- read from source
				if dmao.Ready = '1' then
					--v.data(r.cnt) := dmao.rdata;
					if trans_size=4 then		-- read 4 byte
					   v.data(r.cnt)    := dmao.Data;
					elsif trans_size=2 then	-- read 2 byte
					   v.data((r.cnt)/2)((31-16*((r.cnt) mod 2)) downto (16-(16*((r.cnt) mod 2)))) :=
						 dmao.Data((31-16*DataPart) downto (16-16*DataPart));
					   --DataPart := (DataPart + 1) mod 2;
					elsif trans_size=1 then	-- read 1 byte
					   v.data((r.cnt)/4)((31-8*((r.cnt) mod 4)) downto (24-(8*((r.cnt) mod 4)))) :=
						 dmao.Data((31-8*DataPart) downto (24-8*DataPart));
					   --DataPart := (DataPart + 1) mod 4;
					end if;
					
					if r.cnt = read_length-1 then 
						v.write := '1'; 
						v.dstate := writec;
						v.cnt := 0; 
						v.inhibit := '1';
						address := r.dstaddr; 
						size := r.dstinc;
					else
						v.cnt := r.cnt + 1; 
					end if;
			
					if r.readCountInRow < r.src_width and not (r.cnt = read_length-1) then 
						v.readCountInRow := r.readCountInRow + trans_size;
					else
						v.readCountInRow := trans_size;
					end if;
				end if;
			else	-- write to destination
				
				if r.src_mcomp = '0' then
					-- write to mcomp, we need to write rfactor
					if r.dstate = write_r then 
						v.dstate  := write_mode;
					elsif r.dstate = write_mode then
						v.dstate := writec;
						start := '0';
					elsif r.cnt = write_length-1 then 
						v.dstate  := write_r;
					end if;
				elsif r.cnt = write_length-1 then 
					start := '0'; 
				end if;
				
				if dmao.Okay = '1' then
					if r.cnt = write_length-1 then
						if(r.src_mcomp='1' or r.dstate = write_mode) then -- when write done, finish work
							v.cnt := 0;
							v.write := '0'; 
							v.dstate := readc;
							v.len := newlen; 
							v.enable := start; 
							irq := start;
						end if;
					else 
						v.cnt := r.cnt + 1; 
					end if;
					
					if r.readCountInRow < r.dst_width and not (r.cnt = write_length-1) then 
						v.readCountInRow := r.readCountInRow + trans_size;
					else
						v.readCountInRow := trans_size;
					end if;
				end if;
			end if;
		end if;

		
		start := r.enable;

		newaddr := oldaddr + ainc(3 downto 0);
		
		-- beat counter
		if(dmao.Okay = '1' and r.beat < 4)then
			v.beat := v.beat + 1;
		else
			v.beat := 0;
		end if;
		
		-- go to next row
		if r.beat = 3 then
			if r.write = '0' then 
				v.srcaddr := v.srcaddr + r.src_stride(9 downto 0);
				--v.inhibit := '1';
			else
				v.dstaddr := v.dstaddr + r.dst_stride(9 downto 0);
				--v.inhibit := '1';
			end if;
		--elsif(
		--	v.inhibit := '0';
		end if;
		
		-- if r.enable ='1' and r.beat = 0 and dmao.Grant = '1' then
			-- burst := '1';
		-- end if;
		
		-- burst
		-- if r.enable = '1' and (r.cnt < read_length-1 or v.write_rfactor='1' or (r.len(9 downto 2) = "11111111")) and
			-- not (r.beat = 2) then -- if beat = 3, we early stop burst
			-- --if (dmao.Request and dmao.Ready) = '1' then
				-- -- decide the new address
			-- --v.inhibit := '0';
			-- --burst := '1';
			-- -- if dmao.Ready = '1'then
				-- -- if r.write = '0' then 
					-- -- if not (r.src_stride = (31 downto 0 =>'0')) and r.readCountInRow + ainc >= r.src_width then
						-- -- burst := '0';
						-- -- v.srcaddr := v.srcaddr + r.src_stride(9 downto 0) - r.readCountInRow;
					-- -- else
						-- -- burst := '1';
						-- -- --v.srcaddr(9 downto 0) := newaddr;
					-- -- end if;
				-- -- else
					-- -- if not (r.dst_stride = (31 downto 0 =>'0')) and r.readCountInRow + ainc >= r.dst_width then
						-- -- burst := '0';
						-- -- v.dstaddr := v.dstaddr + r.dst_stride(9 downto 0) - r.readCountInRow;
					-- -- else
						 
						-- -- --v.dstaddr(9 downto 0) := newaddr;
					-- -- end if;
				-- -- end if;
			-- -- end if;
		-- else 
			-- --v.inhibit := '1';
			-- --burst := '0'; 
		-- end if;
		
		-- request control
		if r.beat > 0 and 
			((r.write = '0' and not (r.src_stride = (31 downto 0 =>'0'))) or (r.write = '1' and not (r.dst_stride = (31 downto 0 =>'0'))))then
			-- pause transfer
			v.inhibit := '1';
			burst := '0'; 
			
		else
			v.inhibit := '0';
			burst := '1'; 
		end if;
		
		
		
		if (r.write = '0' and not (r.src_stride = (31 downto 0 =>'0'))) or (r.write = '1' and not (r.dst_stride = (31 downto 0 =>'0')))then	
			-- if read source need stride, or write destination need stride
			dmai.Beat <= HINCR;
		else
			dmai.Beat <= HINCR;
		end if;

		-- AHB write address fetch
		if (ahbsi.hsel(slvidx) and ahbsi.htrans(1) and ahbsi.hready and ahbsi.hwrite) = '1' then
			v.write_addr := ahbsi.haddr;
			v.write_valid := '1';
		else
			v.write_valid := '0';
		end if;
		
		-- AHB write data fetch
		if(r.write_valid = '1')then
			case r.write_addr(5 downto 2) is
				when "0000" => -- 0x00
					v.srcaddr := ahbsi.hwdata;
				when "0001" => -- 0x04
					v.dstaddr := ahbsi.hwdata;
				when "0010" => -- 0x08
					v.len := ahbsi.hwdata(15 downto 0);
					v.srcinc := ahbsi.hwdata(17 downto 16);
					v.dstinc := ahbsi.hwdata(19 downto 18);
					v.enable := ahbsi.hwdata(20);
					v.src_mcomp := ahbsi.hwdata(21);
				when "0011" => -- 0x0C
					v.src_stride := ahbsi.hwdata;
				when "0100" => -- 0x10
					v.src_width := ahbsi.hwdata(3 downto 0);
				when "0101" => -- 0x14
					v.dst_stride := ahbsi.hwdata;
				when "0110" => -- 0x18
					v.dst_width := ahbsi.hwdata(3 downto 0);
				when "0111" => -- 0x1C
					v.rfactor := "00" & ahbsi.hwdata(29 downto 0);		-- r factor
					v.mcomp_mode := ahbsi.hwdata(31 downto 30); -- mocmp mode
				when others => null;
			end case;
		end if;

		if rst = '0' then
			v.dstate := readc; 
			v.enable := '0'; 
			v.write := '0';
			v.cnt  := 0;
			v.readCountInRow := 0;
			v.srcaddr := (others=>'0');
			v.dstaddr := (others=>'0');
			v.srcinc := (others=>'0');
			v.dstinc := (others=>'0');
			v.src_stride := (others=>'0');
			v.src_width := (others=>'0');
			v.dst_stride := (others=>'0');
			v.dst_width := (others=>'0');
			v.src_mcomp := '0';
			--v.write_rfactor := '0';
			--DMAInit(clk,  dmai);
			v.write_addr := (others=>'0');
			v.write_valid := '0';
			v.rfactor := (others=>'0');
			v.mcomp_mode := (others=>'0');
			v.beat := 0;
		end if;
		
		
		
		rin <= v;
		
		dmai.Request <= start and not v.inhibit;
		dmai.Burst   <= burst;
		dmai.Store   <= v.write;
		dmai.Address <= address;
		dmai.Reset	 <= '0';
		dmai.Size    <= size;
		if r.write = '1' then
			if r.dstate = writec then
				dmai.Data <= r.data(r.cnt);
			elsif r.dstate = write_r then
				dmai.Data <= r.rfactor;
			elsif r.dstate = write_mode then
				dmai.Data <= (31 downto 2 => '0') & r.mcomp_mode;
			end if;
		else
			dmai.Data <= (others=>'0');
		end if;
		ahbso.hirq    <= (others =>'0');
		ahbso.hindex  <= slvidx;
		ahbso.hconfig <= hconfig;
	end process;
	
	mst : DMA2AHB generic map(
		hindex => mstidx,
		vendorid => VENDOR_NCTU,
		deviceid => NCTU_MCOMP,
		version => verid
	)
	port map(
		-- AMBA AHB system signals
		HCLK => clk,
		HRESETn => rst,

		-- Direct Memory Access Interface
		DMAIn => dmai,
		DMAOut => dmao,

		-- AMBA AHB Master Interface
		AHBIn => ahbmi,
		AHBOut => ahbmo
	);

	ahb_read : process(clk, rst)
	begin 
		if rst = '0' then
			ahbso.hrdata  <= (others => '0');
		elsif rising_edge(clk) then 
			-- read DMA registers
			if (ahbsi.hsel(slvidx) and ahbsi.hready) = '1' then
				case ahbsi.haddr(3 downto 2) is
				when "00" => 
					ahbso.hrdata  <= r.srcaddr;
				when "01" => 
					ahbso.hrdata  <= r.dstaddr;
				when "10" => 
					ahbso.hrdata <= (31 downto 21 => '0') & r.enable & r.srcinc & r.dstinc & r.len;
				when others => 
					ahbso.hrdata  <= (others => '0');
				end case;
			end if;
		end if; 
	end process;

	regs : process(clk)
	begin 
		if rising_edge(clk) then 
			r <= rin; 
		end if; 
	end process;
	--------------------end of dma--------------------
	
	-- process (rst, clk)
	-- begin
		-- if(rst = '0')then
			-- readCountInRow <= (others=>'0');
		-- else if rising_edge(clk) then 
			-- if dmao.active = '1' then
				-- if r.write = '0' then
					-- if dmao.ready = '1' then
						-- if readCountInRow = width then 
							-- readCountInRow <= (others=>'0');
						-- else
							-- readCountInRow <= readCountInRow + 1;
						-- end if;
					-- end if;
				-- else
				-- end if;
			-- end if;
		-- end if;
	-- end process;

-- pragma translate_off
  bootmsg : report_version 
  generic map ("Final " & tost(slvidx) & ": dma test");
-- pragma translate_on
end;

