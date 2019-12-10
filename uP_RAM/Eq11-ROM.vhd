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
    -- R0 will containt the value to be written to the RAM
    0 => b"100110_000_0110010", -- ld %r0,50 
    1 => b"100110_011_0110010", -- ld %r3,50 
    -- Since our ld instruction uses sign extended immediate values, we load the 
    -- inteded value divided by 4 in R3 and add it 4 times to R0
    2 => b"001100_000_1000_011", -- add.a %r0, %r3 ( r0 <- r0 + r3) 
    3 => b"001100_000_1000_011", -- add.a %r0, %r3 ( r0 <- r0 + r3) 
    4 => b"001100_000_1000_011", -- add.a %r0, %r3 ( r0 <- r0 + r3) 
    5 => b"001100_000_1000_011", -- add.a %r0, %r3 ( r0 <- r0 + r3) 
    -- R2 loaded with 1 for increments
    6 => b"100110_010_0000001", -- ld %r2,1 
    -- R1 will be use for the RAM address
    7 => b"100110_001_0000000", -- ld %r1,0 
    -- R4 will be used for comparison with R1 and determine if the loop should continue
    8 => b"100110_100_0100000", -- ld %r4, 32
    -- As before, add R4 with itself to obtain 128 in it
    9  => b"001100_100_1000_100", -- add.a %r4, %r4 ( r4 <- r4 + r4 ) 
    10 => b"001100_100_1000_100", -- add.a %r4, %r4 ( r4 <- r4 + r4 ) 

    -- Main loop
    11 => b"001001_000_0010_001", -- ld [%r1], %r0 (stores the value in r0 to the ram address r1)
    12 => b"001100_000_1010_010", -- sub.a %r0, %r2 ( r0 <- r0 - 1)
    13 => b"001100_001_1000_010", -- add.a %r1, %r2 ( r1 <- r1 + 1) 
    14 => b"001101_001_1000_100", -- cmp %r1, %r4 
    15 => b"000010_000_1111100",  -- jrlt -4
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