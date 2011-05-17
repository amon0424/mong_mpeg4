	---------------------------------------------------------------------
	--  controller
	---------------------------------------------------------------------	
	type state is (RDY, STAGE0, STAGE1, READ_F, IDCT_1D, WRITE_p);
	signal cr_state, nx_state: state;
	signal sub_cr_stage, sub_nx_state: state;
	signal run_sub: std_logic;
	FSM_2D: process(rst, clk)
	begin
		if(rst = '0') then
			cr_state <= RDY;
		elsif (rising_edge(clk)) then
		    cr_state <= nx_state;
		end if;
	end process FSM_2D;
	
	process (cr_state, action)
	begin 
		case cr_state is
		when RDY =>
			if (action = '1') then
				nx_state <= STAGE0;
				stage <= '00';
			else
				nx_state <= RDY;
			end if;
		when STAGE0 =>
			if(count0 = '8') then --count0 未宣告
				stage <= '01';
				nx_state <= STAGE1;
			else
				run_sub <= '1';
				nx_state <= STAGE0;
			end if;
		when STAGE1 =>
			if(count1 = '8') then --count1 未宣告
				stage <= '11';
				action <= '0';
				nx_state <= RDY;
			else
				nx_stage <= STAGE1;
		end case;
	end process;	
	
	process (sub_cr_state, run_sub)
	begin 
		case sub_cr_state is
		when READ_F =>
			
		when IDCT_1D =>
		when WRITE_p =>
		end case;
	end process;
	---------------------------------------------------------------------
	--  block ram
	---------------------------------------------------------------------
	signal stage: std_logic_vector(2 downto 0);
	signal Data: std_logic_vector(15 downto 0);
	
	entity BRAM is
	  port (Addr: in std_logic_vector(5 downto 0);
			CLK, WEi, WEt: in std_logic;
			Data_Ini: in std_logic_vector(15 downto 0);
			Data_Int: in std_logic_vector(15 downto 0);
			Data_Outi: out std_logic_vector(15 downto 0);
			Data_Outt: out std_logic_vector(15 downto 0));
	end BRAM;
	
	architecture Behavioral of BRAM is
	type RAM is array(0 to 63) of std_logic_vector(15 downto 0);
	signal DataMEMi: RAM; 
	signal DataMEMt: RAM;
	begin
	  process(CLK)
	  begin
		if rising_edge(CLK) then
		  if WEi = '1' then
		    --Synchronous write
			DataMEMi(to_integer(unsigned(Addr))) <= Data_Ini;
		  end if;
		  --Synchronous read
			Data_Outi <= DataMEMi(to_integer(unsigned(Addr)));
		end if;
		if WEt = '1' then
		    --Synchronous write
			DataMEMt(to_integer(unsigned(Addr))) <= Data_Int;
		  end if;
		  --Synchronous read
			Data_Outt <= DataMEMt(to_integer(unsigned(Addr)));
	  end process;
	end Behavioral;
	---------------------------------------------------------------------
	-- 2D Data Path Begins Here
	---------------------------------------------------------------------
	process (CLK)
	begin
		if stage = "00"
			Addr <= Row_AGU; 
		elsif stage = "01"
			Addr <= Col_AGU;
		end if;
		case stage is 
		when "00" =>
			Data_Ini <= from_regfile;
			Data_Int <= from_p;
		when "01" =>
			Data_Ini <= from_p;
		when "11" =>
			Addr <= from_regfile;
			Data_Ini <= from_regfile;
			Data <= Data_Outi;
		end case;
		if stage = "00" or stage = "01" then
			case Addr(3 downto 0) is 
			when "000" =>
				F0 <= Data_Outi when(stage = "00")else Data_Outt;
			when "001" =>
				F1 <= Data_Outi when(stage = "00")else Data_Outt;
			when "010" =>
				F2 <= Data_Outi when(stage = "00")else Data_Outt;
			when "011" =>
				F3 <= Data_Outi when(stage = "00")else Data_Outt;
			when "100" =>
				F4 <= Data_Outi when(stage = "00")else Data_Outt;
			when "101" =>
				F5 <= Data_Outi when(stage = "00")else Data_Outt;
			when "110" =>
				F6 <= Data_Outi when(stage = "00")else Data_Outt;
			when "111" =>
				F7 <= Data_Outi when(stage = "00")else Data_Outt;
			end case;	
		end if;
	end process;
			
			