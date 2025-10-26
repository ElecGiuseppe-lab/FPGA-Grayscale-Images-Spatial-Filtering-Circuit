library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity Spatial_Filtering_Circuit is
port(
		global_clk, global_rst, start: in std_logic;
		original_pixel, kernel_coeff: in std_logic_vector(7 downto 0);	
		unsatured_filtered_pixel: out std_logic_vector(23 downto 0);
		Read_enable, En_reg_image, En_reg_kc, En_Window, En_out_kc, data_valid_out, last_elaboration: out std_logic
	);
end Spatial_Filtering_Circuit;

architecture Behavioral of Spatial_Filtering_Circuit is

	component ImageCacheMemory is
		port(
				Clock, Reset, En_reg, En_Window: in std_logic;
				ReadEn: in std_logic;
				DataIn: in std_logic_vector(BusWidth-1 downto 0); 
				P00, P01, P02, P03, P04: out std_logic_vector(BusWidth-1 downto 0);
				P10, P11, P12, P13, P14: out std_logic_vector(BusWidth-1 downto 0);
				P20, P21, P22, P23, P24: out std_logic_vector(BusWidth-1 downto 0);
				P30, P31, P32, P33, P34: out std_logic_vector(BusWidth-1 downto 0);
				P40, P41, P42, P43, P44: out std_logic_vector(BusWidth-1 downto 0)
			);
	end component;
	
	component IsotropicKernelMemory is
		port(
				clk, rst, En_reg_kc, En_out: in std_logic;
				Data_in: in std_logic_vector(BusWidth-1 downto 0);
				kc_1, kc_2, kc_3, kc_4, kc_5, kc_6: out std_logic_vector(BusWidth-1 downto 0)
			);
	end component;	
	
	component ConvolutionModule is
		port(
				CLOCK, RESET: in std_logic;
				P00, P01, P02, P03, P04: in std_logic_vector(BusWidth downto 0);	--(0,0), (0,4), (4,0), (4,4)
				P10, P11, P12, P13, P14: in std_logic_vector(BusWidth downto 0);	--(0,2), (2,0), (2,4), (4,2)
				P20, P21, P23, P24: in std_logic_vector(BusWidth downto 0);		--(1,1), (1,3), (3,1), (3,3)
				P30, P31, P32, P33, P34: in std_logic_vector(BusWidth downto 0);	--(1,2), (2,1), (2,3), (3,2)
				P40, P41, P42, P43, P44: in std_logic_vector(BusWidth downto 0);	--(0,1), (0,3), (1,0), (1,4), (3,0), (3,4), (4,1), (4,3)
				P22: in std_logic_vector(BusWidth-1 downto 0);					--(2,2)
				
				kc_1: in std_logic_vector(7 downto 0);							--(0,0), (0,4), (4,0), (4,4)
				kc_2: in std_logic_vector(7 downto 0);							--(0,2), (2,0), (2,4), (4,2)
				kc_3: in std_logic_vector(7 downto 0);							--(1,1), (1,3), (3,1), (3,3)
				kc_4: in std_logic_vector(7 downto 0);							--(1,2), (2,1), (2,3), (3,2)
				kc_5: in std_logic_vector(7 downto 0);							--(0,1), (0,3), (1,0), (1,4), (3,0), (3,4), (4,1), (4,3)
				kc_6: in std_logic_vector(7 downto 0);							--(2,2)
				
				filtered_pixel: out std_logic_vector(23 downto 0)
			);
	end component;	
	
	component ControllerModule is
		port(
                CLK, RESET, START: in std_logic;
                READ_enable, En_reg_image, En_reg_kc, En_Window, En_out_kc, Data_valid_out, Last_elaboration : out std_logic
			);
	end component;	
	
	signal Read_enable_int, En_reg_image_int, En_reg_kc_int, En_Window_int, En_out_int: std_logic;
	signal P00_int, P01_int, P02_int, P03_int, P04_int: std_logic_vector(7 downto 0);
	
	signal P00_int_ext, P01_int_ext, P02_int_ext, P03_int_ext, P04_int_ext: std_logic_vector(8 downto 0);	
	signal P10_int, P11_int, P12_int, P13_int, P14_int: std_logic_vector(7 downto 0);
	
	signal P10_int_ext, P11_int_ext, P12_int_ext, P13_int_ext, P14_int_ext: std_logic_vector(8 downto 0);	
	signal P20_int, P21_int, P23_int, P24_int: std_logic_vector(7 downto 0);
	
	signal P20_int_ext, P21_int_ext, P23_int_ext, P24_int_ext: std_logic_vector(8 downto 0);	
	signal P30_int, P31_int, P32_int, P33_int, P34_int: std_logic_vector(7 downto 0);
	
	signal P30_int_ext, P31_int_ext, P32_int_ext, P33_int_ext, P34_int_ext: std_logic_vector(8 downto 0);
	signal P40_int, P41_int, P42_int, P43_int, P44_int: std_logic_vector(7 downto 0);
	
	signal P40_int_ext, P41_int_ext, P42_int_ext, P43_int_ext, P44_int_ext: std_logic_vector(8 downto 0);
	
	signal P22_int: std_logic_vector(7 downto 0);
	
	signal kc_1_int, kc_2_int, kc_3_int, kc_4_int, kc_5_int, kc_6_int: std_logic_vector(7 downto 0);
						
		begin
		
			P00_int_ext <= std_logic_vector(resize(unsigned(P00_int),P00_int_ext'length));
			P01_int_ext <= std_logic_vector(resize(unsigned(P01_int),P01_int_ext'length));
			P02_int_ext <= std_logic_vector(resize(unsigned(P02_int),P02_int_ext'length));
			P03_int_ext <= std_logic_vector(resize(unsigned(P03_int),P03_int_ext'length));
			P04_int_ext <= std_logic_vector(resize(unsigned(P04_int),P04_int_ext'length));
			
			P10_int_ext <= std_logic_vector(resize(unsigned(P10_int),P10_int_ext'length));
			P11_int_ext <= std_logic_vector(resize(unsigned(P11_int),P11_int_ext'length));
			P12_int_ext <= std_logic_vector(resize(unsigned(P12_int),P12_int_ext'length));
			P13_int_ext <= std_logic_vector(resize(unsigned(P13_int),P13_int_ext'length));
			P14_int_ext <= std_logic_vector(resize(unsigned(P14_int),P14_int_ext'length));

			P20_int_ext <= std_logic_vector(resize(unsigned(P20_int),P20_int_ext'length));
			P21_int_ext <= std_logic_vector(resize(unsigned(P21_int),P21_int_ext'length));
			P23_int_ext <= std_logic_vector(resize(unsigned(P23_int),P23_int_ext'length));
			P24_int_ext <= std_logic_vector(resize(unsigned(P24_int),P24_int_ext'length));
			
			P30_int_ext <= std_logic_vector(resize(unsigned(P30_int),P30_int_ext'length));
			P31_int_ext <= std_logic_vector(resize(unsigned(P31_int),P31_int_ext'length));
			P32_int_ext <= std_logic_vector(resize(unsigned(P32_int),P32_int_ext'length));
			P33_int_ext <= std_logic_vector(resize(unsigned(P33_int),P33_int_ext'length));
			P34_int_ext <= std_logic_vector(resize(unsigned(P34_int),P34_int_ext'length));
			
			P40_int_ext <= std_logic_vector(resize(unsigned(P40_int),P40_int_ext'length));
			P41_int_ext <= std_logic_vector(resize(unsigned(P41_int),P41_int_ext'length));
			P42_int_ext <= std_logic_vector(resize(unsigned(P42_int),P42_int_ext'length));
			P43_int_ext <= std_logic_vector(resize(unsigned(P43_int),P43_int_ext'length));
			P44_int_ext <= std_logic_vector(resize(unsigned(P44_int),P44_int_ext'length));			

			Image_Cache_memory: ImageCacheMemory port map	(
																global_clk,
																global_rst,
																En_reg_image_int,
																En_Window_int,
																Read_enable_int,
																original_pixel,
																P00_int, P01_int, P02_int, P03_int, P04_int,
																P10_int, P11_int, P12_int, P13_int, P14_int,
																P20_int, P21_int, P22_int, P23_int, P24_int,
																P30_int, P31_int, P32_int, P33_int, P34_int,
																P40_int, P41_int, P42_int, P43_int, P44_int
															);
														
			Isotropic_Kernel_memory: IsotropicKernelMemory port map	(
																		global_clk,
																		global_rst,
																		En_reg_kc_int,
																		En_out_int,
																		kernel_coeff,
																		kc_1_int, kc_2_int, kc_3_int, kc_4_int, kc_5_int, kc_6_int
																	);														
														
			Convolution_module: ConvolutionModule port map	(
																global_clk,
																global_rst,
																P00_int_ext, P01_int_ext, P02_int_ext, P03_int_ext, P04_int_ext,
																P10_int_ext, P11_int_ext, P12_int_ext, P13_int_ext, P14_int_ext,
																P20_int_ext, P21_int_ext, P23_int_ext, P24_int_ext,
																P30_int_ext, P31_int_ext, P32_int_ext, P33_int_ext, P34_int_ext,
																P40_int_ext, P41_int_ext, P42_int_ext, P43_int_ext, P44_int_ext,
																P22_int,
																kc_1_int, kc_2_int, kc_3_int, kc_4_int, kc_5_int, kc_6_int,
																unsatured_filtered_pixel
															);
															
			Controller_module: ControllerModule port map	(
																global_clk,
																global_rst,
																start,
                                                                Read_enable_int,
                                                                En_reg_image_int,
                                                                En_reg_kc_int,															
																En_Window_int,
																En_out_int,
																data_valid_out,
																last_elaboration																
															);
															
		    Read_enable <= Read_enable_int;
		    En_reg_image <= En_reg_image_int;
		    En_reg_kc <= En_reg_kc_int;
		    En_Window <= En_Window_int;
		    En_out_kc <= En_out_int;																					
												
end Behavioral;