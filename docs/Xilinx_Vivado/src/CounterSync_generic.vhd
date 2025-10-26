library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity CounterSync_generic is
    port(
			Clear, Clock, Enable: in std_logic;
			Q : out std_logic_vector(dim_count-1 downto 0)
		);     
end CounterSync_generic;


architecture Behavioral of CounterSync_generic is

	component FF_toggle is 
	   port(
				Clk, Clr, En, T: in std_logic;
				Q: out std_logic 
			);
	end component;
	
	signal Q_int,toggle: std_logic_vector(dim_count-1 downto 0);

	begin
	
		--creazione porte AND
		toggle(0) <= '1';
		toggle(1) <= Q_int(0);
		AND_gates_gen:    for i in 2 to dim_count-1 generate
		                      toggle(i) <= toggle(i-1) and Q_int(i-1);
		                  end generate;

		
		--creazione contatore sincrono
		FF_toggle_gen:	for i in 0 to dim_count-1 generate
							T_ff: FF_toggle port map(Clock,Clear,Enable,toggle(i),Q_int(i));
						end generate;

		Q <= Q_int;

end Behavioral;