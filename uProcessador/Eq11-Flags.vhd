-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity flags is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(5 downto 0);
        data_out : out unsigned(5 downto 0)
    );
end entity;

architecture a_flags of flags is
    signal registro : unsigned(5 downto 0);
begin
    process (clk, rst, wr_en)
    begin
        if rst = '1' then
            registro <= "000000";
        elsif wr_en = '1' then
            if rising_edge(clk) then
                registro <= data_in;
            end if;
        end if;
    end process;
    data_out <= registro;
end architecture;