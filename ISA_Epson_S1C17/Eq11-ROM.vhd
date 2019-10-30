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
    type mem is array (0 to 183) of unsigned(11 downto 0); -- total of instructions: 184 (including variations)
    constant rom_data : mem := (
        -- instrucoes
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