library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Wrapper_Booth_mult is
	port(
			data_1, data_2, data_3, data_4, data_5, data_6 : in std_logic_vector(11 downto 0);
			kc_1 : in std_logic_vector(7 downto 0); --(0,0), (0,4), (4,0), (4,4)
			kc_2 : in std_logic_vector(7 downto 0); --(0,2), (2,0), (2,4), (4,2)
			kc_3 : in std_logic_vector(7 downto 0); --(1,1), (1,3), (3,1), (3,3)
			kc_4 : in std_logic_vector(7 downto 0); --(1,2), (2,1), (2,3), (3,2)
			kc_5 : in std_logic_vector(7 downto 0); --(0,1), (0,3), (1,0), (1,4), (3,0), (3,4), (4,1), (4,3)
			kc_6 : in std_logic_vector(7 downto 0); --(2,2)
			out_1, out_2, out_3, out_4, out_5, out_6 : out std_logic_vector(19 downto 0)
		);
end Wrapper_Booth_mult;


architecture Behavioral of Wrapper_Booth_mult is
	
	component Booth_mult is
		port(
				A : in std_logic_vector(11 downto 0);
				B : in std_logic_vector (7 downto 0);
				Ris_mult : out std_logic_vector (19 downto 0) 
			); 
	end component;
	
	
	begin
		
		Multiplier_1: Booth_mult port map(A => data_1, B => kc_1, Ris_mult => out_1);

		Multiplier_2: Booth_mult port map(A => data_2, B => kc_2, Ris_mult => out_2);

		Multiplier_3: Booth_mult port map(A => data_3, B => kc_3, Ris_mult => out_3);

		Multiplier_4: Booth_mult port map(A => data_4, B => kc_4, Ris_mult => out_4);

		Multiplier_5: Booth_mult port map(A => data_5, B => kc_5, Ris_mult => out_5);

		Multiplier_6: Booth_mult port map(A => data_6, B => kc_6, Ris_mult => out_6);
		

end Behavioral;
