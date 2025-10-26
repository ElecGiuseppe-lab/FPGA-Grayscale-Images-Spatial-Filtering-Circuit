--Booth encoder impiegato per codificare le terne di bits del moltiplicatore in modo da ottimizzare il MUX impiegato
--per la selezione del rispettivo prodotto parziale (riduzione del fan-in, ovvero, utilizzo un MUX5:1 anzicché un MUX8:1)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Booth_encoder is
    port(
			B2, B1, B0: in std_logic;							--terna di bits
			control_bits : out std_logic_vector(2 downto 0)		--codifica associato alla terna di bits
		);
end Booth_encoder;

architecture Behavioral of Booth_encoder is

begin

    --codifico la terna utilizzando la rappresentazione modulo e segno
	control_bits(2)<= (B1 nand B0) and B2;
    control_bits(1)<= (B2 xor B1) and (not(B1 xor B0));
    control_bits(0)<= (B1 xor B0);
	
end Behavioral;