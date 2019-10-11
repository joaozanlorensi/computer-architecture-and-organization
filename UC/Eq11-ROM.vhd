-- Lab 4 - Control Unit
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
        data    : out unsigned(7 downto 0);
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(7 downto 0);
    constant rom_data : mem := (
    0  => x"02",
    1  => x"80",
    2  => x"00",
    3  => x"00",
    4  => x"80",
    5  => x"02",
    6  => x"F3",
    7  => x"02",
    8  => x"02",
    9  => x"00",
    10 => x"00",
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