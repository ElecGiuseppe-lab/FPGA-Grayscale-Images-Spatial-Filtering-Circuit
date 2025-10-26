-- Questo modulo effettua la somma dei pixel della finestra da processare sfruttando l'isotropicitá del filtro, ovvero, mettendo in evidenza
-- i coefficienti del Kernel che si ripetono a paritá di distanza dal centro. Ció consente di ridurre il carico computazionale del
-- convolutore (meno operazioni di prodotto)


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity Wrapper_PreAdders is
port(
		P00,P01,P02,P03,P04: in std_logic_vector(BusWidth downto 0);
		P10,P11,P12,P13,P14: in std_logic_vector(BusWidth downto 0);
		P20,P21,P23,P24: in std_logic_vector(BusWidth downto 0);
		P30,P31,P32,P33,P34: in std_logic_vector(BusWidth downto 0);
		P40,P41,P42,P43,P44: in std_logic_vector(BusWidth downto 0);
		CumSum1,CumSum2,CumSum3,CumSum4,CumSum5: out std_logic_vector(11 downto 0)
	);
end Wrapper_PreAdders;

architecture Behavioral of Wrapper_PreAdders is

	component CSA_4opX9bit is
		port(
				In1,In2,In3,In4:in std_logic_vector(BusWidth downto 0);
				CumSum: out std_logic_vector(11 downto 0)
			);
	end component;

	component CSA_8opX9bit is
		port( 
				In1,In2,In3,In4,In5,In6,In7,In8:in std_logic_vector(BusWidth downto 0);
				CumSum: out std_logic_vector(11 downto 0)
			);
	end component;

	begin
	
	PreAdder_4op_1: CSA_4opX9bit port map(P00,P04,P40,P44,CumSum1);
	
	PreAdder_4op_2: CSA_4opX9bit port map(P02,P20,P24,P42,CumSum2);
	
	PreAdder_4op_3: CSA_4opX9bit port map(P11,P13,P31,P33,CumSum3);
	
	PreAdder_4op_4: CSA_4opX9bit port map(P12,P21,P23,P32,CumSum4);
	
	PreAdder_8op_1: CSA_8opX9bit port map(P01,P03,P10,P14,P30,P34,P41,P43,CumSum5);

end Behavioral;