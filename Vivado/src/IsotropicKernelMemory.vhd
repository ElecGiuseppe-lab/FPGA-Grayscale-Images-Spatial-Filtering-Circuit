--Questo modulo riceve in ingresso i coefficienti di un filtro isotropico (i coefficienti equidistanti dal centro hanno lo stesso valore)
--L'isotropicitá consente di descrivere il Kernel con un minor numero di coefficienti tenendo conto della loro ripetizione

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity IsotropicKernelMemory is
	Port(
			clk, rst, En_reg_kc, En_out: in std_logic;
			Data_in: in std_logic_vector(BusWidth-1 downto 0);
			kc_1: out std_logic_vector(BusWidth-1 downto 0);	--(0,0), (0,4), (4,0), (4,4)
			kc_2: out std_logic_vector(BusWidth-1 downto 0);	--(0,2), (2,0), (2,4), (4,2)
			kc_3: out std_logic_vector(BusWidth-1 downto 0);	--(1,1), (1,3), (3,1), (3,3)
			kc_4: out std_logic_vector(BusWidth-1 downto 0);	--(1,2), (2,1), (2,3), (3,2)
			kc_5: out std_logic_vector(BusWidth-1 downto 0);	--(0,1), (0,3), (1,0), (1,4), (3,0), (3,4), (4,1), (4,3)
			kc_6: out std_logic_vector(BusWidth-1 downto 0)		--(2,2)	
		);    
end IsotropicKernelMemory;

architecture Behavioral of IsotropicKernelMemory is

    signal reg_array: depth_buffer1;

	begin

		process(clk)

		begin

			if(rising_edge(clk)) then
				if( rst = '1')then
					resetAll: 	for j in 0 to (RowKernel*ColKernel-1) loop  
									reg_array(j) <= (others=>'0');
								end loop; 
				elsif( En_reg_kc = '1') then
					reg_array(0) <= Data_in;
					gen_reg: 	for j in 1 to (RowKernel*ColKernel-1) loop  
									reg_array(j) <= reg_array(j-1);
								end loop; 
				end if;
			end if;
			
		end process;

		--Estrapolo i coefficienti utili ai fini dell'operazione MAC
		kc_1 <= reg_array(24) when En_out = '1' else (others=>'0');
		kc_2 <= reg_array(22) when En_out = '1' else (others=>'0');
		kc_3 <= reg_array(18) when En_out = '1' else (others=>'0');	
		kc_4 <= reg_array(17) when En_out = '1' else (others=>'0');	
		kc_5 <= reg_array(23) when En_out = '1' else (others=>'0');
		kc_6 <= reg_array(12) when En_out = '1' else (others=>'0');	       
   
end Behavioral;