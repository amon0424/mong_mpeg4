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
        rst     : in  std_ulogic;
        clk     : in  std_ulogic;
        ahbsi   : in  ahb_slv_in_type;
        ahbso   : out ahb_slv_out_type
    );
end entity idct2d;

architecture rtl of idct2d is
    constant hconfig : ahb_config_type := (
      0      => ahb_device_reg (VENDOR_NCTU, NCTU_IDCT, 0, verid, irq_no),
      4      => ahb_membar(ahbaddr, '1', '0', addrmsk),
      others => X"00000000"
    );

    -- AMBA bus control signals
    signal wr_valid : std_logic; -- is the logic selected by a master
    signal addr_wr : std_logic_vector(31 downto 0);
begin

-- pragma translate_off
    bootmsg : report_version
    generic map ("Lab4 " & tost(ahbndx) & ": IDCT 2D Module rev 1");
-- pragma translate_on	
end rtl;