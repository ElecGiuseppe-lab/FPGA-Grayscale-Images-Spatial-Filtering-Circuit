library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity FA_layer is
	generic(N: integer:=8);									--lunghezza modificabile a seconda dell'applicazione
	port(
			A, B, C : in std_logic_vector(N-1 downto 0);
			VSP, VR : out std_logic_vector (N downto 0) 	--vettore somme parziali e vettore dei riporti
		);
end FA_layer;

architecture Behavioral of FA_layer is


	signal VSP_int, VR_int: std_logic_vector(N-1 downto 0);

	component FA_CSA
		port(
				A, B, Cin : in std_logic;
				Sum, Cout: out std_logic
			);
	end component;
	 
	begin

		for_gen:	for i in 0 to (N-1) generate
						FullAdder: FA_CSA port map(A(i), B(i), C(i), VSP_int(i), VR_int(i));
					end generate for_gen;

	VSP <= std_logic_vector(resize(signed(VSP_int), VSP'length));					--estensione con segno della somma parziale		
	--VSP <= (VSP_int(N-1) & VSP_int);
	VR <= (VR_int & '0');															-- shift a sinistra del vettore dei riporti
	--VR <= std_logic_vector(shift_left(resize(signed(VR_int),VR'length),1));
	

end Behavioral;