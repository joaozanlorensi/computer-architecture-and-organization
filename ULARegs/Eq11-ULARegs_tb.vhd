-- Lab 2 - Register File (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ularegs_tb is
end entity;

architecture a_ularegs_tb of ularegs_tb is

    component ularegs
        port (
            ra1, ra2 : in unsigned(2 downto 0);   -- 2 addresses to read
            wa3      : in unsigned(2 downto 0);   -- address to write in
            wen      : in std_logic;              -- write enable
            data_in  : in unsigned(15 downto 0);  -- data to write
            sel      : in std_logic;              -- selector to choose whether the data from the 2nd operator will come from a register or imm 
            imm      : in unsigned(15 downto 0);  -- immediate: constant value
            rst      : in std_logic;              -- reset
            clk      : in std_logic;              -- clock
            op       : in unsigned(1 downto 0);   -- operation selector
            data_out : out unsigned(15 downto 0); -- result of the operation
            flag     : out std_logic              -- flag
        );
    end component;

    signal ra1, ra2 : unsigned(2 downto 0);
    signal wa3      : unsigned(2 downto 0);
    signal wen      : std_logic;
    signal data_in  : unsigned(15 downto 0);
    signal sel      : std_logic;
    signal imm      : unsigned(15 downto 0);
    signal rst      : std_logic;
    signal clk      : std_logic;
    signal op       : unsigned(1 downto 0);
    signal data_out : unsigned(15 downto 0);
    signal flag     : std_logic;

begin
    uut : ularegs port map(
        ra1 => ra1, 
        ra2 => ra2,       
        wa3 => wa3,
        wen => wen,      
        data_in => data_in, 
        sel => sel,       
        imm => imm,     
        rst => rst,      
        clk => clk,      
        op => op,       
        data_out => data_out, 
        flag => flag 
    );

    imm <= x"0000";

    process
    begin -- clock activation
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process
    begin -- reset and write enable activation
        rst <= '1';
        wen <= '0';
        wait for 50 ns;
        rst <= '0';
        wait for 50 ns;
        wen <= '1';
        wait for 600 ns;
        wen <= '0';
        wait for 1000 ns;
        wait;
    end process;

    process
    begin -- write some data
        wa3 <= "001";
        data_in <= x"FF00";
        sel <= '0';
        wait for 400 ns;
        wa3 <= "010";
        data_in <= x"00FF";
        sel <= '0';
        wait for 300 ns; -- read some data
        ra1 <= "001";
        ra2 <= "010";
        sel <= '0'; -- selects the 2nd register
        op <= "00"; -- sum
        wait for 400 ns;
        ra1 <= "000";
        ra2 <= "001";
        sel <= '1'; -- reads from the immediate
        op <= "11"; -- verifies if data from the 1st register is negative or not
        wait for 400 ns;
        wait;
    end process;

end architecture;