-- Lab 7 - RAM
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
    0  => b"100110_000_0110010",  -- ld %r0,50 
    1  => b"100110_001_0110010",  -- ld %r1,50 
    2  => b"100110_010_0000001",  -- ld %r2,1 
    3  => b"100110_011_0000001",  -- ld %r3,0 
    4  => b"001100_000_1000_001", -- add.a %r0, %r1 ( r0 <- r0 + r1) 
    5  => b"001100_000_1000_001", -- add.a %r0, %r1 ( r0 <- r0 + r1) 
    6  => b"001100_000_1000_001", -- add.a %r0, %r1 ( r0 <- r0 + r1) 
    7  => b"001100_000_1000_001", -- add.a %r0, %r1 ( r0 <- r0 + r1) 
    8  => b"100110_001_0000000",  -- ld %r1,0 
    9  => b"001001_000_0010_001", -- ld [%r1], %r0 (stores the value in r0 to the ram address r1)
    10 => b"001100_000_1010_010", -- sub.a %r0, %r2 ( r0 <- r0 - 1)
    11 => b"001100_001_1000_010", -- add.a %r1, %r2 ( r1 <- r1 + 1) 
    12 => b"100100_001_0111111",  -- cmp %r1, 63
    13 => b"000010_000_1111100",  -- jrlt -4
    14 => b"001100_001_1000_010", -- add.a %r3, %r2 ( r3 <- r3 + 1) 
    15 => b"100100_001_0000010",  -- cmp %r3,2 
    16 => b"000010_000_1111000",  -- jrlt -8
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