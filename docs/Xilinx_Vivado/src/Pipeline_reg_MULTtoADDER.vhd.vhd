library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Pipeline_reg_MULTtoADDER is
  port (
		Clk,Rst: in std_logic;
        In_reg1,In_reg2,In_reg3,In_reg4,In_reg5,In_reg6: in std_logic_vector(19 downto 0);
        Out_reg1,Out_reg2,Out_reg3,Out_reg4,Out_reg5,Out_reg6: out std_logic_vector(19 downto 0)
		);    
end Pipeline_reg_MULTtoADDER;

architecture Behavioral of Pipeline_reg_MULTtoADDER is

begin

	process(Clk)
	
	begin
	
		if(rising_edge(Clk)) then
			if(Rst = '1')then
				Out_reg1 <= (others=>'0');
				Out_reg2 <= (others=>'0');
				Out_reg3 <= (others=>'0');
				Out_reg4 <= (others=>'0');
				Out_reg5 <= (others=>'0');
				Out_reg6 <= (others=>'0');				
			else
				Out_reg1 <= In_reg1;
				Out_reg2 <= In_reg2;
				Out_reg3 <= In_reg3;
				Out_reg4 <= In_reg4;
				Out_reg5 <= In_reg5;
				Out_reg6 <= In_reg6;
            end if;
        end if;
		
    end process;
   
end Behavioral;