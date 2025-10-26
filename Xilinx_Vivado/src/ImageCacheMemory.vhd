-- Estraiamo la finestra di convoluzione associa al pixel da elaborare, ovvero, l'intorno del generico pixel da filtrare
-- É stato scelto un anchor point centrale per determinare la finestra di convoluzione


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants.all;


entity ImageCacheMemory is
	port(
			Clock,Reset,En_reg,En_Window: in std_logic;
			ReadEn: in std_logic;
			DataIn: in std_logic_vector(BusWidth-1 downto 0); 
			P00,P01,P02,P03,P04: out std_logic_vector(BusWidth-1 downto 0);
			P10,P11,P12,P13,P14: out std_logic_vector(BusWidth-1 downto 0);
			P20,P21,P22,P23,P24: out std_logic_vector(BusWidth-1 downto 0);
			P30,P31,P32,P33,P34: out std_logic_vector(BusWidth-1 downto 0);
			P40,P41,P42,P43,P44: out std_logic_vector(BusWidth-1 downto 0)
		);
end ImageCacheMemory;


architecture Behavioral of ImageCacheMemory is

	signal d_in: std_logic_vector(BusWidth-1 downto 0);
	signal 	W00,W01,W02,W03,W04,
			W10,W11,W12,W13,W14,
			W20,W21,W22,W23,W24,
			W30,W31,W32,W33,W34,
			W40,W41,W42,W43,W44: std_logic_vector(BusWidth-1 downto 0);	-- elementi della finistra di convoluzione
	signal fifo1_out, fifo2_out, fifo3_out, fifo4_out: std_logic_vector(BusWidth-1 downto 0);

	component Shift_reg is
	  port (
			Clk,Rst,En: in std_logic;
			Data_in: in std_logic_vector(BusWidth-1 downto 0);
			Dout0,Dout1,Dout2,Dout3,Dout4: out std_logic_vector(BusWidth-1 downto 0)
			);
	end component;

	component Row_buffer is 
	  port (
			clk,rst,en: in std_logic;
			Din: in std_logic_vector(BusWidth-1 downto 0);
			Dout: out std_logic_vector(BusWidth-1 downto 0)
			);    
	end component;

		begin

			First_RowWindow: Shift_reg port map(Clock,Reset,En_reg,d_in,W00,W01,W02,W03,W04);
			
			Row_buffer_1: Row_buffer port map(Clock,Reset,En_reg,W04,fifo1_out);

			Second_RowWindow: Shift_reg port map(Clock,Reset,En_reg,fifo1_out,W10,W11,W12,W13,W14);
			
			Row_buffer_2: Row_buffer port map(Clock,Reset,En_reg,W14,fifo2_out);

			Third_RowWindow: Shift_reg port map(Clock,Reset,En_reg,fifo2_out,W20,W21,W22,W23,W24);
			
			Row_buffer_3: Row_buffer port map(Clock,Reset,En_reg,W24,fifo3_out);

			Fourth_RowWindow: Shift_reg port map(Clock,Reset,En_reg,fifo3_out,W30,W31,W32,W33,W34);
			
			Row_buffer_4: Row_buffer port map(Clock,Reset,En_reg,W34,fifo4_out);

			Fifth_RowWindow: Shift_reg port map(Clock,Reset,En_reg,fifo4_out,W40,W41,W42,W43,W44);

			d_in<=DataIn when ReadEn = '1' else (others=>'0'); 
			P00<=W00 when En_Window = '1' else (others=>'0'); 
			P01<=W01 when En_Window = '1' else (others=>'0');
			P02<=W02 when En_Window = '1' else (others=>'0');
			P03<=W03 when En_Window = '1' else (others=>'0');
			P04<=W04 when En_Window = '1' else (others=>'0');
				
			P10<=W10 when En_Window = '1' else (others=>'0'); 
			P11<=W11 when En_Window = '1' else (others=>'0');
			P12<=W12 when En_Window = '1' else (others=>'0');
			P13<=W13 when En_Window = '1' else (others=>'0');
			P14<=W14 when En_Window = '1' else (others=>'0');

			P20<=W20 when En_Window = '1' else (others=>'0'); 
			P21<=W21 when En_Window = '1' else (others=>'0');
			P22<=W22 when En_Window = '1' else (others=>'0');
			P23<=W23 when En_Window = '1' else (others=>'0');
			P24<=W24 when En_Window = '1' else (others=>'0');

			P30<=W30 when En_Window = '1' else (others=>'0'); 
			P31<=W31 when En_Window = '1' else (others=>'0');
			P32<=W32 when En_Window = '1' else (others=>'0');
			P33<=W33 when En_Window = '1' else (others=>'0');
			P34<=W34 when En_Window = '1' else (others=>'0');

			P40<=W40 when En_Window = '1' else (others=>'0'); 
			P41<=W41 when En_Window = '1' else (others=>'0');
			P42<=W42 when En_Window = '1' else (others=>'0');
			P43<=W43 when En_Window = '1' else (others=>'0');
			P44<=W44 when En_Window = '1' else (others=>'0');
    
end Behavioral;