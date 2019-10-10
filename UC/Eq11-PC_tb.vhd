-- Lab 4 - Program Counter Testbench
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end entity;

architecture a_pc_tb of pc_tb is
    component pc is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal wr_en     : std_logic;
    signal data_in : unsigned(15 downto 0);
    signal data_out    : unsigned(15 downto 0);

begin
    uut : pc port map(
        clk     => clk,
        rst     => rst,
        wr_en   => wr_en,
        data_in => data_in,
        data_out => data_out
    );

    process
    begin
        wr_en <= '1';
        wait;
    end process;

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
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    process
    begin
        data_in <= x"0000";
        wait for 50 ns;
        data_in <= x"0001";
        wait for 50 ns;
        data_in <= x"0100";
        wait for 50 ns;
        data_in <= x"1100";
        wait for 50 ns;
        data_in <= x"0F00";
        wait for 50 ns;
        data_in <= x"FF00";
        wait for 50 ns;
        data_in <= x"0800";
        wait for 50 ns;
        data_in <= x"00D0";
        wait;
    end process;
        
end architecture;