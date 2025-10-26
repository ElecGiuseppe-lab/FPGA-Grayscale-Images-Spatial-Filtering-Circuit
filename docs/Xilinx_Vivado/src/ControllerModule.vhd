library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity ControllerModule is
    port(
			CLK, RESET, START: in std_logic;
			READ_enable, En_reg_image, En_reg_kc, En_Window, En_out_kc, Data_valid_out, Last_elaboration : out std_logic
		);
end ControllerModule;

architecture Behavioral of ControllerModule is

	component CounterSync_generic is  
		port(
				Clear, Clock, Enable: in std_logic;
				Q: out std_logic_vector(dim_count-1 downto 0)
			);
	end component;

	component FSM is
		port(
                CLK, RST, Start: in std_logic;
                Count: in std_logic_vector(dim_count-1 downto 0);
                Read_en, En_reg_image, En_reg_kc, En_Window, En_out_kc, Count_en, data_valid_out, last_elaboration, clear_count: out std_logic 
			);
	end component;

	signal Count_en_int, Clear_count_int: std_logic;
	signal count: std_logic_vector(dim_count-1 downto 0);

		begin

			Counter: CounterSync_generic port map(Clear_count_int, CLK, Count_en_int, count);
																		
			Finite_state_machine: FSM port map(
													CLK,
													RESET, 
													START,														
													count,
													READ_enable,
													En_reg_image,
													En_reg_kc, 
													En_Window,
													En_out_kc,
													Count_en_int,
													Data_valid_out, 
													Last_elaboration, 
													Clear_count_int
												);


end Behavioral;