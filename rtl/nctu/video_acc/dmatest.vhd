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

library gaisler;
use gaisler.misc.all;

library techmap;
use techmap.gencomp.all;

entity dmatest is
  generic (
    ahbndx  : integer := 0;
    ahbaddr : integer := 0;
    addrmsk : integer := 16#fff#;
    verid   : integer := 0;
    irq_no  : integer := 0;
	
	-- for dma
	hindex : integer := 0;
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
signal valid : std_logic; -- is the logic selected by a master
signal temp_addr : std_logic_vector(31 downto 0);

constant hconfig : ahb_config_type := (
  0      => ahb_device_reg ( VENDOR_NCTU, NCTU_MCOMP, 0, verid, irq_no),
  4      => ahb_membar(ahbaddr, '1', '0', addrmsk),
  others => X"00000000"
);

-- for dma
-- constant pconfig : apb_config_type := (
  -- 0 => ahb_device_reg ( VENDOR_GAISLER, GAISLER_AHBDMA, 0, 0, pirq),
  -- 1 => apb_iobar(paddr, pmask));

type dma_state_type is (readc, writec);
subtype word32 is std_logic_vector(31 downto 0);
type datavec is array (0 to dbuf-1+2) of word32;
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
  cnt     : integer range 0 to dbuf-1+2; --additional one for r, one for action
  readCountInRow : std_logic_vector(3 downto 0);
  src_stride : std_logic_vector(31 downto 0);
  dst_stride : std_logic_vector(31 downto 0);
  src_width : std_logic_vector(3 downto 0);			-- 0~9
  dst_width : std_logic_vector(3 downto 0);			-- 0~9
end record;

signal r, rin : reg_type;
signal dmai : ahb_dma_in_type;
signal dmao : ahb_dma_out_type;
----------------------------------

signal src_addr : std_logic_vector(31 downto 0);	-- 000
signal dst_addr : std_logic_vector(31 downto 0);	-- 001
--signal stride  : std_logic_vector(31 downto 0);		-- 010
signal rfactor  : std_logic_vector(31 downto 0);	-- 011
signal action : std_logic;							-- 100

--signal readCountInRow : std_logic_vector(3 downto 0);	-- 0~9
--signal width : std_logic_vector(3 downto 0);			-- 0~9

begin
	-- ahbso.hresp   <= "00"; 
	-- ahbso.hsplit  <= (others => '0'); 
	-- ahbso.hirq    <= (others => '0');
	-- ahbso.hcache  <= '0';
	-- ahbso.hconfig <= hconfig;
	-- ahbso.hindex  <= ahbndx;

	-- ready_ctrl : process (clk, rst)
	-- begin
		-- if rst = '0' then
			-- ahbso.hready <= '1';
		-- elsif rising_edge(clk ) then
			-- if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1)) = '1' then
				-- ahbso.hready <= '1';-- you should control this signal for
									-- -- multi-cycle data processing
			-- end if;
		-- end if;
	-- end process;

	-- addr_fetch : process (clk, rst)
	-- begin
		-- if rst = '0' then
			-- temp_addr <= (others => '0');
			-- valid <= '0';
		-- elsif rising_edge(clk) then
			-- if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and
				-- ahbsi.hready and ahbsi.hwrite) = '1' then
				-- temp_addr <= ahbsi.haddr;
				-- valid <= '1';
			-- else
				-- valid <= '0';
			-- end if;
		-- end if;
	-- end process;

	-- write_process : process (clk, rst)
	-- begin
		-- if rst = '0' then
			-- src_addr <= (others=>'0');
			-- dst_addr <= (others=>'0');
			-- stride <= (others=>'0');
			-- rfactor <= (others=>'0');
			-- action <= '0';
		-- elsif rising_edge(clk) then
			-- if valid = '1' then
				-- if(temp_addr(2 downto 0) = "000")then
					-- src_addr <= ahbsi.hwdata;
				-- elsif(temp_addr(2 downto 0) = "001")then
					-- dst_addr <= ahbsi.hwdata;
				-- elsif(temp_addr(2 downto 0) = "010")then
					-- stride <= ahbsi.hwdata;
				-- elsif(temp_addr(2 downto 0) = "011")then
					-- rfactor <= ahbsi.hwdata;
				-- elsif(temp_addr(2 downto 0) = "100")then
					-- action <= ahbsi.hwdata(0);
				-- end if;
			-- end if;
		-- end if;
	-- end process;

	-- read_process : process (clk, rst)
	-- variable shift : std_logic_vector(31 downto 0);
	-- begin
	-- if rst = '0' then
		-- ahbso.hrdata <= (others => '0');
	-- elsif rising_edge(clk) then
		-- if (ahbsi.hsel(ahbndx) and ahbsi.hready) = '1' then
			-- if(temp_addr(2 downto 0) = "100")then
				-- ahbso.hrdata <= (31 downto 1 => '0') & action;
			-- end if;
		-- else
		  -- ahbso.hrdata <= (others => '0');
		-- end if;
	-- end if;
	-- end process;
  
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
		
		if r.write = '0' then 
			address := r.srcaddr;
		else 
			address := r.dstaddr; 
		end if;
		
		newlen := r.len - 1;

		if ((r.cnt < dbuf-1 and r.write = '0')
			or (r.cnt < dbuf-1+2 and r.write = '1')
			or (r.len(9 downto 2) = "11111111"))then 
			burst := '1'; 
		else 
			burst := '0'; 
		end if;
		
		start := r.enable;
		
		if dmao.active = '1' then
			if r.write = '0' then
				if dmao.ready = '1' then
					v.data(r.cnt) := dmao.rdata;
					if r.cnt = dbuf-1 then 
						v.write := '1'; 
						v.cnt := 0; 
						v.inhibit := '1';
						address := r.dstaddr; 
						size := r.dstinc;
					else 
						v.cnt := r.cnt + 1; 
					end if;
					
					if r.readCountInRow < r.src_width and not (r.cnt = dbuf-1) then 
						v.readCountInRow := r.readCountInRow + 4;
					else
						v.readCountInRow := "0100";
					end if;
				end if;
			else
				if r.cnt = dbuf-1+2 then 
					start := '0'; 
				end if;
				if dmao.ready = '1' then
					if r.cnt = dbuf-1+2 then 
						v.cnt := 0;
						v.write := '0'; 
						v.len := newlen; 
						v.enable := start; 
						irq := start;
					else 
						v.cnt := r.cnt + 1; 
					end if;
					
					if r.readCountInRow < r.dst_width and not (r.cnt = dbuf-1) then 
						v.readCountInRow := r.readCountInRow + 4;
					else
						v.readCountInRow := "0100";
					end if;
				end if;
			end if;
		end if;

		if r.write = '0' then 
			oldaddr := r.srcaddr(9 downto 0); 
			oldsize := r.srcinc;
		else 
			oldaddr := r.dstaddr(9 downto 0); 
			oldsize := r.dstinc; 
		end if;

		ainc := decode(oldsize);

		--if r.readCountInRow + 4 < r.width then
			newaddr := oldaddr + ainc(3 downto 0);
		--else
			-- newaddr := oldaddr + r.stride(9 downto 0) - r.readCountInRow;
		--end if;

		if (dmao.active and dmao.ready) = '1' then
			if r.write = '0' then 
				if not (r.src_stride = (31 downto 4 => '0') & r.src_width) and r.readCountInRow + 4 > r.src_width then
					v.inhibit := '1';
					v.srcaddr := v.srcaddr + r.src_stride(9 downto 0) - r.readCountInRow;
				else
					v.srcaddr(9 downto 0) := newaddr;
				end if;
			else
				if not (r.dst_stride = (31 downto 4 => '0') & r.dst_width) and r.readCountInRow + 4 > r.dst_width then
					v.inhibit := '1';
					v.dstaddr := v.dstaddr + r.dst_stride(9 downto 0) - r.readCountInRow;
				else
					v.dstaddr(9 downto 0) := newaddr;
				end if;
				v.dstaddr(9 downto 0) := newaddr; 
			end if;
		end if;
		
		

		

		-- write DMA registers
		--if (ahbsi.hsel(ahbndx) and ahbsi.henable and ahbsi.hwrite) = '1' then
		if (ahbsi.hsel(ahbndx) and ahbsi.hwrite) = '1' then
			case ahbsi.haddr(5 downto 2) is
			when "0000" => -- 0x00
				v.srcaddr := ahbsi.hwdata;
			when "0001" => -- 0x04
				v.dstaddr := ahbsi.hwdata;
			when "0010" => -- 0x08
				v.len := ahbsi.hwdata(15 downto 0);
				v.srcinc := ahbsi.hwdata(17 downto 16);
				v.dstinc := ahbsi.hwdata(19 downto 18);
				v.enable := ahbsi.hwdata(20);
			when "0011" => -- 0x0C
				v.src_stride := ahbsi.hwdata;
			when "0100" => -- 0x10
				v.src_width := ahbsi.hwdata(3 downto 0);
			when "0101" => -- 0x14
				v.dst_stride := ahbsi.hwdata;
			when "0110" => -- 0x18
				v.dst_width := ahbsi.hwdata(3 downto 0);
			when "0111" => -- 0x1C
				v.data(dbuf-1+1) := ahbsi.hwdata;	-- r factor
			when others => null;
			end case;
		end if;

		if rst = '0' then
			v.dstate := readc; 
			v.enable := '0'; 
			v.write := '0';
			v.cnt  := 0;
			v.readCountInRow := (others=>'0');
			v.src_stride := (others=>'0');
			v.src_width := (others=>'0');
			v.dst_stride := (others=>'0');
			v.dst_width := (others=>'0');
			v.data(dbuf-1+2) := (31 downto 1 => '0') & '1';
		end if;

		rin <= v;
		
		dmai.address <= address;
		dmai.wdata   <= r.data(r.cnt);
		dmai.start   <= start and not v.inhibit;
		dmai.burst   <= burst;
		dmai.write   <= v.write;
		dmai.size    <= size;
		ahbso.hirq    <= (others =>'0');
		ahbso.hindex  <= ahbndx;
		ahbso.hconfig <= hconfig;
	end process;
	
	ahb_read : process(clk, rst)
	begin 
		if rst = '0' then
			ahbso.hrdata  <= (others => '0');
		elsif rising_edge(clk) then 
			-- read DMA registers
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
	end process;

	regs : process(clk)
	begin 
		if rising_edge(clk) then 
			r <= rin; 
		end if; 
	end process;
	--------------------end of dma--------------------
	
	ahbif : ahbmst generic map (hindex => hindex, devid => verid, incaddr => 1) 
	port map (rst, clk, dmai, dmao, ahbmi, ahbmo);
	
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
  generic map ("Final " & tost(ahbndx) & ": dma test");
-- pragma translate_on
end;

