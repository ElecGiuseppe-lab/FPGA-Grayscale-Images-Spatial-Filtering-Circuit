library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_textio.all;
library STD;
use STD.textio.all;
use work.constants.all;

use IEEE.NUMERIC_STD.ALL;


entity SpatialFilteringCircuit_tb is

end SpatialFilteringCircuit_tb;



architecture Behavioral of SpatialFilteringCircuit_tb is

	component Spatial_Filtering_Circuit is
		port(
                global_clk, global_rst, start: in std_logic;
                original_pixel, kernel_coeff: in std_logic_vector(7 downto 0);	
                unsatured_filtered_pixel: out std_logic_vector(23 downto 0);
                Read_enable, En_reg_image, En_reg_kc, En_Window, En_out_kc, data_valid_out, last_elaboration: out std_logic
			);
	end component;


	signal global_clk, global_rst, start: std_logic := '0';
	signal Read_enable, En_reg_image, En_reg_kc, En_Window, En_out_kc, data_valid_out, last_elaboration: std_logic := '0';
	signal original_pixel, kernel_coeff: std_logic_vector(7 downto 0);
	signal unsatured_filtered_pixel: std_logic_vector(23 downto 0);
	signal writeOutput: integer := 0;
	
	constant clk_period : time := 8.4 ns;
	



	begin
	
	
		UUT: Spatial_Filtering_Circuit port map(
													global_clk, global_rst, start,
													original_pixel, kernel_coeff,
													unsatured_filtered_pixel, 
													Read_enable, En_reg_image, En_reg_kc, En_Window, En_out_kc, data_valid_out, last_elaboration
												);

		-- Clock generation process
		clock:	process
					begin
						global_clk <= '1';
						wait for clk_period/2;
						global_clk <= '0';
						wait for clk_period/2;
				end process;
				
		-- Stimulus process
		reset:	process
					begin
					    wait for 6.5*clk_period;
					    wait for 1 ns;
						global_rst <= '1';
						wait for clk_period;
						global_rst <= '0';
						wait;
				end process;
				
		start_process:	process
							begin
								wait for 12.5*clk_period;
								wait for 1 ns;
								start <= '1';
								wait for clk_period;
								wait until global_clk = '1';
								start <= '0';
								wait;
						end process;						   
						
		read_to_file:	process
		
						variable rdline : line;
						variable tmp1 : integer;
						file vector_file : text;
								
							begin
			   
								wait until start = '1';
								wait for clk_period;
			   
								file_open(vector_file,"C:\Users\Giuseppe Pirilli\Desktop\Progetto_circuito_filtraggio_spaziale\Vivado\text_images\books64_grayscale.txt");
						
								while not endfile( vector_file ) loop 
								   readline( vector_file, rdline );
								   read( rdline, tmp1);
								   original_pixel <= std_logic_vector(to_unsigned(tmp1,original_pixel'length));
								   wait for clk_period;
								end loop;
								file_close( vector_file );								
								wait;								
							   
						end process;

		read_to_file_kc:	process
		
							variable rdline_kc : line;
							variable tmp1_kc : integer ;
							file vector_file_kc : text;
									
								begin
				   
									wait until start = '1';
									wait for clk_period;
				   
									file_open(vector_file_kc,"C:\Users\Giuseppe Pirilli\Desktop\Progetto_circuito_filtraggio_spaziale\Vivado\kernel_coefficients\filtro_laplaciano1.txt");
							
									while not endfile( vector_file_kc ) loop 
									   readline( vector_file_kc, rdline_kc );
									   read( rdline_kc, tmp1_kc);
									   kernel_coeff <= std_logic_vector(to_signed(tmp1_kc,kernel_coeff'length));
									   wait for clk_period;
									end loop;
									file_close( vector_file_kc );								
									wait;								
							   
							end process;						
							
		write_to_file:	process
						
						variable line_file: line;
						file output_file: text;
						
							begin
							
								wait until data_valid_out = '1';
								wait until global_clk = '1';
												
								file_open(output_file, "C:\Users\Giuseppe Pirilli\Desktop\Progetto_circuito_filtraggio_spaziale\Vivado\text_filtered_images\filtered_books64_grayscale.txt", write_mode);
						
								for i in 1 to (RowImage*ColImage+1) loop
								    writeOutput <= to_integer( signed( unsatured_filtered_pixel ) );
									write(line_file, writeOutput);
									writeline(output_file, line_file);
									wait for clk_period;
								end loop;
								
								file_close(output_file);
								wait;
								
						end process;									
		
end Behavioral;