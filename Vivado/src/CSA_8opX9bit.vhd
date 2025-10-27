library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity CSA_8opX9bit is
	port(
			In1,In2,In3,In4,In5,In6,In7,In8:in std_logic_vector(BusWidth downto 0);		--9 bit
			CumSum: out std_logic_vector(11 downto 0)
		);
end CSA_8opX9bit;

architecture Behavioral of CSA_8opX9bit is


	signal VSP1_10bit, VR1_10bit, VSP2_10bit, VR2_10bit, In7_ext, In8_ext: std_logic_vector(9 downto 0);
	signal VSP1_11bit, VR1_11bit, VSP2_11bit, VR2_11bit: std_logic_vector(10 downto 0);
	signal VSP_12bit, VR_12bit, VSP2_11bit_ext: std_logic_vector(11 downto 0);
	signal VSP_13bit, VR_13bit: std_logic_vector(12 downto 0);
	signal S_int: std_logic_vector(13 downto 0);

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

	begin
	
	mapFA1_9bit: FA_layer generic map(N=>9) port map(In1,In2,In3,VSP1_10bit,VR1_10bit);
	mapFA2_9bit: FA_layer generic map(N=>9) port map(In4,In5,In6,VSP2_10bit,VR2_10bit);
	
	In7_ext <= std_logic_vector(resize(signed(In7),In7_ext'length));
	In8_ext <= std_logic_vector(resize(signed(In8),In8_ext'length));
	
	mapFA1_10bit: FA_layer generic map(N=>10) port map(VSP1_10bit,VR1_10bit,VR2_10bit,VSP1_11bit,VR1_11bit);
	mapFA2_10bit: FA_layer generic map(N=>10) port map(VSP2_10bit,In7_ext,In8_ext,VSP2_11bit,VR2_11bit);
	
	mapFA_11bit: FA_layer generic map(N=>11) port map(VSP1_11bit,VR1_11bit,VR2_11bit,VSP_12bit,VR_12bit);
	
	VSP2_11bit_ext <= std_logic_vector(resize(signed(VSP2_11bit),VSP2_11bit_ext'length));
	
	mapFA_12bit: FA_layer generic map(N=>12) port map(VSP_12bit,VR_12bit,VSP2_11bit_ext,VSP_13bit,VR_13bit);
	
	RCA13bit: RCA_generic generic map(WidthRCA=>13) port map(VSP_13bit,VR_13bit,'0',S_int);
	
	CumSum <= S_int(11 downto 0);


end Behavioral;