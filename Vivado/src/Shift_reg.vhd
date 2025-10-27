-- Registro a scorrimento che memorizza i pixel associati alla generica finestra di convoluzione

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity Shift_reg is

  Port (
		clk,rst,en: in std_logic;
        Data_in: in std_logic_vector(BusWidth-1 downto 0);
        Dout0,Dout1,Dout2,Dout3,Dout4: out std_logic_vector(BusWidth-1 downto 0)
		);    
end Shift_reg;

architecture Behavioral of Shift_reg is

signal reg_array : depth_Shift_reg;

begin

process(clk)

begin

	if(rising_edge(clk)) then
		if( rst = '1')then
			resetAll: 	for j in 0 to (ColKernel-1) loop  
							reg_array(j) <= (others=>'0');
						end loop; 
		elsif( en = '1') then
			reg_array(0) <= Data_in;
			gen_reg: 	for j in 1 to (ColKernel-1) loop  
							reg_array(j) <= reg_array(j-1);
						end loop; 
		end if;
	end if;
	
end process;

Dout0 <= reg_array(0);
Dout1 <= reg_array(1);
Dout2 <= reg_array(2);
Dout3 <= reg_array(3);
Dout4 <= reg_array(4);        
   
end Behavioral;