library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity BRAM is
	port(
		CLK: in std_logic;
		WE: in std_logic;
		Addr: in std_logic_vector(5 downto 0);
		Data_In: in std_logic_vector(15 downto 0);
		Data_Out: out std_logic_vector(15 downto 0)
	);
end BRAM;

architecture Behavioral of BRAM is
	type RAM is array (0 to 63) of std_logic_vector(15 downto 0);
	shared variable DataMEM: RAM; 
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if WE = '1' then
				-- Synchronous Write
				DataMEM(to_integer(unsigned(Addr))) := Data_In;
			end if;
			-- Synchronous Read
			Data_Out <= DataMEM(to_integer(unsigned(Addr)));
		end if;
	end process;
end Behavioral;