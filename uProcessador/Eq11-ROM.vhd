-- Lab 6 - Conditional jumps
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
        data    : out unsigned(15 downto 0) -- Instructions now have 16 bits
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0); 
    constant rom_data : mem := (
    0 => b"100110_010_0000001",  -- ld %r2, 1
    1 => b"100110_011_0000000",  -- ld %r3, 0
    2 => b"100110_100_0000000",  -- ld %r4, 0 
    3 => b"001100_100_1000_011", -- add.a %r4, %r3 ( r4 <- r4 + r3)
    4 => b"001100_011_1000_010", -- add.a %r3, %r2 ( r3 <- r3 + 1)
    5 => b"100100_011_0011110",  -- cmp %r3, 30
    6 => b"000010_000_1111101",  -- jrlt -3
    7 => b"001010_101_0011_100", -- ld.a %r5, %r4 (r5 <- r4)
    others => (others => '0')
    );

begin
    process (clk)
    begin
        if (rising_edge(clk)) then
            data <= rom_data(to_integer(address));
        end if;
    end process;
end architecture;