-- Lab 8 - Prime
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ULA Opcodes:
--   00 - ADD : Output receives in_A + in_B
--   01 - SUB : Output receives in_A - in_B 
--   10 - DIV : Output receives in_A / in_B
--   11 - NEG : Flag receives 1 if in_A is negative

entity ula is
    port (
        in_A, in_B : in unsigned(23 downto 0);
        op         : in unsigned(1 downto 0);
        out_s      : out unsigned(23 downto 0);
        flag       : out std_logic
    );
end entity;

architecture a_ula of ula is
begin
    out_s <= in_A + in_B when op = "00" else
        in_A - in_B when op = "01" else
        in_A / in_B when op = "10" else
        x"000000";
    flag <= in_A(23) when op = "11" else
        '0';
end architecture;