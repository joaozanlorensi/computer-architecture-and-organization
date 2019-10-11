-- Lab 4 - ROM
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port (
        clk     : in std_logic;
        address : in unsigned(6 downto 0);
        data    : out unsigned(11 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(11 downto 0);
    constant rom_data : mem := (
    0  => x"002",
    1  => x"080",
    2  => x"000",
    3  => x"000",
    4  => x"080",
    5  => x"002",
    6  => x"0F3",
    7  => x"002",
    8  => x"002",
    9  => x"000",
    10 => x"000",
    others => (others => '0')
    );
begin
    process (clk)
    begin
        -- ROM Síncrona!
        if (rising_edge(clk)) then
            data <= rom_data(to_integer(address));
        end if;
    end process;
end architecture;