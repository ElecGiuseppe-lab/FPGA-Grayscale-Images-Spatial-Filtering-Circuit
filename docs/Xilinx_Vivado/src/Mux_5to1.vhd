-- MUX che ha ai suoi ingressi tutti i possibili valori (giá rappresentati su (n+2)-bit) che il generico prodotto parziale puó assumere

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Mux_5to1 is
	port(
			sel: in std_logic_vector(2 downto 0);					--selettore mux rappresentato dal codice ottenuto dall'encoder
			ExA, DA, MA, MDA : in std_logic_vector(13 downto 0);	--possibili prodotti parziali
			PP: out std_logic_vector(13 downto 0)					--prodotto parziale
		);
end Mux_5to1;

architecture behavioural of Mux_5to1 is

	begin
		-- selezione del prodotto parziale in funzione della codifica della generica terna (a ciascuna terna viene assegnato implicitamente il rispettivo digit di codifica)
		process(sel,ExA, DA, MA, MDA)
			begin
				case sel is
					when "000"	=>
						PP <= (others =>'0');	--0 (digit codificato pari a 1)
					when "001"	=>
						PP <= ExA;				--1A (digit codificato pari a 1)
					when "010" 	=>
						PP <= DA;				--2A (digit codificato pari a 2)
					when "110" 	=>
						PP <= MDA;				-- -2A (digit codificato pari a -2)
					when "101" 	=>
						PP <= MA;				-- -1A (digit codificato pari a -1)
					when others =>
						PP <= (others => 'X');		
				end case;
		end process;	
	
end behavioural;