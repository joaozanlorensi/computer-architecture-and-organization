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
--   11 - NEG : Flag receives 1 if in_A is negative

entity ula is
    port (
        in_A, in_B : in unsigned(15 downto 0);
        op         : in unsigned(1 downto 0);
        out_s      : out unsigned(15 downto 0);
        flag       : out std_logic
    );
end entity;

architecture a_ula of ula is
    signal operation_result : unsigned(15 downto 0);
    signal flag_result      : std_logic;
begin
    process (in_A, in_B, op)
    begin
        case(op) is
            when "00" =>
            operation_result <= in_A + in_B;
            flag_result      <= '0';
            when "01" =>
            operation_result <= in_A - in_B;
            flag_result      <= '0';
            when "10" =>
            operation_result <= in_A / in_B;
            flag_result      <= '0';
            when "11" =>
            operation_result <= x"0000";
            flag_result      <= in_A(15);
            when others =>
            operation_result <= x"0000";
            flag_result      <= '0';
        end case;
    end process;
    out_s <= operation_result;
    flag  <= flag_result;
end architecture;