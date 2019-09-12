-- Lab 2 - Register File (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file_tb is
end entity;

architecture a_register_file_tb of register_file_tb is
    component register_file
        port (
            a1, a2   : in unsigned(2 downto 0);  -- Address of the registers that we will read
            a3       : in unsigned(2 downto 0);  -- Address of the register in which we will write 
            wd3      : in unsigned(15 downto 0); -- Write data
            we3      : in std_logic;             -- Write enable
            clk      : in std_logic;             -- Clock
            rst      : in std_logic;             -- Reset
            rd1, rd2 : out unsigned(15 downto 0) -- Data read from the 1st and the 2nd registers
        );
    end component;

    signal clk, rst, we3 : std_logic;             -- Control signals
    signal rd1, rd2      : unsigned(15 downto 0); -- Read data
    signal wd3           : unsigned(15 downto 0); -- Write data
    signal a1, a2, a3    : unsigned(2 downto 0);  -- Addresses
begin
    uut : register_file port map(
        clk => clk,
        rst => rst,
        we3 => we3,
        wd3 => wd3,
        a1  => a1,
        a2  => a2,
        a3  => a3,
        rd1 => rd1,
        rd2 => rd2
    );

    -- Generates the clock signal
    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        rst <= '1';
        we3 <= '0';
        wait for 100 ns;
        rst <= '0';
        wait for 50 ns;
        we3 <= '1';
        wait for 400 ns;
        we3 <= '0';
        wait;
    end process;

    process
    begin
        a1  <= "000";
        a2  <= "000";
        a3  <= "000";
        wd3 <= x"0000";
        wait for 150 ns;
        -- Write some data
        wd3 <= x"F013";
        a3  <= "001";
        wait for 150 ns;
        wd3 <= x"0050";
        a3  <= "110";
        wait for 150 ns;
        -- Read registers
        a1 <= "001";
        a2 <= "000";
        wait for 150 ns;
        a1 <= "110";
        a2 <= "001";
        wait for 150 ns;
        a1 <= "011";
        a2 <= "111";
        wait;
    end process;
end architecture;