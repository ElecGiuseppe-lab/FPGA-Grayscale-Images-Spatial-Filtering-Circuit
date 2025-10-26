-- Questo modulo si occupa di effettuare il filtraggio (operazione MAC) del generico pixel dell'immagine originale

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.constants.all;


entity ConvolutionModule is
port(
		CLOCK, RESET: in std_logic;
		P00,P01,P02,P03,P04: in std_logic_vector(BusWidth downto 0);
		P10,P11,P12,P13,P14: in std_logic_vector(BusWidth downto 0);
		P20,P21,P23,P24: in std_logic_vector(BusWidth downto 0);
		P30,P31,P32,P33,P34: in std_logic_vector(BusWidth downto 0);
		P40,P41,P42,P43,P44: in std_logic_vector(BusWidth downto 0);
		P22: in std_logic_vector(BusWidth-1 downto 0);
		kc_1 : in std_logic_vector(7 downto 0); --(0,0), (0,4), (4,0), (4,4)
		kc_2 : in std_logic_vector(7 downto 0); --(0,2), (2,0), (2,4), (4,2)
		kc_3 : in std_logic_vector(7 downto 0); --(1,1), (1,3), (3,1), (3,3)
		kc_4 : in std_logic_vector(7 downto 0); --(1,2), (2,1), (2,3), (3,2)
		kc_5 : in std_logic_vector(7 downto 0); --(0,1), (0,3), (1,0), (1,4), (3,0), (3,4), (4,1), (4,3)
		kc_6 : in std_logic_vector(7 downto 0); --(2,2)		
		filtered_pixel: out std_logic_vector(23 downto 0)
	);
end ConvolutionModule;

architecture Behavioral of ConvolutionModule is

	component Wrapper_PreAdders is
		port(
				P00,P01,P02,P03,P04: in std_logic_vector(BusWidth downto 0);
				P10,P11,P12,P13,P14: in std_logic_vector(BusWidth downto 0);
				P20,P21,P23,P24: in std_logic_vector(BusWidth downto 0);
				P30,P31,P32,P33,P34: in std_logic_vector(BusWidth downto 0);
				P40,P41,P42,P43,P44: in std_logic_vector(BusWidth downto 0);
				CumSum1,CumSum2,CumSum3,CumSum4,CumSum5: out std_logic_vector(11 downto 0) --somma pixel accomunati allo stesso coefficiente del kernel
			);
	end component;
	
	component Pipeline_reg_ADDERtoMULT is
		port(
				Clk,Rst: in std_logic;
				In_reg1,In_reg2,In_reg3,In_reg4,In_reg5,In_reg6: in std_logic_vector(11 downto 0);
				Out_reg1,Out_reg2,Out_reg3,Out_reg4,Out_reg5,Out_reg6: out std_logic_vector(11 downto 0)
			);
	end component;	

	component Wrapper_Booth_mult is
		port( 
				data_1, data_2, data_3, data_4, data_5, data_6 : in std_logic_vector(11 downto 0);
				kc_1 : in std_logic_vector(7 downto 0);
				kc_2 : in std_logic_vector(7 downto 0);
				kc_3 : in std_logic_vector(7 downto 0);
				kc_4 : in std_logic_vector(7 downto 0);
				kc_5 : in std_logic_vector(7 downto 0);
				kc_6 : in std_logic_vector(7 downto 0);
				out_1, out_2, out_3, out_4, out_5, out_6 : out std_logic_vector(19 downto 0) --prodotto uscite pre-adders con il rispettivo coefficiente del kernel
			);
	end component;
	
	component Pipeline_reg_MULTtoADDER is
		port(
				Clk,Rst: in std_logic;
				In_reg1,In_reg2,In_reg3,In_reg4,In_reg5,In_reg6: in std_logic_vector(19 downto 0);
				Out_reg1,Out_reg2,Out_reg3,Out_reg4,Out_reg5,Out_reg6: out std_logic_vector(19 downto 0)
			);
	end component;		
	
	component Final_CSA_6opX20bit is
		port( 
				Prod_1,Prod_2,Prod_3,Prod_4,Prod_5,Prod_6:in std_logic_vector(19 downto 0); --somma dei prodotti per ottenere il pixel filtrato
				Cum_Sum: out std_logic_vector(23 downto 0)
			);
	end component;
	
	component Final_pipeline_reg is
		port(
				Clk, Rst : in std_logic;
				D : in std_logic_vector(23 downto 0);
				Q : out std_logic_vector(23 downto 0)
			);
	end component;		
	
	signal CumSum1_int, CumSum2_int, CumSum3_int, CumSum4_int, CumSum5_int,P22_ext: std_logic_vector(11 downto 0);
	
	signal CumSum_reg1, CumSum_reg2, CumSum_reg3, CumSum_reg4, CumSum_reg5, P22_ext_reg6: std_logic_vector(11 downto 0);
	
	signal Prod1_int, Prod2_int, Prod3_int, Prod4_int, Prod5_int, Prod6_int: std_logic_vector(19 downto 0);
	
	signal Prod_reg1, Prod_reg2, Prod_reg3, Prod_reg4, Prod_reg5, Prod_reg6: std_logic_vector(19 downto 0);
	
	signal filtered_pixel_int: std_logic_vector(23 downto 0);

		begin
		
			P22_ext <= std_logic_vector(resize(unsigned(P22),P22_ext'length));
			
			PreAdders_module:	Wrapper_PreAdders port map	(		
																P00,P01,P02,P03,P04,
																P10,P11,P12,P13,P14,
																P20,P21,P23,P24,
																P30,P31,P32,P33,P34,
																P40,P41,P42,P43,P44,
																CumSum1_int,CumSum2_int,CumSum3_int,CumSum4_int,CumSum5_int
															);
															
			First_pipeline_module:	Pipeline_reg_ADDERtoMULT port map	(
																			CLOCK,RESET,
																			CumSum1_int,CumSum2_int,CumSum3_int,CumSum4_int,CumSum5_int,P22_ext,
																			CumSum_reg1,CumSum_reg2,CumSum_reg3,CumSum_reg4,CumSum_reg5,P22_ext_reg6
																		);														
														
			Multipliers_module:	Wrapper_Booth_mult port map	(
																CumSum_reg1,CumSum_reg2,CumSum_reg3,CumSum_reg4,CumSum_reg5,P22_ext_reg6,
																kc_1,kc_2,kc_3,kc_4,kc_5,kc_6,
																Prod1_int,Prod2_int,Prod3_int,Prod4_int,Prod5_int,Prod6_int
															);
															
			Second_pipeline_module:	Pipeline_reg_MULTtoADDER	port map	(
																				CLOCK,RESET,
																				Prod1_int,Prod2_int,Prod3_int,Prod4_int,Prod5_int,Prod6_int,
																				Prod_reg1,Prod_reg2,Prod_reg3,Prod_reg4,Prod_reg5,Prod_reg6
																);															
													
			FinalAdder_module:	Final_CSA_6opX20bit	port map	(
																	Prod_reg1,Prod_reg2,Prod_reg3,Prod_reg4,Prod_reg5,Prod_reg6,
																	filtered_pixel_int
																);	

			Third_pipeline_reg:	Final_pipeline_reg	port map	(
																	CLOCK,RESET,
																	filtered_pixel_int,
																	filtered_pixel
																);																		
												
end Behavioral;