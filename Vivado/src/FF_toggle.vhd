library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity FF_toggle is 
	port(
			Clk, Clr, En, T : in std_logic;
			Q: out std_logic 
		);
end FF_toggle;


architecture behavioral of FF_toggle is

signal temp: std_logic;

	begin
		
		process(Clk)
			begin
				if rising_edge(Clk) then
					if (Clr = '1') then
						temp <= '0';
					elsif En = '1' then
						if T='1' then
							temp <= not(temp);
						else
							temp <= temp;
						end if;
					end if;
				end if;
		end process;
		
		Q <= temp;
	
end behavioral;