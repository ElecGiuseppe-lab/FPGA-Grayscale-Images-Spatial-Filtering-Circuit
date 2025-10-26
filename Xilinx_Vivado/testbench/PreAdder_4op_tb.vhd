library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PreAdder_4op_tb is
    generic(BusWidth : integer := 8);
end PreAdder_4op_tb;

architecture Behavioral of PreAdder_4op_tb is
    
    -- Signals for testbench
    signal In1_tb, In2_tb, In3_tb, In4_tb : std_logic_vector(BusWidth downto 0);
    signal CumSum_tb : std_logic_vector(11 downto 0);

    -- Component instantiation
    component AdderTreeCSA_4opX9bit
        port (
            In1, In2, In3, In4 : in std_logic_vector(BusWidth downto 0);
            CumSum : out std_logic_vector(11 downto 0)
        );
    end component;

begin

    -- Instantiate the AdderTreeCSA_4opX9bit component
    UUT : AdderTreeCSA_4opX9bit port map (
        In1 => In1_tb,
        In2 => In2_tb,
        In3 => In3_tb,
        In4 => In4_tb,
        CumSum => CumSum_tb
    );

    -- Stimulus process
    stimulus_process : process
    begin
        -- Test case 1
        In1_tb <= std_logic_vector(to_signed(-4, In1_tb'length));
        In2_tb <= std_logic_vector(to_signed(10, In1_tb'length));
        In3_tb <= std_logic_vector(to_signed(-30, In1_tb'length));
        In4_tb <= std_logic_vector(to_signed(-123, In1_tb'length));
        wait for 10 ns;

        -- Test case 2
        In1_tb <= std_logic_vector(to_signed(-4, In1_tb'length));
        In2_tb <= std_logic_vector(to_signed(-9, In1_tb'length));
        In3_tb <= std_logic_vector(to_signed(12, In1_tb'length));
        In4_tb <= std_logic_vector(to_signed(255, In1_tb'length));
        wait for 10 ns;
        
        -- Test case 3
        In1_tb <= std_logic_vector(to_signed(255, In1_tb'length));
        In2_tb <= std_logic_vector(to_signed(255, In1_tb'length));
        In3_tb <= std_logic_vector(to_signed(255, In1_tb'length));
        In4_tb <= std_logic_vector(to_signed(255, In1_tb'length));
        wait for 10 ns;
        
        -- Test case 4
        In1_tb <= std_logic_vector(to_signed(-56, In1_tb'length));
        In2_tb <= std_logic_vector(to_signed(22, In1_tb'length));
        In3_tb <= std_logic_vector(to_signed(5, In1_tb'length));
        In4_tb <= std_logic_vector(to_signed(-346, In1_tb'length));
        wait for 10 ns;
        
        -- Test case 5
        In1_tb <= std_logic_vector(to_signed(-90, In1_tb'length));
        In2_tb <= std_logic_vector(to_signed(532, In1_tb'length));
        In3_tb <= std_logic_vector(to_signed(-483, In1_tb'length));
        In4_tb <= std_logic_vector(to_signed(-123, In1_tb'length));
        wait for 10 ns;

        -- Add more test cases as needed

        -- End simulation
        wait;
    end process stimulus_process;

end Behavioral;