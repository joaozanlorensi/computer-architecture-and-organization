-- Lab 5 - "Programmable calculator"
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
    type mem is array (0 to 183) of unsigned(15 downto 0); -- total of instructions: 184 (including variations)
    constant rom_data : mem := (
    0  => b"100110_011_0000101",  -- ld %r3, 0x05 (sign-extended)
    1  => b"100110_100_0001000",  -- ld %r4, 0x08 (sign-extended)
    2  => b"100110_010_0000001",  -- ld %r2, 0x01 (used for subtraction)
    3  => b"001100_101_1000_011", -- add.a %r5, %r3 ( r5 <- r5 + r3)
    4  => b"001100_101_1000_100", -- add.a %r5, %r4 ( r5 <- r5 + r4)
    5  => b"001100_101_1010_010", -- sub.a %r5, %r2 ( r5 <- r5 - 1)
    6  => b"000000_110_0010100",  -- jpa 0x14
    20 => b"001010_011_0011_101", -- ld.a %r3, %r5 (r3 <- r5)
    21 => b"000000_110_0000011",  -- jpa 0x03
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