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

library techmap;
use techmap.gencomp.all;

library nctu;
use nctu.video_acc.all;

entity mcomp is
  generic (
    ahbndx  : integer := 0;
    ahbaddr : integer := 0;
    addrmsk : integer := 16#fff#;
    verid   : integer := 0;
    irq_no  : integer := 0
  );

  port (
    rst     : in  std_ulogic;
    clk     : in  std_ulogic;
    ahbsi   : in  ahb_slv_in_type;
    ahbso   : out ahb_slv_out_type
  );
end;

architecture rtl of mcomp is

constant hconfig : ahb_config_type := (
  0      => ahb_device_reg ( VENDOR_NCTU, NCTU_MCOMP, 0, verid, irq_no),
  4      => ahb_membar(ahbaddr, '1', '0', addrmsk),
  others => X"00000000"
);

signal reg_a : std_logic_vector(31 downto 0);  -- pixel value 1
signal reg_b : std_logic_vector(31 downto 0);  -- pixel value 2
signal reg_c : std_logic_vector(31 downto 0);  -- pixel value 3
signal reg_d : std_logic_vector(31 downto 0);  -- pixel value 4
signal reg_r : std_logic_vector(31 downto 0);  -- rounding value
signal wr_valid : std_logic; -- is the logic selected by a master
signal addr_wr : std_logic_vector(31 downto 0);
signal mode : std_logic_vector(1 downto 0);
signal read_value : std_logic_vector(31 downto 0); 
signal reading : std_logic;
-----------------------------------------------------------------
-- BRAM
-----------------------------------------------------------------
signal ram_addr1: std_logic_vector(4 downto 0);
signal ram_addr2: std_logic_vector(4 downto 0);
signal ram_we1	: std_logic;
signal ram_we2	: std_logic;
signal ram_di1 : std_logic_vector(31 downto 0);
signal ram_di2 : std_logic_vector(31 downto 0);
signal ram_do1 : std_logic_vector(31 downto 0);
signal ram_do2 : std_logic_vector(31 downto 0);
signal next_rdata : std_logic_vector(31 downto 0);
signal next_addr : std_logic_vector(31 downto 0);
begin
  ahbso.hresp   <= "00"; 
  ahbso.hsplit  <= (others => '0'); 
  ahbso.hirq    <= (others => '0');
  ahbso.hcache  <= '0';
  ahbso.hconfig <= hconfig;
  ahbso.hindex  <= ahbndx;
  
	ram : BRAM generic map(
		size => 27,
		addrlen  => 5,
		datalen => 32
	)
	port map (
		CLK1		=> clk,
		CLK2		=> clk,
		Addr1	=> ram_addr1,
		Addr2	=> ram_addr2,
		WE1		=> ram_we1,
		WE2		=> ram_we2,
		Data_In1	=> ram_di1,
		Data_In2	=> ram_di2,
		Data_Out1	=> ram_do1,
		Data_Out2	=> ram_do2
	);

	ready_ctrl : process (clk, rst)
	begin
		if rst = '0' then
			ahbso.hready <= '1';
			elsif rising_edge(clk ) then
			if ahbsi.hsel(ahbndx) = '1' then
				if ahbsi.htrans = "11" and ahbsi.hwrite = '0' then
					ahbso.hready <= '1';
				elsif (ahbsi.htrans(1)) = '1' then
					if ahbsi.hwrite = '0' then 
						ahbso.hready <= '0'; 
					else
						ahbso.hready <= '1'; 
					end if;
				elsif(reading = '1')then
					ahbso.hready <= '1'; 
				end if;
			end if;
		end if;
	end process;

  addr_fetch : process (clk, rst)
  begin
      if rst = '0' then
          addr_wr <= (others => '0');
          wr_valid <= '0';
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
  
  ram_addr1 <= addr_wr(6 downto 2) when (wr_valid = '1' and addr_wr(6 downto 2) < "11011") else 			-- write
			ahbsi.haddr(6 downto 2) + ahbsi.haddr(6 downto 3) when ahbsi.hwrite = '0' and ahbsi.haddr(6 downto 2) < "10010" and ahbsi.htrans = "10" else	-- 1st read
			next_addr(6 downto 2) + next_addr(6 downto 3) when ahbsi.hwrite = '0' and ahbsi.haddr(6 downto 2) < "10010" and ahbsi.htrans = "11" else	-- rest read
			(others => '0');
  ram_we1 <= '1' when (wr_valid = '1' and addr_wr(6 downto 2) < "11011") else '0';
  ram_di1 <= ahbsi.hwdata;
  --ahbso.hrdata <= ram_do1;
  
  ram_addr2 <=  ram_addr1 + 1 when mode = "00" else
				ram_addr1 + 3 when mode = "01" else
				(others => '0');
  ram_we2 <= '0';
  ram_di2 <= (others => '0');
  
	process (clk, rst)
	begin
		if rst = '0' then
			next_addr <= (others => '0');
		elsif rising_edge(clk) then
			if (ahbsi.hsel(ahbndx) and not ahbsi.hwrite)= '1' then
				if ahbsi.htrans = "10" then
					next_addr <= ahbsi.haddr + "100";
				elsif ahbsi.htrans = "11" and next_addr(6 downto 2) < "10001" then -- haddr < 0x44
					next_addr <= next_addr + "100";
				end if;
			else
				next_addr <= (others => '0');
			end if;
		end if;
	end process;

	write_process : process (clk, rst)
	begin
		if rst = '0' then
			reg_a <= (others => '0');
			reg_b <= (others => '0');
			reg_c <= (others => '0');
			reg_d <= (others => '0');
			reg_r <= (others => '0');
		elsif rising_edge(clk) then
			if wr_valid = '1' then
				if addr_wr(6 downto 2) = "11011" then -- 27, 0x6C
					reg_r <= ahbsi.hwdata;
				elsif addr_wr(6 downto 2) = "11100" then -- 28, 0x70 mode
					mode <= ahbsi.hwdata(1 downto 0);
				end if;
			end if;
		end if;
	end process;

	read_process : process (clk, rst)
	variable shift : std_logic_vector(31 downto 0);
	begin
		if rst = '0' then
			read_value <= (others => '0');
			reading <= '0';
		elsif rising_edge(clk) then
			if (ahbsi.hsel(ahbndx)) = '1' and ahbsi.hwrite = '0' then
				reading <= '1';
			else
				reading <= '0';
				ahbso.hrdata <= (others => '0');
				next_rdata <= (others => '0');
			end if;
			if reading = '1' then
				if mode = "00" then
					-- if mode = "00" then
						-- --shift := reg_a + reg_b + 1 - reg_r;
						-- --ahbso.hrdata <= ('0' & shift(31 downto 1));
					-- elsif mode = "01" then
						-- --shift := reg_a + reg_b + reg_c + reg_d + 2 - reg_r;
						-- --ahbso.hrdata <= ("00" & shift(31 downto 2));
					-- else
						-- ahbso.hrdata <= (others => '0');
					-- end if;
					for i in 1 to 3 loop
						shift := ram_do1(i*8+7 downto i*8) + ram_do1((i-1)*8+7 downto (i-1)*8) + 1 - reg_r;
						ahbso.hrdata(i*8+7 downto i*8) <= '0' & shift(7 downto 1);
					end loop;
					shift := ram_do1(7 downto 0) + ram_do2(31 downto 24) + 1 - reg_r;
					ahbso.hrdata(7 downto 0) <= '0' & shift(7 downto 1);
					--next_rdata <= ram_do2;
					-- if no next request
				elsif mode = "01" then
					for i in 0 to 3 loop
						shift := ram_do1(i*8+7 downto i*8) + ram_do2(i*8+7 downto i*8) + 1 - reg_r;
						ahbso.hrdata(i*8+7 downto i*8) <= '0' & shift(7 downto 1);
					end loop;
				end if;
			end if;
		end if;
	end process;

-- pragma translate_off
  bootmsg : report_version 
  generic map ("Lab3 " & tost(ahbndx) & ": Motion Compensation Module rev 1");
-- pragma translate_on
end;

