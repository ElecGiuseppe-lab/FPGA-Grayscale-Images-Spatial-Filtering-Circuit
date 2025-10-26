library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Booth_mult is
	port(
			A : in std_logic_vector(11 downto 0);				--moltiplicando
			B : in std_logic_vector (7 downto 0);				--moltiplicatore
			Ris_mult : out std_logic_vector (19 downto 0)
		); 
end Booth_mult;

architecture Behavioral of Booth_mult is
	
	component Booth_encoder is
		port(
				B2, B1, B0: in std_logic;						
				control_bits : out std_logic_vector(2 downto 0)	
			);
	end component;

	component Mux_5to1 is
		port(
				sel: in std_logic_vector(2 downto 0);					
				ExA, DA, MA, MDA : in std_logic_vector(13 downto 0);
				PP: out std_logic_vector(13 downto 0)	 
			); 
	end component;
	
	component CSA_mult_4opX20bit is
		port(
				PP1, PP2, PP3, PP4 : in std_logic_vector(19 downto 0); 
				Cum_sum : out std_logic_vector(22 downto 0)
			); 
	end component;
	
	component RCA_generic is
	generic (WidthRCA: integer);
		port(
			A,B:in std_logic_vector(WidthRCA-1 downto 0);
			Cin:in std_logic;
			S: out std_logic_vector(WidthRCA downto 0)
			); 
	end component;	

	signal ExA, DA, MA, MDA: std_logic_vector(13 downto 0);
	signal not_A: std_logic_vector(11 downto 0);
	signal pp_MA: std_logic_vector(12 downto 0);
	constant one12: std_logic_vector(11 downto 0) := "000000000001";			--valore unitario a 12 bits
	type cod_array is array (0 to 3) of std_logic_vector(2 downto 0);			
	type PP_array is array (0 to 3) of std_logic_vector(13 downto 0); 			
	signal cod_terna: cod_array; 												--array contenente le terne codificate
	signal partial_prod: PP_array;												--array dei prodotti parziali
	signal PP1_int, PP2_int, PP3_int, PP4_int: std_logic_vector(19 downto 0); 
	signal CumSum_int: std_logic_vector(22 downto 0);

	
	begin
	
		not_A <= not(A);
		ExA <= (A(11)&A(11)&A);			-- (1A), estensione con segno di A
		DA <= (ExA(12 downto 0)&'0');	-- (2A), estensione e shift a sinistra di A
		RCA_pp_MA: RCA_generic generic map(WidthRCA=>12) port map(A=>not_A, B=>one12, Cin=>'0', S=>pp_MA);	-- (-A), per complemento a 2 di A
		MA <= (pp_MA(12)&pp_MA);		-- (-1A), estensione con segno di -A
		MDA <= (MA(12 downto 0)&'0');	-- (-2A), estensione e shift a sinistra di -A

		for_gen:  for i in 0 to 3 generate
						
							if_Gen_1:	if (i = 0) generate
											Booth_enc:	Booth_encoder port map(B2 => B(i+1), B1 => B(i), B0 => '0', control_bits => cod_terna(i));
										end generate if_Gen_1;
							
							if_Gen_2:	if (i > 0) generate
											Booth_enc:	Booth_encoder port map(B2 => B(i*2+1), B1 => B(i*2), B0 => B(i*2-1), control_bits => cod_terna(i));
										end generate if_Gen_2;
							
							Mux:	Mux_5to1 port map (sel => cod_terna(i), ExA => ExA, DA => DA, MA => MA, MDA => MDA, PP => partial_prod(i));
						
						end generate for_gen;                  

		--allineamento dei prodotti parziali in uscita dai MUX (shift ed estensione consegno)
		PP1_int <= (19 downto 14 => partial_prod(0)(13)) & partial_prod(0);
		PP2_int <= (19 downto 16 => partial_prod(1)(13))& partial_prod(1) & "00";
		PP3_int <= (19 downto 18 => partial_prod(2)(13))&partial_prod(2)&"0000";
		PP4_int <= partial_prod(3)&"000000";
		
		Adder_mult_4op: CSA_mult_4opX20bit port map(PP1 => PP1_int, PP2 => PP2_int, PP3 => PP3_int, PP4 => PP4_int, Cum_sum => CumSum_int);

		Ris_mult <= CumSum_int(19 downto 0);
		
end Behavioral;