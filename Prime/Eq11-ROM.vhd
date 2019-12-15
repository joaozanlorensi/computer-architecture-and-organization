-- Lab 8 - Prime
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
    -- First, fill the RAM
    0 => b"100110_000_0000000", -- ld %r0,00
    1 => b"100110_001_0100001", -- ld %r1,33
    2 => b"100110_010_0000001", -- ld %r2,1  Used for increments or decrements
    -- LOOP_RAM
    3 => b"001001_000_0010_000", -- ld [%r0], %r0 (stores the value in r0 to the ram address r1)
    4 => b"001100_000_1000_010", -- add.a %r0, %r2 (r0++) 
    5 => b"001101_000_1000_001", -- cmp %r0, %r1 
    6 => b"000010_000_1111101",  -- jrlt LOOP_RAM

    -- Mark the multiples of 2
    7 => b"100110_000_0000010", -- ld %r0,2
    8 => b"100110_001_0000010", -- ld %r1,2
    -- LOOP_2
    9  => b"001100_000_1000_010", -- add.a %r0, %r2 (r0++) 
    10 => b"001000_100_0010_000", -- ld %r4, [%r0]
    11 => b"100100_100_0000000",  -- cmp %r4, 0x00 
    12 => b"000011_000_1111101",  -- jreq LOOP_2
    13 => b"001010_101_0010_000", -- ld %r5, %r0
    -- SUB_2
    14 => b"001101_101_1000_001", -- cmp %r5, %r1
    15 => b"000010_000_0000011",  -- jrlt STR_RAM
    16 => b"001100_101_1010_001", -- sub.a %r5, %r1 ( r5 <- r5 - r1)
    17 => b"000000_110_0001110",  -- jpa SUB_2
    -- STR_RAM
    18 => b"001001_101_0010_000", -- ld [%r0], %r5 (stores the value in r0 to the ram address r1)
    19 => b"100100_100_0100000",  -- cmp %r0, 32
    20 => b"000010_000_1110101",  -- jrlt LOOP_2

    -- Mark the multiples of 3
    21 => b"100110_000_0000011", -- ld %r0,3
    22 => b"100110_001_0000011", -- ld %r1,3
    -- LOOP_3
    23 => b"001100_000_1000_010", -- add.a %r0, %r2 (r0++) 
    24 => b"001000_100_0010_000", -- ld %r4, [%r0]
    25 => b"100100_100_0000000",  -- cmp %r4, 0x00 
    26 => b"000011_000_1111101",  -- jreq LOOP_3
    27 => b"001010_101_0010_000", -- ld %r5, %r0
    -- SUB_3
    28 => b"001101_101_1000_001", -- cmp %r5, %r1
    29 => b"000010_000_0000011",  -- jrlt STR_RAM
    30 => b"001100_101_1010_001", -- sub.a %r5, %r1 ( r5 <- r5 - r1)
    31 => b"000000_110_0011100",  -- jpa SUB_3
    -- STR_RAM
    32 => b"001001_101_0010_000", -- ld [%r0], %r5 (stores the value in r0 to the ram address r1)
    33 => b"100100_100_0100000",  -- cmp %r0, 32
    34 => b"000010_000_1110101",  -- jrlt LOOP_3

    -- Mark the multiples of 5 
    35 => b"100110_000_0000101", -- ld %r0,5
    36 => b"100110_001_0000101", -- ld %r1,5
    -- LOOP_5
    37 => b"001100_000_1000_010", -- add.a %r0, %r2 (r0++) 
    38 => b"001000_100_0010_000", -- ld %r4, [%r0]
    39 => b"100100_100_0000000",  -- cmp %r4, 0x00 
    40 => b"000011_000_1111101",  -- jreq LOOP_5
    41 => b"001010_101_0010_000", -- ld %r5, %r0
    -- SUB_5
    42 => b"001101_101_1000_001", -- cmp %r5, %r1
    43 => b"000010_000_0000011",  -- jrlt STR_RAM
    44 => b"001100_101_1010_001", -- sub.a %r5, %r1 ( r5 <- r5 - r1)
    45 => b"000000_110_0101010",  -- jpa SUB_5
    -- STR_RAM
    46 => b"001001_101_0010_000", -- ld [%r0], %r5 (stores the value in r0 to the ram address r1)
    47 => b"100100_100_0100000",  -- cmp %r0, 32
    48 => b"000010_000_1110101",  -- jrlt LOOP_5

    -- Move prime values to the end of the RAM
    49 => b"100110_000_0000000", -- ld %r0,0
    -- Add R1 to itself to load 127 in it
    50 => b"100110_001_0100000",  -- ld %r1,32
    51 => b"001100_001_1000_001", -- add.a %r1, %r1 (r1 += r1) 
    52 => b"001100_001_1000_001", -- add.a %r1, %r1 (r1 += r1) 
    53 => b"001100_001_1010_010", -- sub.a %r1, %r2 (r1--)
    -- NEXT
    54 => b"001100_000_1000_010", -- add.a %r0, %r2 (r0++) 
    -- If r0 is 32, go to end
    55 => b"100100_000_0100001", -- cmp %r0, 33
    56 => b"000011_000_0000111", -- jreq END
    -- Read value from the RAM
    57 => b"001000_100_0010_000", -- ld %r4, [%r0]
    -- A zero means the value is not prime so continue the loop
    58 => b"100100_100_0000000", -- cmp %r4, 0x00 
    59 => b"000011_000_1111011", -- jreq NEXT
    -- Otherwise store the value in the RAM and continue
    60 => b"001001_000_0010_001", -- ld [%r1], %r0 (stores the value in r0 to the ram address r1)
    61 => b"001100_001_1010_010", -- sub.a %r1, %r2 (r1--)
    62 => b"000000_110_0110110",  -- jpa NEXT
    -- END
    63 => b"000000_110_0000000", -- jpa 0
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