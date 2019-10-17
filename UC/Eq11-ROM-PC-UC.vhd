-- Lab 4 - Control Unit
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_uc is
    port(
        rom_out : out unsigned(11 downto 0)
    );
end entity;

architecture a_rom_uc of rom_uc is
    component pc is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;
    component rom is
        port (
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(11 downto 0)
        );
    end component;

    signal clk     : std_logic;
    signal rst     : std_logic;
    signal wr_en     : std_logic;
    signal data_in : unsigned(6 downto 0);
    signal data_out    : unsigned(6 downto 0);
    
begin
    uutpc : pc port map(
        clk     => clk,
        rst     => rst,
        wr_en   => wr_en,
        data_in => data_in,
        data_out => data_out
    );
    uutrom : rom port map(
        clk => clk,
        address => data_out,
        data => rom_out
    );
        
end architecture;