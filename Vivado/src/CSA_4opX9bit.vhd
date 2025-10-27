library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity CSA_4opX9bit is
	port(
			In1,In2,In3,In4:in std_logic_vector(BusWidth downto 0);  --9 bit
			CumSum: out std_logic_vector(11 downto 0)
		);
end CSA_4opX9bit;

architecture Behavioral of CSA_4opX9bit is

	component FA_layer is
		generic(N: integer);
		port(
				A, B, C : in std_logic_vector(N-1 downto 0);
				VSP, VR : out std_logic_vector (N downto 0)
			);
	end component;
	
		component RCA_generic is
		generic(WidthRCA: integer);
		port(
				A,B:in std_logic_vector(WidthRCA-1 downto 0);
				Cin:in std_logic;
				S: out std_logic_vector(WidthRCA downto 0)
			);
	end component;
	
	signal VSP_10bit, VR_10bit, In4_ext: std_logic_vector(9 downto 0);
	signal VSP_11bit, VR_11bit: std_logic_vector(10 downto 0);

	begin
	
	mapFA_9bit: FA_layer generic map(N=>9) port map(In1,In2,In3,VSP_10bit,VR_10bit);
	
	In4_ext <= std_logic_vector(resize(signed(In4),In4_ext'length));
	
	mapFA_10bit: FA_layer generic map(N=>10) port map(VSP_10bit,VR_10bit,In4_ext,VSP_11bit,VR_11bit);
	
	RCA11bit: RCA_generic generic map(WidthRCA=>11) port map(VSP_11bit,VR_11bit,'0',CumSum);


end Behavioral;