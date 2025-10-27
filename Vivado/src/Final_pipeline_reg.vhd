library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Final_pipeline_reg is
    port(
			Clk, Rst : in std_logic;
			D : in std_logic_vector(23 downto 0);
			Q : out std_logic_vector(23 downto 0)
    );
end Final_pipeline_reg;


architecture Behavioral of Final_pipeline_reg is

	begin
		
		process(Clk)
			begin		
				if(rising_edge(Clk)) then
					if(Rst = '1') then
						Q <= (others=>'0');
					elsif( Rst = '0' ) then
						Q <= D;
					end if;
				end if;
		end process;

end Behavioral;