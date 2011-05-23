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

component BRAM_S8_S8
	port(
		CLK1: in std_logic;
		WE1: in std_logic;
		Addr1: in std_logic_vector(6 downto 0);
		Data_In1: in std_logic_vector(7 downto 0);
		Data_Out1: out std_logic_vector(7 downto 0);
		CLK2: in std_logic;
		WE2: in std_logic;
		Addr2: in std_logic_vector(6 downto 0);
		Data_In2: in std_logic_vector(7 downto 0);
		Data_Out2: out std_logic_vector(7 downto 0)
	);
end component;


signal reg_r : std_logic_vector(31 downto 0);	-- rounding value
signal valid : std_logic; -- is the logic selected by a master
signal reg_mode : std_logic_vector(1 downto 0); -- 0 for 2-point interpolation, 1 for 4-point
signal temp_addr : std_logic_vector(31 downto 0);

signal pixel_index: integer range 0 to 116;
signal read_ready : std_logic; -- is the logic selected by a master
signal read_done : std_logic; -- is the logic selected by a master

signal pixel_we : std_logic;
signal pixel_addr1: std_logic_vector(6 downto 0);
signal pixel_addr2: std_logic_vector(6 downto 0);
signal pixel_in1: std_logic_vector(7 downto 0);
signal pixel_in2: std_logic_vector(7 downto 0);
signal pixel_out1: std_logic_vector(7 downto 0);
signal pixel_out2: std_logic_vector(7 downto 0);

signal compute_pixel: std_logic_vector(2 downto 0);
signal read_data: std_logic_vector(31 downto 0);
signal writing: std_logic; 
begin
	ahbso.hresp		<= "00"; 
	ahbso.hsplit	<= (others => '0'); 
	ahbso.hirq		<= (others => '0');
	ahbso.hcache	<= '0';
	ahbso.hconfig	<= hconfig;
	ahbso.hindex	<= ahbndx;

	pixel: BRAM_S8_S8 port map (
		clk,
		pixel_we,
		pixel_addr1, 
		pixel_in1,
		pixel_out1,
		clk,
		pixel_we,
		pixel_addr2, 
		pixel_in2,
		pixel_out2
	);

	ready_ctrl : process (clk, rst)
	begin
			if rst = '0' then
				ahbso.hready <= '1';
			elsif rising_edge(clk ) then
				if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1)) = '1' then
					if(ahbsi.hwrite='1' and ahbsi.haddr(6 downto 0) < 108)then	-- write data
						ahbso.hready <= '1'; 	-- you should control this signal for
												-- multi-cycle data processing 
					else						-- read data, need 1 more cycle
						ahbso.hready <= '0';
					end if;
				elsif (read_ready='1' or writing_stage='1') then		-- read data done
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
			if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and ahbsi.hready and ahbsi.hwrite) = '1' then
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
					-- pixel(pixel_index) <= ahbsi.hwdata(7 downto 0);
					-- pixel(pixel_index+1) <= ahbsi.hwdata(15 downto 8);
					-- pixel(pixel_index+2) <= ahbsi.hwdata(23 downto 16);
					-- pixel(pixel_index+3) <= ahbsi.hwdata(31 downto 24);
					
				elsif(pixel_index = rounding_addr) then
					reg_r <= ahbsi.hwdata;
				elsif(pixel_index = mode_addr) then
					reg_mode <= ahbsi.hwdata(1 downto 0);
				end if;
			end if;
		end if;
	end process;
	
	process (clk, rst)
	begin
		if rst = '0' then
			compute_pixel = "000";
		elsif rising_edge(clk) then
			pixel_addr1 <= 	ahbsi.haddr(6 downto 1);	
			pixel_addr2 <=  pixel_addr1 + 1 when  reg_mode = "00";
		end if;
	end process;
	
	signal writing_stage : std_logic;
	signal reading_stage : std_logic;
	
	pixel_in_control: process (clk, rst)
	begin
		if rst = '0' then
			writing_stage <= "11";
			writing <= '0';
		elsif rising_edge(clk) then
			if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and ahbsi.hready and ahbsi.hwrite) = '1' and 
				ahbsi.haddr(6 downto 0) < 108 then
				writing = '1';
				writing_stage = "00";
			end if;
			
			if(writing = '1')then
				if(writing_stage = '0')
					writing_stage = '1';
				else
					writing_stage = '0';
				end if;
			else
				writing_stage <= '0';
			end if;
		end if;
	end process pixel_in_control;
	
	pixel_in_control: process (clk, rst)
	begin
		if rst = '0' then
			pixel_in1 <= (others=>'0');
			pixel_in1 <= (others=>'0');
			pixel_we <= '0';
		elsif rising_edge(clk) then
			if(writing = '1')then
				pixel_we <= '1';
				if(writing_stage='0')
					pixel_in1 <= ahbsi.hwdata(7 downto 0);
					pixel_in2 <= ahbsi.hwdata(15 downto 8);
				else
					pixel_in1 <= ahbsi.hwdata(23 downto 16);
					pixel_in2 <= ahbsi.hwdata(31 downto 24);
				end if;
			else
				pixel_we <= '0';
			end if;
		end if;
	end process pixel_in_control;
	
	signal last_pixel_addr : std_logic_vector(6 downto 0);
	
	pixel_addr_control: process (clk, rst)
	begin
		if rst = '0' then
			pixel_addr1 <= (others=>'0');
			pixel_addr2 <= (others=>'0');
			pixel_in1 <= (others=>'0');
			pixel_in2 <= (others=>'0');
			last_pixel_addr <= (others=>'0');
		elsif rising_edge(clk) then
			if(writing = '1')then
				if(writing_pixel='0')
					pixel_addr1 <= temp_addr(6 downto 0);
					pixel_addr2 <= temp_addr(6 downto 1) & '1';
				else
					pixel_addr1 <= temp_addr(6 downto 0) + 2;
					pixel_addr2 <= temp_addr(6 downto 1) + 4';
					
				end if;
			else if(reading = '1')then
				case reg_mode is
					when "00" =>
						if(reading_stage = "00")
							pixel_addr1 = temp_addr(6 downto 0);
							pixel_addr2 = temp_addr(6 downto 0) + 1;
						else if(reading_stage = "01")
							pixel_addr1 = temp_addr(6 downto 0) + 2;
							pixel_addr2 = temp_addr(6 downto 0) + 3;
						else if(reading_stage = "10")
							pixel_addr1 = temp_addr(6 downto 0) + 4;
						end if;
					when "01" =>
						if(reading_stage = "00")
							pixel_addr1 = temp_addr(6 downto 0);
							pixel_addr2 = temp_addr(6 downto 0) + stride;
						else if(reading_stage = "01")
							pixel_addr1 = temp_addr(6 downto 0) + 1;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 1;
						else if(reading_stage = "10")
							pixel_addr1 = temp_addr(6 downto 0) + 2;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 2;
						else if(reading_stage = "11")
							pixel_addr1 = temp_addr(6 downto 0) + 3;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 3;
						end if;
					when "10" =>
						if(reading_stage = "00")
							pixel_addr1 = temp_addr(6 downto 0);
							pixel_addr2 = temp_addr(6 downto 0) + 1;
						else if(reading_stage = "01")
							pixel_addr1 = temp_addr(6 downto 0) + stride;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 1;
						else if(reading_stage = "10")
							pixel_addr1 = temp_addr(6 downto 0) + 2;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 2;
						else if(reading_stage = "11")
							pixel_addr1 = temp_addr(6 downto 0) + 3;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 3;
						else if(reading_stage = "100")
							pixel_addr1 = temp_addr(6 downto 0) + 4;
							pixel_addr2 = temp_addr(6 downto 0) + stride + 4;
						end if;
				end case;
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