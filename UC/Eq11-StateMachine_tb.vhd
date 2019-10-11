-- Lab 4 - State Machine
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine_tb is
end entity;

architecture a_state_machine_tb of state_machine_tb is
    component state_machine is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            data_in  : in std_logic;
            data_out : out std_logic
        );
    end component;

    signal clk      : std_logic;
    signal rst      : std_logic;
    signal data_out : std_logic;
begin
    uut : state_machine port map(
        clk      => clk,
        rst      => rst,
        data_in  => '0',
        data_out => data_out
    );

    -- Apenas o CLK é suficiente para os testes
    process
    begin
        clk <= '1';
        wait for 50 ns;
        clk <= '0';
        wait for 50 ns;
    end process;

    process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

end architecture;