-- Lab 3 - ALU + RegFile (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ularegs_tb is
end entity;

architecture a_ularegs_tb of ularegs_tb is

    component ularegs
        port (
            ra1, ra2 : in unsigned(2 downto 0);   -- 2 addresses to read
            wa3      : in unsigned(2 downto 0);   -- address to write in
            wen      : in std_logic;              -- write enable
            data_in  : in unsigned(15 downto 0);  -- data to write
            sel      : in std_logic;              -- selector to choose whether the data from the 2nd operator will come from a register or imm 
            imm      : in unsigned(15 downto 0);  -- immediate: constant value, set sel = 1 to use it
            rst      : in std_logic;              -- reset
            clk      : in std_logic;              -- clock
            op       : in unsigned(1 downto 0);   -- operation selector
            rd1      : out unsigned(15 downto 0); -- Data from register 1
            rd2      : out unsigned(15 downto 0); -- Data from register 2
            data_out : out unsigned(15 downto 0); -- result of the operation
            flag     : out std_logic              -- flag
        );
    end component;

    signal ra1, ra2 : unsigned(2 downto 0);
    signal wa3      : unsigned(2 downto 0);
    signal wen      : std_logic;
    signal data_in  : unsigned(15 downto 0);
    signal sel      : std_logic;
    signal imm      : unsigned(15 downto 0);
    signal rst      : std_logic;
    signal clk      : std_logic;
    signal op       : unsigned(1 downto 0);
    signal data_out : unsigned(15 downto 0);
    signal flag     : std_logic;
    signal rd1, rd2 : unsigned(15 downto 0);

begin
    uut : ularegs port map(
        ra1      => ra1,
        ra2      => ra2,
        wa3      => wa3,
        wen      => wen,
        data_in  => data_in,
        sel      => sel,
        imm      => imm,
        rst      => rst,
        clk      => clk,
        op       => op,
        data_out => data_out,
        rd1      => rd1,
        rd2      => rd2,
        flag     => flag
    );

    imm <= x"F000";

    process
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;

    process
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;

    process
    begin
        -- Clears everything
        ra1     <= "000";
        ra2     <= "000";
        wen     <= '0';
        wa3     <= "000";
        op      <= "00";
        sel     <= '0';
        data_in <= x"0000";

        wait for 100 ns;

        -- Writes data to reg 1
        wa3     <= "001";
        data_in <= x"FF00";
        wen     <= '1';
        wait for 100 ns;
        wen <= '0';

        -- Writes data to reg 2 
        wa3     <= "010";
        data_in <= x"F000";
        wen     <= '1';
        wait for 175 ns;
        wen <= '0';

        -- Reads data from registers
        ra1 <= "001";
        ra2 <= "010";
        
        -- Subtracts them
        sel <= '0';  -- Uses the second register instead of the imm
        op  <= "01"; -- SUB R1, R2

        wait for 100 ns;

        -- Reads data from registers
        ra1 <= "001";
        ra2 <= "000";

        sel <= '1'; -- Uses the imm instead of the second register
        op <= "11"; -- Checks if reg1 is greater than reg2

        wait for 100 ns;
        wait;
    end process;
end architecture;
