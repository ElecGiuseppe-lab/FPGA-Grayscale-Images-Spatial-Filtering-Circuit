library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity Final_CSA_6opX20bit is
	port(
			Prod_1,Prod_2,Prod_3,Prod_4,Prod_5,Prod_6:in std_logic_vector(19 downto 0);
			Cum_Sum: out std_logic_vector(23 downto 0)
		);
end Final_CSA_6opX20bit;

architecture Behavioral of Final_CSA_6opX20bit is

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
	
	signal VSP1_21bit, VR1_21bit, VSP2_21bit, VR2_21bit: std_logic_vector(20 downto 0);
	signal VSP_22bit, VR_22bit, VSP2_21bit_ext: std_logic_vector(21 downto 0);
	signal VSP_23bit, VR_23bit: std_logic_vector(22 downto 0);

	begin
	
	mapFA1_20bit: FA_layer generic map(N=>20) port map(Prod_1,Prod_2,Prod_3,VSP1_21bit,VR1_21bit);
	
	mapFA2_20bit: FA_layer generic map(N=>20) port map(Prod_4,Prod_5,Prod_6,VSP2_21bit,VR2_21bit);
	
	mapFA_21bit: FA_layer generic map(N=>21) port map(VSP1_21bit,VR1_21bit,VR2_21bit,VSP_22bit,VR_22bit);
	
	VSP2_21bit_ext <= std_logic_vector(resize(signed(VSP2_21bit),VSP2_21bit_ext'length));
	
	mapFA_22bit: FA_layer generic map(N=>22) port map(VSP_22bit,VR_22bit,VSP2_21bit_ext,VSP_23bit,VR_23bit);
	
	RCA_23bit: RCA_generic generic map(WidthRCA=>23) port map(VSP_23bit,VR_23bit,'0',Cum_Sum);

end Behavioral;