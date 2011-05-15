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
	
	 -----------------------------------------------------------------
    -- 1-D IDCT signals
    -----------------------------------------------------------------
    type state is (read_f, idct_1d, write_p, ready, stage0, stage1);

    signal prev_substate, next_substate: state;
	signal prev_state, next_state: state;
	
	signal stage : std_logic_vector(1 downto 0);
	signal stage_counter: unsigned(4 downto 0);
	signal action : std_logic;
	
begin
	 -- the wr_addr_fetch process latch the write address so that it
    -- can be used in the data fetch cycle as the destination pointer
    --
    wr_addr_fetch : process (clk, rst)
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

    -- for register writing, data fetch (into registers) should happens one
    -- cycle after the address fetch process.
    --
    write_reg_process : process (clk, rst)
    begin
        if (rst = '0') then
            action <= '0';
        elsif rising_edge(clk) then
            if (stage = "11") then
                action <= '0';
            end if;
            if (wr_valid = '1') then
                if addr_wr(4 downto 0) = "00000" then
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
        elsif rising_edge(clk) then
            if ((ahbsi.hsel(ahbndx) and ahbsi.htrans(1) and
                ahbsi.hready and (not ahbsi.hwrite)) = '1') then
				if addr_wr(4 downto 0) = "00000" then
                    ahbso.hrdata(31 downto 1) <= (others => '0');
                    ahbso.hrdata(0) <= action;
                end if;
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
			prev_substate <= read_f;
		elsif (rising_edge(clk)) then
			prev_state <= next_state;
			prev_substate <= next_substate;
		end if;
	end process FSM1;
	
	process(prev_state, action, rst)
	begin
		if (rst='0') then
			next_state <= ready;
			stage <= "11";
			stage_counter <= "00000";
		else
			case prev_state is
			when ready =>
				if (action='1') then
					next_state <= stage0;
					stage <= "00"; 
				else
					next_state <= ready;
				end if;
			when stage0 =>
				if (stage_counter > 7) then
					next_state <= stage1;
					stage <= "00";
				else
					next_state <= stage0;
				end if;
			when stage1 =>
				if (stage_counter > 7) then
					next_state <= ready;
					stage <= "11";
				else
					next_state <= stage1;
				end if;
			when others => null;
			end case;
			
			-- sub state
			if (stage(1) = '0') then
				case prev_substate is
				when read_f =>
					next_substate <= idct_1d;
				when idct_1d =>
					next_substate <= write_p;
				when write_p =>
					if( stage_counter < "01000" ) then
						stage_counter <= stage_counter + 1;
						next_substate <= read_f;
					else
						stage_counter <= "00000";
					end if;
				when others => null;
				end case;
			end if;
		end if;
	end process;
	
-- pragma translate_off
    bootmsg : report_version
    generic map ("Lab4 " & tost(ahbndx) & ": IDCT 2D Module rev 1");
-- pragma translate_on	
end rtl;