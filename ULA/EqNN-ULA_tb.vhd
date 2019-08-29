-- Lab 1 - ULA (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
    component ula
        port (
            in_A, in_B : in unsigned(15 downto 0);
            op         : in unsigned(1 downto 0);
            out_s      : out unsigned(15 downto 0);
            flag       : out std_logic
        );
    end component;

    signal flag              : std_logic;
    signal in_A, in_B, out_s : unsigned(15 downto 0);
    signal op                : unsigned(1 downto 0);

begin
    utt : ula port map(
        in_A  => in_A,
        in_B  => in_B,
        op    => op,
        out_s => out_s,
        flag  => flag
    );
    process
    begin
        in_A <= x"0001";
        in_B <= x"0010";
        op   <= "00"; -- sum
        wait for 50 ns;
        in_A <= x"0001";
        in_B <= x"0001";
        op   <= "01"; -- subtraction;
        wait for 50 ns;
        in_A <= x"0004";
        in_B <= x"0002";
        op   <= "10"; -- division
        wait for 50 ns;
        in_A <= x"A000";
        op   <= "11"; -- verifies if in_A is negative
        wait for 50 ns;
        wait;
    end process;
end architecture;