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
          if (ahbsi.hsel(ahbndx) and ahbsi.htrans(1)) = '1' then
              ahbso.hready <= '1'; -- you should control this signal for
                                   -- multi-cycle data processing
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
  
  ram_addr1 <= addr_wr(6 downto 2) when (wr_valid = '1' and addr_wr(7) = '0') else (others=>'0');
  ram_we1 <= '1' when (wr_valid = '1' and addr_wr(7) = '0') else '0';
  ram_di1 <= ahbsi.hwdata;
  
  ram_addr2 <= (others => '0');
  ram_we2 <= '0';
  ram_di2 <= (others => '0');

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
              if addr_wr(4 downto 2) = "000" then
                  reg_a <= ahbsi.hwdata;
              
              end if;
          end if;
      end if;
  end process;

  read_process : process (clk, rst)
  variable shift : std_logic_vector(31 downto 0);
  begin
      if rst = '0' then
          ahbso.hrdata <= (others => '0');
      elsif rising_edge(clk) then
          if (ahbsi.hsel(ahbndx) and ahbsi.hready) = '1' then
              if    ahbsi.haddr(4 downto 2) = "000" then
                  ahbso.hrdata <= reg_a;
              elsif ahbsi.haddr(4 downto 2) = "001" then
                  ahbso.hrdata <= reg_b;
              elsif ahbsi.haddr(4 downto 2) = "010" then
                  ahbso.hrdata <= reg_c;
              elsif ahbsi.haddr(4 downto 2) = "011" then
                  ahbso.hrdata <= reg_d;
              elsif ahbsi.haddr(4 downto 2) = "100" then
                  ahbso.hrdata <= reg_r;
              elsif ahbsi.haddr(4 downto 2) = "101" then
                  shift := reg_a + reg_b + 1 - reg_r;
            	  ahbso.hrdata <= ('0' & shift(31 downto 1));
              elsif ahbsi.haddr(4 downto 2) = "110" then
                  shift := reg_a + reg_b + reg_c + reg_d + 2 - reg_r;
            	  ahbso.hrdata <= ("00" & shift(31 downto 2));
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
  generic map ("Lab3 " & tost(ahbndx) & ": Motion Compensation Module rev 1");
-- pragma translate_on
end;

