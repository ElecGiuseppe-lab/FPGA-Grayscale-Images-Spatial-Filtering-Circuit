library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity FSM is
    port(
			CLK, RST, Start: in std_logic;
			Count: in std_logic_vector(dim_count-1 downto 0);
			Read_en, En_reg_image, En_reg_kc, En_Window, En_out_kc, Count_en, data_valid_out, last_elaboration, clear_count: out std_logic 
		);
end FSM;


architecture Moore_FSM of FSM is

	type FSM_state is (IDLE, S1, S2, S3, S4, S5, S6);
	signal present_state: FSM_state;
	signal temp_output: std_logic_vector(8 downto 0) := (others => '0');

	begin
	
		--si occupa di aggiornare lo stato
		update_state:	process(CLK) is
						begin
							if(rising_edge(CLK)) then
								if(RST = '1') then
									present_state <= IDLE;		
								else
									case present_state is
										when IDLE =>
											if(Start = '1') then
												present_state <= S1;		
											else
												present_state <= IDLE;
											end if;
											
										when S1 =>
											if(Count = "0000000011000") then --24
												present_state <= S2;		
											elsif( RST = '1' ) then
												present_state <= IDLE;
											end if;											
											
										when S2 =>
											if(Count = "0000010000010") then --130
												present_state <= S3;		
											elsif( RST = '1' ) then
												present_state <= IDLE;
											end if;
											
										when S3 =>
											if(Count = "0000010000101") then --133
												present_state <= S4;		
											elsif( RST = '1' ) then
												present_state <= IDLE;
											end if;			
											
										when S4 =>
											if(Count = "0111111111111") then --4095
												present_state <= S5;		
											elsif( RST = '1' ) then
												present_state <= IDLE;
											end if;																	
																			
										when S5 =>
											if(Count = "1000010000010") then --4226
												present_state <= S6;		
											elsif( RST = '1' ) then
												present_state <= IDLE;
											end if;	
																				
										when S6 =>
											if(Count = "1000010000101" or RST = '1') then --4229
												present_state <= IDLE;									
											end if;
										
										when others =>
												present_state <= IDLE;													
											
									end case;
								end if;
							end if;
					end process;
					
		--si occupa di aggiornare le uscite in funzione dello stato corrente
		outputs:	process(present_state)
						begin
							case present_state is
								-- Il circuito viene inizializzato e rimane in fase di stand-by, in attesa di processare i dati
								when IDLE =>
								temp_output <= "100000000";
								
								-- Inizia la lettura sia dei pixels da processare che dei coefficienti del kernel
								when S1 =>
								temp_output <= "000100111";
								
								-- Termina la lettura dei coefficienti del kernel
								when S2 =>
								temp_output <= "000110011";	
								
								-- In contemporanea, vengono letti nuovi pixels e processati quelli precedentemente memorizzati								
								when S3 =>
								temp_output <= "000111011";	
								
								-- Il circuito comincia a restituire risultati validi dall'elaborazione								
								when S4 =>
								temp_output <= "001111011";	
								
								-- Termina la lettura dei pixels
								when S5 =>
								temp_output <= "001111010";																																							
								
								-- Elaborazione dell'ultimo pixel
								when S6 =>
								temp_output <= "011110000";
								
								--default case per garantire che non ci siano stati indefiniti (inizializzazione del circuito)
								when others =>
								temp_output <= "100000000";
																
							end case;
					end process;
					
        --assegnazione della variabile temp_output alle uscite
        Read_en <= temp_output(0);
        En_reg_image <= temp_output(1);
        En_reg_kc <= temp_output(2);
        En_Window <= temp_output(3);
		En_out_kc <= temp_output(4);
        Count_en <= temp_output(5);
        data_valid_out <= temp_output(6);
        last_elaboration <= temp_output(7);
        clear_count <= temp_output(8);
        
    
end Moore_FSM;





