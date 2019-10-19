-- Lab 4 - Control Unit
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_pc_uc is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity;

architecture a_rom_pc_uc of rom_pc_uc is
    -- Program counter
    component pc is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(6 downto 0);
            data_out : out unsigned(6 downto 0)
        );
    end component;

    -- ROM
    component rom is
        port (
            clk     : in std_logic;
            address : in unsigned(6 downto 0);
            data    : out unsigned(11 downto 0)
        );
    end component;

    -- Control unit
    component uc is
        port (
            instruction : in unsigned(11 downto 0);
            clk         : in std_logic;
            rst         : in std_logic;
            jump_en     : out std_logic;
            wr_en       : out std_logic
        );
    end component;

    signal wr_en   : std_logic;
    signal jump_en : std_logic;

    signal pc_out : unsigned(6 downto 0);
    signal pc_in  : unsigned(6 downto 0);

    signal rom_out : unsigned(11 downto 0);

    signal jump_addr : unsigned(6 downto 0);

begin
    inner_pc : pc port map(
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en,
        data_in  => pc_in,
        data_out => pc_out
    );
    inner_rom : rom port map(
        clk     => clk,
        address => pc_out,
        data    => rom_out
    );
    inner_uc : uc port map(
        clk         => clk,
        rst         => rst,
        wr_en       => wr_en,
        jump_en     => jump_en,
        instruction => rom_out
    );

    -- Jump address 
    jump_addr <= rom_out(6 downto 0) when jump_en = '1' else
    "0000000";

    -- PC input
    pc_in <= pc_out + 1 when jump_en = '0' else
    jump_addr;
end architecture;