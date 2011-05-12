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

package video_acc is

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

    component idct
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

end;
