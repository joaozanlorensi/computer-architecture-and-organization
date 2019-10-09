-- Lab 4 - Control Unit
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity state_machine is
    port (
        clk      : in std_logic;
        rst      : in std_logic;
        data_in  : in std_logic;
        data_out : out std_logic
    );
end entity;

architecture a_state_machine of state_machine is
    signal state : std_logic;
begin
    -- Por enquanto, data_in é ignorado
    process (clk, rst)
    begin
        if rst = '1' then
            state <= '0';
        else
            if rising_edge(clk) then
                state <= not state;
            end if;
        end if;
    end process;

    data_out <= state;
end architecture;