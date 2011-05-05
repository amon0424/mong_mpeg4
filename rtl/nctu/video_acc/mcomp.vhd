---------------------------------------------------------------------------
-- mcomp.vhd
--
-- Motion Compensation Hardware for HW/SW Co-Design
--		 Created:	YCC 03-31-2008
--		 Modified: CJT 04-21-2008
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
use ieee.numeric_std.all;

library grlib;
use grlib.amba.all;
use grlib.stdlib.all;
use grlib.devices.all;

library techmap;
use techmap.gencomp.all;

entity mcomp is
	generic (
		ahbndx  : integer := 0;
		ahbaddr : integer := 0;
		addrmsk : integer := 16#fff#;
		verid   : integer := 0;
		irq_no  : integer := 0;
		block_ub: integer := 107;
		pixelend_addr: integer := 107;
		rounding_addr: integer := 108;
		mode_addr: integer := 112;
		stride: integer := 12
	);

	port (
		rst		 : in	std_ulogic;
		clk		 : in	std_ulogic;
		ahbsi	 : in	ahb_slv_in_type;
		ahbso	 : out ahb_slv_out_type
	);
end;

architecture rtl of mcomp is

constant hconfig : ahb_config_type := (
	0			=> ahb_device_reg ( VENDOR_NCTU, NCTU_MCOMP, 0, verid, irq_no),
	4			=> ahb_membar(ahbaddr, '1', '0', addrmsk),
	others => X"00000000"
);
type block_9x9 is array (0 to block_ub) of std_logic_vector(7 downto 0);
signal reg_r : std_logic_vector(31 downto 0);	-- rounding value
signal valid : std_logic; -- is the logic selected by a master
signal reg_mode : std_logic_vector(1 downto 0); -- 0 for 2-point interpolation, 1 for 4-point
signal temp_addr : std_logic_vector(31 downto 0);
signal pixel: block_9x9;
signal pixel_index: integer range 0 to 116;
signal read_ready : std_logic; -- is the logic selected by a master
signal read_done : std_logic; -- is the logic selected by a master

-- pragma translate_off
-- The following signals are used for GHDL simulation, you don't
-- need these for ModleSim simulation
signal hsel		: std_logic_vector(0 to NAHBSLV-1); -- slave select
signal haddr	 : std_logic_vector(31 downto 0);		-- address bus (byte)
signal hwrite	: std_ulogic;											 -- read/write
signal hwdata	: std_logic_vector(31 downto 0);		-- write data bus
signal hiready : std_ulogic;											 -- transfer done
-- pragma translate_on

begin
	ahbso.hresp		<= "00"; 
	ahbso.hsplit	<= (others => '0'); 
	ahbso.hirq		<= (others => '0');
	ahbso.hcache	<= '0';
	ahbso.hconfig	<= hconfig;
	ahbso.hindex	<= ahbndx;
	
	
-- pragma translate_off
-- The following signals are used for GHDL simulation, you don't
-- need these for ModleSim simulation
	hsel	<= ahbsi.hsel;
	haddr	<= ahbsi.haddr;
	hwrite	<= ahbsi.hwrite;
	hwdata	<= ahbsi.hwdata;
	hiready	<= ahbsi.hready; 
-- pragma translate_on

	ready_ctrl : process (clk, rst)
	begin
			if rst = '0' then
				ahbso.hready <= '1';
			elsif rising_edge(clk ) then
				if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1)) = '1' then
					if(ahbsi.hwrite='1')then	-- write data
						ahbso.hready <= '1'; 	-- you should control this signal for
												-- multi-cycle data processing 
					else						-- read data, need 1 more cycle
						ahbso.hready <= '0';
					end if;
				elsif (read_ready='1') then		-- read data done
					ahbso.hready <= '1';
				end if;
			end if;
	end process;

	addr_fetch : process (clk, rst)
	begin
		if rst = '0' then
			temp_addr <= (others => '0');
			valid <= '0';
			pixel_index <= 0;
			read_ready <= '0';
		elsif rising_edge(clk) then
			if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and
				ahbsi.hready and ahbsi.hwrite) = '1' then
				temp_addr <= ahbsi.haddr;
				pixel_index <= conv_integer(ahbsi.haddr(6 downto 0));
				valid <= '1';
				read_ready <= '0';
			elsif (ahbsi.hsel(ahbndx) and  ahbsi.htrans(1) and ahbsi.hready)='1' and ahbsi.hwrite = '0'then
				pixel_index <= conv_integer(ahbsi.haddr(6 downto 0));
				read_ready <= '1';
			else
				valid <= '0';
				read_ready <= '0';
			end if;
		end if;
	end process;

	write_process : process (clk, rst)
	begin
		if rst = '0' then
			reg_r <= (others => '0');
			reg_mode <= "00";
		elsif rising_edge(clk) then
			if valid = '1' then
				if( pixel_index >= 0 and pixel_index <= pixelend_addr) then
					pixel(pixel_index) <= ahbsi.hwdata(7 downto 0);
					pixel(pixel_index+1) <= ahbsi.hwdata(15 downto 8);
					pixel(pixel_index+2) <= ahbsi.hwdata(23 downto 16);
					pixel(pixel_index+3) <= ahbsi.hwdata(31 downto 24);
				elsif(pixel_index = rounding_addr) then
					reg_r <= ahbsi.hwdata;
				elsif(pixel_index = mode_addr) then
					reg_mode <= ahbsi.hwdata(1 downto 0);
				end if;
			end if;
		end if;
	end process;

	read_process : process (clk, rst)
	variable shift1 : std_logic_vector(9 downto 0);
	variable shift2 : std_logic_vector(9 downto 0);
	variable shift3 : std_logic_vector(9 downto 0);
	variable shift4 : std_logic_vector(9 downto 0);
	begin
		if rst = '0' then
			ahbso.hrdata	<= (others => '0');
			read_done <= '0';
		elsif rising_edge(clk) then
			if (read_ready)='1' then
				if( pixel_index >= 0 and pixel_index <= pixelend_addr) then		--pixel value
					case reg_mode is
					when "00" =>	--2-point interpolation h
						shift1 := ("00" & pixel(pixel_index)) + pixel(pixel_index+1) + 1 - reg_r(7 downto 0);
						shift2 := ("00" & pixel(pixel_index+1)) + pixel(pixel_index+2) + 1 - reg_r(7 downto 0);
						shift3 := ("00" & pixel(pixel_index+2)) + pixel(pixel_index+3) + 1 - reg_r(7 downto 0);
						shift4 := ("00" & pixel(pixel_index+3)) + pixel(pixel_index+4) + 1 - reg_r(7 downto 0);
						
						ahbso.hrdata(7 downto 0) <= (shift1(8 downto 1));
						ahbso.hrdata(15 downto 8) <= (shift2(8 downto 1));
						ahbso.hrdata(23 downto 16) <= (shift3(8 downto 1));
						ahbso.hrdata(31 downto 24) <= (shift4(8 downto 1));
					when "01" =>	--2-point interpolation v
						shift1 := ("00" & pixel(pixel_index)) + pixel(pixel_index+stride) + 1 - reg_r(7 downto 0);
						shift2 := ("00" & pixel(pixel_index+1)) + pixel(pixel_index+stride+1) + 1 - reg_r(7 downto 0);
						shift3 := ("00" & pixel(pixel_index+2)) + pixel(pixel_index+stride+2) + 1 - reg_r(7 downto 0);
						shift4 := ("00" & pixel(pixel_index+3)) + pixel(pixel_index+stride+3) + 1 - reg_r(7 downto 0);
						
						ahbso.hrdata(7 downto 0) <= (shift1(8 downto 1));
						ahbso.hrdata(15 downto 8) <= (shift2(8 downto 1));
						ahbso.hrdata(23 downto 16) <= (shift3(8 downto 1));
						ahbso.hrdata(31 downto 24) <= (shift4(8 downto 1));	
					when "10" =>	--4-point interpolation
						shift1 := ("00" & pixel(pixel_index)) +  pixel(pixel_index+1) + pixel(pixel_index+stride) + pixel(pixel_index+stride+1) + 2 - reg_r(7 downto 0);
						shift2 := ("00" & pixel(pixel_index+1)) +  pixel(pixel_index+2) + pixel(pixel_index+stride+1) + pixel(pixel_index+stride+2) + 2 - reg_r(7 downto 0);
						shift3 := ("00" & pixel(pixel_index+2)) +  pixel(pixel_index+3) + pixel(pixel_index+stride+2) + pixel(pixel_index+stride+3) + 2 - reg_r(7 downto 0);
						shift4 := ("00" & pixel(pixel_index+3)) +  pixel(pixel_index+4) + pixel(pixel_index+stride+3) + pixel(pixel_index+stride+4) + 2 - reg_r(7 downto 0);
						
						ahbso.hrdata(7 downto 0) <= shift1(9 downto 2);
						ahbso.hrdata(15 downto 8) <= shift2(9 downto 2);
						ahbso.hrdata(23 downto 16) <= shift3(9 downto 2);
						ahbso.hrdata(31 downto 24) <= shift4(9 downto 2);
					when others =>
						ahbso.hrdata <= (others => 'X');
					end case;
					read_done <= '1';
				elsif(pixel_index = rounding_addr) then
					ahbso.hrdata <= reg_r;
				elsif(pixel_index = mode_addr) then
					ahbso.hrdata <= (31 downto 2 => '0') & reg_mode;
				else
					ahbso.hrdata <= (others => '0');
				end if;
			else
				ahbso.hrdata <= (others => '0');
			end if;
		end if;
	end process;

-- pragma translate_off
	bootmsg : report_version 
	generic map ("Lab3 " & tost(ahbndx) & ": Motion Compensation Module rev 2");
-- pragma translate_on
end;