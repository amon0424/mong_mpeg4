---------------------------------------------------------------------------
-- video_acc.vhd
--
-- Video Accelerator Hardware Package for HW/SW Co-Design
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
use grlib.devices.all;
use grlib.stdlib.all;

library gaisler;
use gaisler.misc.all;

package video_acc is
	component BRAM
		generic (
			size : integer := 64;
			addrlen : integer := 32;
			datalen : integer := 32
		);
		port(
			CLK1: in std_logic;
			WE1: in std_logic;
			Addr1: in std_logic_vector(addrlen-1 downto 0);
			Data_In1: in std_logic_vector(datalen-1 downto 0);
			Data_Out1: out std_logic_vector(datalen-1 downto 0);
			
			CLK2: in std_logic;
			WE2: in std_logic;
			Addr2: in std_logic_vector(addrlen-1 downto 0);
			Data_In2: in std_logic_vector(datalen-1 downto 0);
			Data_Out2: out std_logic_vector(datalen-1 downto 0)
		);
	end component;
	
    component mcomp
        generic (
            ahbndx  : integer := 0;
            ahbaddr : integer := 0;
            addrmsk : integer := 16#fff#;
            verid   : integer := 1;
            irq_no  : integer := 0
        );

        port (
            rst    : in  std_ulogic;
            clk    : in  std_ulogic;
            ahbsi  : in  ahb_slv_in_type;
            ahbso  : out ahb_slv_out_type
        );
    end component;

    -- component idct
        -- generic (
            -- ahbndx  : integer := 0;
            -- ahbaddr : integer := 0;
            -- addrmsk : integer := 16#fff#;
            -- verid   : integer := 0;
            -- irq_no  : integer := 0
        -- );

        -- port(
            -- rst     : in  std_ulogic;
            -- clk     : in  std_ulogic;
            -- ahbsi   : in  ahb_slv_in_type;
            -- ahbso   : out ahb_slv_out_type
        -- );
    -- end component;

	component idct2d
        generic (
            ahbndx  : integer := 0;
            ahbaddr : integer := 0;
            addrmsk : integer := 16#fff#;
            verid   : integer := 0;
            irq_no  : integer := 0
        );

        port(
            rst     : in  std_ulogic;
            clk     : in  std_ulogic;
            ahbsi   : in  ahb_slv_in_type;
            ahbso   : out ahb_slv_out_type
        );
    end component;
	
	component ahbmst is
	generic (
		hindex	: integer := 0;
		hirq		: integer := 0;
		venid	 : integer := VENDOR_GAISLER;
		devid	 : integer := 0;
		version : integer := 0;
		chprot	: integer := 3;
		incaddr : integer := 0
	);
	 port (
		rst	: in	std_ulogic;
		clk	: in	std_ulogic;
		dmai : in ahb_dma_in_type;
		dmao : out ahb_dma_out_type;
		ahbi : in	ahb_mst_in_type;
		ahbo : out ahb_mst_out_type 
		);
	end component;
	
	component mcomp_dma is
	  generic (
		slvidx  : integer := 0;
		ahbaddr : integer := 0;
		addrmsk : integer := 16#fff#;
		verid   : integer := 0;
		irq_no  : integer := 0;
		mstidx : integer := 0;
		dbuf   : integer := 4
	  );

	  port (
		rst     : in  std_ulogic;
		clk     : in  std_ulogic;
		ahbsi   : in  ahb_slv_in_type;
		ahbso   : out ahb_slv_out_type;
		ahbmi : in  ahb_mst_in_type;
		ahbmo : out ahb_mst_out_type 
	  );
	end component;
end;
