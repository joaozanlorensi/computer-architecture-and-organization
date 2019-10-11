-- Lab 4 - ROM
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom is
        port (
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(11 downto 0)
        );
    end component;

    signal clk     : std_logic;
    signal address : unsigned(6 downto 0);
    signal data    : unsigned(7 downto 0);
begin
    uut : rom port map(
        clk     => clk,
        address => address,
        data    => data
    );

    -- CLK Process
    process
    begin
        clk <= '1';
        wait for 50 ns;
        clk <= '0';
        wait for 50 ns;
    end process;

    -- Read data
    process
    begin
        address <= "0000000";
        wait for 100 ns;
        address <= "0000001";
        wait for 100 ns;
        address <= "0000011";
        wait for 100 ns;
        address <= "0000111";
        wait for 100 ns;
        address <= "0001001";
        wait for 100 ns;
        address <= "0001010";
        wait for 100 ns;
        wait;
    end process;

end architecture;