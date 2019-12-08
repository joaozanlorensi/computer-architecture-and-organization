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
    0 => b"100110_000_0000100",  -- ld %r0, 4
    1 => b"100110_001_0000011",  -- ld %r1, 3
    2 => b"001001_000_0010_001", -- ld [%r1], %r0 (stores the value in r0 to the ram address r1)
    3 => b"001000_010_0010_001", -- ld %r2, [%r1] (loads the value in the ram address r1 to the register r2) OK
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