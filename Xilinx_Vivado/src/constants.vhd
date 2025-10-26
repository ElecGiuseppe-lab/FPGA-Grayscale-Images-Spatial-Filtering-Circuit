library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.all;
use IEEE.NUMERIC_STD.ALL;


package constants is

	constant BusWidth: integer := 8;	--lunghezza pixel
    constant RowImage, ColImage: integer := 64;
	constant RowKernel,ColKernel: integer := 5;
	constant dim_count: integer := 13;
	
	type depth_buffer1 is array (RowKernel*ColKernel-1 downto 0) of std_logic_vector (BusWidth-1 downto 0);
	type depth_shift_reg is array (ColKernel-1 downto 0) of std_logic_vector (BusWidth-1 downto 0);
	type depth_buffer2 is array (RowImage-RowKernel-1 downto 0) of std_logic_vector (BusWidth-1 downto 0);
	

    
end package constants;