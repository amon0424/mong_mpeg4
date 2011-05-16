library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BRAM is
	port(
		CLK1: in std_logic;
		WE1: in std_logic;
		Addr1: in std_logic_vector(5 downto 0);
		Data_In1: in std_logic_vector(15 downto 0);
		Data_Out1: out std_logic_vector(15 downto 0);
		
		CLK2: in std_logic;
		WE2: in std_logic;
		Addr2: in std_logic_vector(5 downto 0);
		Data_In2: in std_logic_vector(15 downto 0);
		Data_Out2: out std_logic_vector(15 downto 0)
	);
end BRAM;

architecture Behavioral of BRAM is
	type RAM is array (0 to 63) of std_logic_vector(15 downto 0);
	signal DataMEM: RAM; -- no initial values
begin
	process(CLK1)
	begin
		if CLK1'event and CLK1 = '1' then
			if WE1 = '1' then
				-- Synchronous Write
				DataMEM(to_integer(unsigned(Addr1))) <= Data_In1;
			end if;
			-- Synchronous Read
			Data_Out1 <= DataMEM(to_integer(unsigned(Addr1)));
		end if;
	end process;
	
	-- process(CLK2)
	-- begin
		-- if CLK2'event and CLK2 = '1' then
			-- if WE2 = '1' then
				-- -- Synchronous Write
				-- DataMEM(to_integer(unsigned(Addr2))) <= Data_In2;
			-- end if;
			-- -- Synchronous Read
			-- Data_Out2 <= DataMEM(to_integer(unsigned(Addr2)));
		-- end if;
	-- end process;
end Behavioral;