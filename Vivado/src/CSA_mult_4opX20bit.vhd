library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CSA_mult_4opX20bit is
	port(
			PP1, PP2, PP3, PP4 : in std_logic_vector(19 downto 0);
			Cum_sum : out std_logic_vector(22 downto 0) 
		);
end CSA_mult_4opX20bit;


architecture Behavioral of CSA_mult_4opX20bit is
	
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

	signal VR_21bit, VSP_21bit, PP4_ext: std_logic_vector(20 downto 0);
	signal VR_22bit, VSP_22bit: std_logic_vector(21 downto 0);

	begin
	
		mapFA_20bit: FA_layer generic map(N=>20) port map(PP1,PP2,PP3,VSP_21bit,VR_21bit);
		
		PP4_ext <= std_logic_vector(resize(signed(PP4),PP4_ext'length));
		
		mapFA_21bit: FA_layer generic map(N=>21) port map(VSP_21bit,VR_21bit,PP4_ext,VSP_22bit,VR_22bit);
		
		RCA22bit_mult: RCA_generic generic map(WidthRCA=>22) port map(VSP_22bit,VR_22bit,'0',Cum_sum);

end Behavioral;
