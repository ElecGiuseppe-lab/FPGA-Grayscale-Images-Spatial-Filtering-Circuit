library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Booth_mult_TB is
end Booth_mult_TB;

architecture Behavioral of Booth_mult_TB is

    -- Component declaration for the DUT (Design Under Test)
    component Booth_mult is
        port(
            A : in std_logic_vector(11 downto 0);
            B : in std_logic_vector (7 downto 0);
            Ris_mult : out std_logic_vector (19 downto 0)
        ); 
    end component;

    -- Signals for testbench
    signal A_tb : std_logic_vector(11 downto 0);
	signal B_tb : std_logic_vector(7 downto 0);
    signal Ris_mult_tb : std_logic_vector(19 downto 0);

begin

    -- Instantiate the DUT
    DUT: Booth_mult port map(
        A => A_tb,
        B => B_tb,
        Ris_mult => Ris_mult_tb
    );

    -- Stimulus process: apply inputs
    stimulus: process
    begin
        -- Test with various input values
        wait for 100 ns;
        for i in -5 to 15 loop
            for j in -10 to 15 loop
                A_tb <= std_logic_vector(to_signed(i, A_tb'length));
                B_tb <= std_logic_vector(to_signed(j, B_tb'length));
                wait for 10 ns;  -- Wait for some time for the output to settle
            end loop;
        end loop;
        wait;
    end process stimulus;

end Behavioral;