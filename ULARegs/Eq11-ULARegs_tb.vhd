-- Lab 2 - Register File (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ularegs_tb is
end entity;

architecture a_ularegs_tb of ularegs_tb is

    component ularegs(
        ra1, ra2 : in unsigned(15 downto 0);  -- 2 addresses to read
        wa3      : in unsigned(15 downto 0);  -- address to write in
        wen      : in std_logic;              -- write enable
        data_in  : in unsigned(15 downto 0);  -- data to write
        rst      : in std_logic;              -- reset
        clk      : in std_logic;              -- clock
        op       : in unsigned(1 downto 0);   -- operation selector
        data_out : out unsigned(15 downto 0); -- result of the operation
        flag     : out std_logic              -- flag
    )
    end component;

    signal ra1, ra2 : unsigned(15 downto 0);
    signal wa3 : unsigned(15 downto 0);
    signal wen : std_logic;
    signal data_in unsigned(15 downto 0);
    signal rst : std_logic;
    signal clk : std_logic;
    signal op : unsigned(1 downto 0);
    signal data_out : unsigned(15 downto 0);
    signal flag : std_logic;

end architecture;