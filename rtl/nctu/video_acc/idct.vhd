---------------------------------------------------------------------------
-- idct.vhd
--
-- IDCT Hardware for HW/SW Co-Design
--     Created:  CJT 04-30-2006 for ARM E7T-D
--     Modified: CJT 05-04-2010 for LEON/GRLIB
--
-------------------------------------------------------------------------
-- This is the RTL code of an 8-point 1-D IDCT logic for MPEG video
-- decoders. It uses a 4x4 matrix-vector multiplication to compute
-- IDCT. Not very efficient but it serves some educational purposes.
--
-------------------------------------------------------------------------
-- The maximum speed of this logic on a Spartan 3 (3s1500fg456-4) device
-- is 69.482 MHz.
--

-- Number of Slices:                     515  out of  13312     3%
-- Number of Slice Flip Flops:           664  out of  26624     2%
-- Number of 4 input LUTs:               703  out of  26624     2%
-- Number of IOs:                         69
-- Number of bonded IOBs:                 65  out of    333    19%
-- Number of MULT18X18s:                   4  out of     32    12%
-- Number of GCLKs:                        1  out of      8    12%
--
-------------------------------------------------------------------------
-- This code is for the class "Embedded Firmware and Hardware/Software
-- Co-design" in Spring, 2010.
-- Dept. of Computer Science
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

entity idct is
    port(
		rst, clk: in std_logic;
		Fin : in std_logic_vector(15 downto 0);
		pout : out std_logic_vector(15 downto 0);
		rw: in std_logic;
		rw_stage : in std_logic_vector(2 downto 0);
		--F0, F1, F2, F3, F4, F5, F6, F7: in std_logic_vector(15 downto 0);
		--p0, p1, p2, p3, p4, p5, p6, p7: out std_logic_vector(15 downto 0);
		action_in: in std_logic;
		done:	out std_logic 	-- 0 for write action, 1 for read action
    );
end entity idct;

architecture rtl of idct is
    -- AMBA bus control signals
    signal wr_valid : std_logic; -- is the logic selected by a master
    signal addr_wr : std_logic_vector(31 downto 0);

    -----------------------------------------------------------------
    -- 1-D IDCT signals
    -----------------------------------------------------------------
    type state is (init_hv, init_g2p, calc_hv, calc_g2p);

    signal hv_pr_state, hv_nx_state: state;
    signal g2p_pr_state, g2p_nx_state: state;

	signal F0, F1, F2, F3, F4, F5, F6, F7: std_logic_vector(15 downto 0);
	signal p0, p1, p2, p3, p4, p5, p6, p7: std_logic_vector(15 downto 0);
    signal g0, g1, g2, g3, g4, g5, g6, g7: signed(31 downto 0);
	
    signal v0, v1, v2, v3: std_logic_vector(15 downto 0);
    signal m1, m2, m3, m4: signed(31 downto 0);
    
	signal action: std_logic;
    signal action_two: std_logic;
    signal main_cntr: unsigned(4 downto 0);
    signal aux_cntr: unsigned(3 downto 0);

    signal h00, h01, h02, h03 : signed(15 downto 0);
    signal h10, h11, h12, h13 : signed(15 downto 0);
    signal h20, h21, h22, h23 : signed(15 downto 0);
    signal h30, h31, h32, h33 : signed(15 downto 0);

    -- Even-point IDCT Kernel Matrix
    constant HU0 : signed(15 downto 0) := X"02D4";	--724
    constant HU1 : signed(15 downto 0) := X"03B2";	--946
    constant HU2 : signed(15 downto 0) := X"0188";	--392

    -- Odd-point IDCT Kernel Matrix
    constant HL0 : signed(15 downto 0) :=  X"03EC";	--1004
    constant HL1 : signed(15 downto 0) :=  X"0353";	--851
    constant HL2 : signed(15 downto 0) :=  X"0239";	--569
    constant HL3 : signed(15 downto 0) :=  X"00C8";	--200

    signal ack_temp: std_ulogic;
begin
    action_two <= '1' when (action = '1' and main_cntr > "00011") else '0';	-- when main_cntr >= 4 (g0-g3 computed), enable action2

    ---------------------------------------------------------------------
    --  Register File Management Begins Here
    ---------------------------------------------------------------------
    -- This process handles read/write of the following registers:
    --    1. Eight 16-bit input idct coefficient registers (F0 ~ F7)
    --    2. Eight 16-bit output pixel values (p0 ~ p7)
    --    3. A 1-bit register, action, signals the execution and
    --       completion of the IDCT logic
    --

    process (clk, rst)
    begin
        if (rst = '0') then
			pout <= (others => '0');
        elsif rising_edge(clk) then
			if(rw='0')then
				case rw_stage is
				when "000" =>
					pout <= p0;
				when "001" =>
					pout <= p1;
				when "010" =>
					pout <= p2;
				when "011" =>
					pout <= p3;
				when "100" =>
					pout <= p4;
				when "101" =>
					pout <= p5;
				when "110" =>
					pout <= p6;
				when "111" =>
					pout <= p7;
				when others => null;
				end case;
			else
				case rw_stage is
				when "000" =>
					F0 <= Fin;
				when "001" =>		
					F1 <= Fin;
				when "010" =>
					F2 <= Fin;
				when "011" =>
					F3 <= Fin;
				when "100" =>
					F4 <= Fin;
				when "101" =>
					F5 <= Fin;
				when "110" =>
					F6 <= Fin;
				when "111" =>
					F7 <= Fin;
				when others => null;
				end case;
			end if;
        end if;
    end process;
	
	action_control_process : process (clk, rst)
    begin
        if (rst = '0') then
			action <= '0';
			done <= '1';
        elsif rising_edge(clk) then
			if(action_in = '1' and action = '0')then
				action <= '1';
				done <= '0';
			else
				if (main_cntr > "00111") then
					action <= '0';
					done <= '1';
				end if;
			end if;
        end if;
    end process action_control_process;

    ---------------------------------------------------------------------
    --  Controller (Finite State Machines) Begins Here
    ---------------------------------------------------------------------

    process(rst, clk)
    begin
        if (rst = '0') then
            main_cntr <= "00000";
        elsif (rising_edge(clk)) then
            if (action = '1') then
                if (main_cntr < "01000") then	-- if main_cntr < 8
                    main_cntr <= main_cntr + 1;
                else
                    main_cntr <= "00000";
                end if;
            end if;
        end if;
    end process;

    process(rst, clk)
    begin
        if (rst = '0') then
            aux_cntr <= "0000";
        elsif (rising_edge(clk)) then
            if (main_cntr > "00011") then	-- if main_cntr >= 4 ( g0~g3 computed )
                aux_cntr <= aux_cntr + 1;
            else
                aux_cntr <= "0000";
            end if;
        end if;
    end process;

    FSM_1: process(rst, clk)
    begin
        if (rst = '0') then
            hv_pr_state <= init_hv;
        elsif (rising_edge(clk)) then
            hv_pr_state <= hv_nx_state;
        end if;
    end process FSM_1;

    process(hv_pr_state, action, main_cntr)
    begin
        case hv_pr_state is		-- when previous state is 
        when init_hv =>			-- init_hv
            if (action = '1') then
                hv_nx_state <= calc_hv;		-- if action=1, change state to clac_hv
            else
                hv_nx_state <= init_hv;
            end if;
        when calc_hv =>			-- calc_hv
            if (main_cntr > "00111") then	-- if main_cntr > 7 ( g0~g7 computed )
                hv_nx_state <= init_hv;		-- change state to init_hv
            else
                hv_nx_state <= calc_hv;
            end if;
        when others => null;
        end case;
    end process;

    -- FSM_2: process(rst, clk)
    -- begin
        -- if (rst = '0') then
            -- g2p_pr_state <= init_g2p;
        -- elsif (rising_edge(clk)) then
            -- g2p_pr_state <= g2p_nx_state;
        -- end if;
    -- end process FSM_2;

    -- process(g2p_pr_state, main_cntr, action_two, aux_cntr)
    -- begin
        -- case g2p_pr_state is	-- when previous state is 
        -- when init_g2p =>		-- init_g2p
            -- if (action_two = '1') then
                -- g2p_nx_state <= calc_g2p;	-- if action2=1, change state to calc_g2p
            -- else
                -- g2p_nx_state <= init_g2p;
            -- end if;
        -- when calc_g2p =>		-- calc_g2p
            -- if (aux_cntr > "0011") then		-- if aux_cntr >= 4	( g0~g6 computed )
                -- g2p_nx_state <= init_g2p;	-- change state to init_g2p
            -- else
                -- g2p_nx_state <= calc_g2p;
            -- end if;
        -- when others => null;
        -- end case;
    -- end process;

    ---------------------------------------------------------------------
    --  Data Path Begins Here
    ---------------------------------------------------------------------

    ----------------------------------------
    --  Combinational logic for H times v   --
    ----------------------------------------

    -- Selection of IDCT kernel matrix
	-- main_cntr(2) = 0 => main_cntr=0~3
	-- main_cntr(2) = 1 => main_cntr=4~7
	
	-- row0
    h00 <=  HU0 when (main_cntr(2) = '0') else  HL0;
    h01 <=  HU1 when (main_cntr(2) = '0') else  HL1;
    h02 <=  HU0 when (main_cntr(2) = '0') else  HL2;
    h03 <=  HU2 when (main_cntr(2) = '0') else  HL3;

	-- row1
    h10 <=  HU0 when (main_cntr(2) = '0') else -HL1;
    h11 <=  HU2 when (main_cntr(2) = '0') else  HL3;
    h12 <= -HU0 when (main_cntr(2) = '0') else  HL0;
    h13 <= -HU1 when (main_cntr(2) = '0') else  HL2;

	-- row2
    h20 <=  HU0 when (main_cntr(2) = '0') else  HL2;
    h21 <= -HU2 when (main_cntr(2) = '0') else -HL0;
    h22 <= -HU0 when (main_cntr(2) = '0') else  HL3;
    h23 <=  HU1 when (main_cntr(2) = '0') else  HL1;

	-- row3
    h30 <=  HU0 when (main_cntr(2) = '0') else -HL3;
    h31 <= -HU1 when (main_cntr(2) = '0') else  HL2;
    h32 <=  HU0 when (main_cntr(2) = '0') else -HL1;
    h33 <= -HU2 when (main_cntr(2) = '0') else  HL0;

    -- Selection of input vector (v)
    v0 <= F0 when (main_cntr(2) = '0') else F1;
    v1 <= F2 when (main_cntr(2) = '0') else F3;
    v2 <= F4 when (main_cntr(2) = '0') else F5;
    v3 <= F6 when (main_cntr(2) = '0') else F7;

    -- Computation of H*v
    h_mul_v: process(rst, clk)
    begin
        if (rst = '0') then
            m1 <= (others => '0');
            m2 <= (others => '0');
            m3 <= (others => '0');
            m4 <= (others => '0');
        elsif (rising_edge(clk)) then
            if (action = '1') then
                case main_cntr(1 downto 0) is	-- main_cntr(1~0)=0~3
                when "00" =>
                    m1 <= h00*signed(v0);
                    m2 <= h01*signed(v1);
                    m3 <= h02*signed(v2);
                    m4 <= h03*signed(v3);
                when "01" =>
                    m1 <= h10*signed(v0);
                    m2 <= h11*signed(v1);
                    m3 <= h12*signed(v2);
                    m4 <= h13*signed(v3);
                when "10" =>
                    m1 <= h20*signed(v0);
                    m2 <= h21*signed(v1);
                    m3 <= h22*signed(v2);
                    m4 <= h23*signed(v3);
                when "11" =>
                    m1 <= h30*signed(v0);
                    m2 <= h31*signed(v1);
                    m3 <= h32*signed(v2);
                    m4 <= h33*signed(v3);
                when others => null;
                end case;
            end if;
        end if;
    end process h_mul_v;

    -- Register output from the adder tree in the g array, one per cycle
    --
    process(rst, clk)
    begin
        if (rst = '0') then
            g0 <= (others => '0'); g1 <= (others => '0');
            g2 <= (others => '0'); g3 <= (others => '0');
            g4 <= (others => '0'); g5 <= (others => '0');
            g6 <= (others => '0'); g7 <= (others => '0');
        elsif (rising_edge(clk)) then
            if (hv_pr_state = calc_hv) then
                case main_cntr(3 downto 0) is	-- when main_counter = 1~8 ( wait 1 cycle for m register write )
                when "0001" => g0 <= m1 + m2 + m3 + m4;
                when "0010" => g1 <= m1 + m2 + m3 + m4;
                when "0011" => g2 <= m1 + m2 + m3 + m4;
                when "0100" => g3 <= m1 + m2 + m3 + m4;
                when "0101" => g4 <= m1 + m2 + m3 + m4;
                when "0110" => g5 <= m1 + m2 + m3 + m4;
                when "0111" => g6 <= m1 + m2 + m3 + m4;
                when "1000" => g7 <= m1 + m2 + m3 + m4;
                when others => null;
                end case;
            end if;
        end if;
    end process;

    -------------------------------------
    --  Data Path that solves p from g --
    -------------------------------------
    process(rst, clk, aux_cntr)
    variable tmp1, tmp2 : std_logic_vector(31 downto 0);
    begin
        if (rst = '0') then
            p0 <= (others => '0'); p1 <= (others => '0');
            p2 <= (others => '0'); p3 <= (others => '0');
            p4 <= (others => '0'); p5 <= (others => '0');
            p6 <= (others => '0'); p7 <= (others => '0');
        elsif (rising_edge(clk)) then
			-- g4 is computed when main_cntr=5 => aux_cntr=2
            if (aux_cntr > "0001") then		-- if aux_cntr >= 2
                case aux_cntr(2 downto 0) is	-- aux_cntr(2~0)=2~5
                when "010" =>
                    tmp1 := std_logic_vector(g0 + g4 + 1024);
                    tmp2 := std_logic_vector(g0 - g4 + 1024);
                when "011" =>
                    tmp1 := std_logic_vector(g1 + g5 + 1024);
                    tmp2 := std_logic_vector(g1 - g5 + 1024);
                when "100" =>
                    tmp1 := std_logic_vector(g2 + g6 + 1024);
                    tmp2 := std_logic_vector(g2 - g6 + 1024);
                when "101" =>
                    tmp1 := std_logic_vector(g3 + g7 + 1024);
                    tmp2 := std_logic_vector(g3 - g7 + 1024);
                when others => null;
                end case;

				-- tmp >> 11
                case aux_cntr(2 downto 0) is	-- aux_cntr(2~0)=2~5
                when "010" =>
                    p0(15 downto 0) <= tmp1(26 downto 11);
                    p7(15 downto 0) <= tmp2(26 downto 11);
                when "011" =>
                    p6(15 downto 0) <= tmp1(26 downto 11);
                    p1(15 downto 0) <= tmp2(26 downto 11);
                when "100" =>
                    p2(15 downto 0) <= tmp1(26 downto 11);
                    p5(15 downto 0) <= tmp2(26 downto 11);
                when "101" =>
                    p4(15 downto 0) <= tmp1(26 downto 11);
                    p3(15 downto 0) <= tmp2(26 downto 11);
                when others => null;
                end case;
            end if;
        end if;
    end process;
end;
