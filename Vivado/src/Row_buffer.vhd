-- Si tratta di un registro a scorrimento impiegato per memorizzare i pixel di riga precedentemente letti,
--necessari per la corretta generazione della finestra di convoluzione da processare

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity Row_buffer is

  Port (
		clk,rst,en: in std_logic;
        Din: in std_logic_vector(BusWidth-1 downto 0);
        Dout: out std_logic_vector(BusWidth-1 downto 0)
		);    
end Row_buffer;

architecture Behavioral of Row_buffer is

signal reg_array : depth_buffer2;

begin

process(clk)

begin

	if(rising_edge(clk)) then
		if( rst = '1')then
			resetAll: 	for j in 0 to RowImage-(RowKernel+1) loop  
							reg_array(j) <= (others=>'0');
						end loop; 
		elsif( en = '1') then
			reg_array(0) <= Din;
			gen_reg_array: 	for j in 1 to RowImage-(RowKernel+1) loop  
							reg_array(j) <= reg_array(j-1);
						end loop; 
		end if;
	end if;
	
end process;

Dout <= reg_array(RowImage-(RowKernel+1));        
   
end Behavioral;