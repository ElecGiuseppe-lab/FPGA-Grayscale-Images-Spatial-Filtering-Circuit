library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CounterSync_13bit_TB is
end CounterSync_13bit_TB;

architecture Behavioral of CounterSync_13bit_TB is

    constant CLOCK_PERIOD : time := 10 ns; -- Periodo del clock (esempio)

    signal clock, clear, enable : std_logic := '0';
    signal Q_out : std_logic_vector(12 downto 0);

    component CounterSync_13bit
        port (
            Clear, Clock, Enable: in std_logic;
            Q : out std_logic_vector(12 downto 0)
        );
    end component;

begin

    dut : CounterSync_13bit
        port map (
            Clear => clear,
            Clock => clock,
            Enable => enable,
            Q => Q_out
        );

    -- Processo per generare il segnale del clock
    clk_process : process
    begin
        wait for CLOCK_PERIOD / 2;
        clock <= '1';
        wait for CLOCK_PERIOD / 2;
        clock <= '0';
    end process;

    -- Processo per controllare il segnale clear
    clear_process : process
    begin
        clear <= '1'; -- Inizialmente impostato su '1' per il reset
        wait for 20 ns; -- Durata del reset
        clear <= '0';
        wait for 900 ns;
        clear <= '1';
        wait for 20 ns; -- Durata del reset
        clear <= '0';
        wait;
    end process;

    -- Processo per controllare il segnale enable
    enable_process : process
    begin
        enable <= '0';
        wait for 100 ns; -- Attendere prima di abilitare il contatore
        enable <= '1';
        wait;
    end process;

end Behavioral;