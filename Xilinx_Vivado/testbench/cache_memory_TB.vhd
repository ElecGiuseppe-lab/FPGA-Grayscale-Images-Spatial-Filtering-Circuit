library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cache_memory_TB is
end cache_memory_TB;

architecture sim of cache_memory_TB is
    -- Constants
    constant BusWidth : integer := 8; -- Assuming BusWidth is 8 for this example

    -- Signals
    signal Clock : std_logic := '0';
    signal Reset : std_logic := '0';
    signal En_reg : std_logic := '0';
    signal Prog_full : std_logic := '0';
    signal DataIn : std_logic_vector(BusWidth-1 downto 0);
    signal ReadEn : std_logic := '0';
    signal P00,P01,P02,P03,P04 : std_logic_vector(BusWidth-1 downto 0);
    signal P10,P11,P12,P13,P14 : std_logic_vector(BusWidth-1 downto 0);
    signal P20,P21,P22,P23,P24 : std_logic_vector(BusWidth-1 downto 0);
    signal P30,P31,P32,P33,P34 : std_logic_vector(BusWidth-1 downto 0);
    signal P40,P41,P42,P43,P44 : std_logic_vector(BusWidth-1 downto 0);
    
    signal clk_period: time := 5 ns;

    -- Component instantiation
    component CacheMemory is
        port(
            Clock, Reset, En_reg, Prog_full : in std_logic;
            DataIn : in std_logic_vector(BusWidth-1 downto 0);
            ReadEn : in std_logic;
            P00,P01,P02,P03,P04 : inout std_logic_vector(BusWidth-1 downto 0);
            P10,P11,P12,P13,P14 : inout std_logic_vector(BusWidth-1 downto 0);
            P20,P21,P22,P23,P24 : inout std_logic_vector(BusWidth-1 downto 0);
            P30,P31,P32,P33,P34 : inout std_logic_vector(BusWidth-1 downto 0);
            P40,P41,P42,P43,P44 : inout std_logic_vector(BusWidth-1 downto 0)
        );
    end component;

begin
    -- DUT instantiation
    DUT: CacheMemory port map (
        Clock => Clock,
        Reset => Reset,
        En_reg => En_reg,
        Prog_full => Prog_full,
        DataIn => DataIn,
        ReadEn => ReadEn,
        P00 => P00, P01 => P01, P02 => P02, P03 => P03, P04 => P04,
        P10 => P10, P11 => P11, P12 => P12, P13 => P13, P14 => P14,
        P20 => P20, P21 => P21, P22 => P22, P23 => P23, P24 => P24,
        P30 => P30, P31 => P31, P32 => P32, P33 => P33, P34 => P34,
        P40 => P40, P41 => P41, P42 => P42, P43 => P43, P44 => P44
    );

    -- Clock generation process
   clk: process
   begin
            Clock <= '0';
            wait for clk_period/2;
            Clock <= '1';
            wait for clk_period/2;
    end process;

    -- Stimulus process
   rst: process
   begin
        -- Reset
        Reset <= '1';
        wait for clk_period;
        Reset <= '0';
        wait for 16*clk_period;
        Reset <= '1';
        wait;
  end process;

   reg_en: process
   begin
        wait for 3*clk_period;
        -- Enable register
        En_reg <= '1';
        wait for clk_period;
        En_reg <= '0';
        wait for 3*clk_period;
        En_reg <= '1';
        wait;
   end process;

    read_en: process
    begin
        wait for 3*clk_period;
        -- Read operation
        ReadEn <= '1';
        wait;
    end process;
    
    full: process
   begin
        -- Program full signal
        Prog_full <= '1';
        wait for clk_period;
        Prog_full <= '0';
        wait for 6*clk_period;
        Prog_full <= '1';
        wait;
   end process;   
    
    tb: process
    begin
    
        wait for 3*clk_period;
        
        DataIn <= "00000010";
        wait for clk_period;
        DataIn <= "00000100";
        wait for clk_period;
        DataIn <= "00001000";
        wait for clk_period;
        DataIn <= "00010000";
        wait for clk_period;
        DataIn <= "00100000";
        wait for clk_period;
        DataIn <= "01000000";
        wait for clk_period;
        DataIn <= "10000000";
        wait for clk_period;
        DataIn <= "00000011";
        wait for clk_period;
        DataIn <= "00000111";
        wait for clk_period;
        DataIn <= "00001111";
        wait for clk_period;
        DataIn <= "00011111";
        wait for clk_period;
        DataIn <= "11000000";
        wait for clk_period;
        DataIn <= "11100000";
        wait for clk_period;
        DataIn <= "11110000";
        wait for clk_period;
        DataIn <= "11111000";
        wait for clk_period;
        DataIn <= "00011000";
        wait for clk_period;
        DataIn <= "01010100";
        wait;
     end process;
        
end sim;
