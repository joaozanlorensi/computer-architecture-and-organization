-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_pc_uc_tb is
end entity;

architecture a_rom_pc_uc_tb of rom_pc_uc_tb is
    component rom_pc_uc is
        port (
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    signal clk : std_logic;
    signal rst : std_logic;
begin
    uut : rom_pc_uc port map(
        clk => clk,
        rst => rst
    );

    process
    begin
        clk <= '1';
        wait for 50 ns;
        clk <= '0';
        wait for 50 ns;
    end process;

    process
    begin
        rst <= '1';
        wait for 200 ns;
        rst <= '0';
        wait;
    end process;
end architecture;