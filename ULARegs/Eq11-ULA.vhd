-- Lab 1 - ULA (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ULA Opcodes:
--   00 - ADD : Output receives in_A + in_B
--   01 - SUB : Output receives in_A - in_B 
--   10 - DIV : Output receives in_A / in_B
--   11 - CMP : Flag receives 1 when in_A is greater than in_B

entity ula is
    port (
        in_A, in_B : in unsigned(15 downto 0);  -- Data inputs 
        op         : in unsigned(1 downto 0);   -- Defines the operation
        out_s      : out unsigned(15 downto 0); -- Result of the operation
        flag       : out std_logic              -- Flag
    );
end entity;

architecture a_ula of ula is
begin
    out_s <= in_A + in_B when op = "00" else
        in_A - in_B when op = "01" else
        in_A / in_B when op = "10" and in_B /= x"0000" else
        x"0000";

    flag <= '1' when in_A > in_B and op = "11" else
        '0';
end architecture;
