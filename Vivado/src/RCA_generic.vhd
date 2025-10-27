library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity RCA_generic is
	generic (WidthRCA: integer:=12);	--lunghezza modificabile a seconda dell'applicazione
	port(
			A,B:in std_logic_vector(WidthRCA-1 downto 0);
			Cin:in std_logic;
			S: out std_logic_vector(WidthRCA downto 0)
		);
end RCA_generic;

architecture Behavioral of RCA_generic is


	signal carry_int: std_logic_vector(WidthRCA downto 0);

	component FA_RCA is
		port(
				A,B,Cin:in std_logic;
				S,Cout:out std_logic
			);
	end component;


	begin

	carry_int(0)<=Cin;

	for_gen:	for i in 0 to WidthRCA generate
					if_gen:	if (i < WidthRCA) generate
						MAPfa:	FA_RCA port map(A(i),B(i),carry_int(i),S(i),carry_int(i+1));
					end generate if_gen;
					--Full adder aggiuntivo per eseguire estensione con segno
					if_gen_MSB: if (i = WidthRCA) generate
						FA_MSB: FA_RCA port map(A(i-1),B(i-1),carry_int(i),S(i),open);
					end generate if_gen_MSB;
				end generate for_gen;
				

end Behavioral;