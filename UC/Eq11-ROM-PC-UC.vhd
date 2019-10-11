-- Lab 4 - ROM + PC integration
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_pc_uc is
    port(
        clk     : in std_logic;
        address : in unsigned(6 downto 0);
        data    : out unsigned(7 downto 0);
    )