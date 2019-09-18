-- Lab 2 - Register File (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ularegs is
    port (
        ra1, ra2 : in unsigned(2 downto 0);  -- 2 addresses to read
        wa3      : in unsigned(2 downto 0);  -- address to write in
        wen      : in std_logic;              -- write enable
        data_in  : in unsigned(15 downto 0);  -- data to write
        sel      : in std_logic;              -- selector to choose whether the data from the 2nd operator will come from a register or imm 
        imm      : in unsigned(15 downto 0);  -- immediate: constant value
        rst      : in std_logic;              -- reset
        clk      : in std_logic;              -- clock
        op       : in unsigned(1 downto 0);   -- operation selector
        data_out : out unsigned(15 downto 0); -- result of the operation
        flag     : out std_logic              -- flag
    );
end entity;

architecture a_ularegs of ularegs is

    component register_file
        port (
            a1, a2   : in unsigned(2 downto 0);  -- Address of the registers that we will read
            a3       : in unsigned(2 downto 0);  -- Address of the register in which we will write 
            wd3      : in unsigned(15 downto 0); -- Write data
            we3      : in std_logic;             -- Write enable
            clk      : in std_logic;             -- Clock
            rst      : in std_logic;             -- Reset
            rd1, rd2 : out unsigned(15 downto 0) -- Data read from the 1st and the 2nd registers
        );
    end component;
    component ula
        port (
            in_A, in_B : in unsigned(15 downto 0);  -- Data inputs 
            op         : in unsigned(1 downto 0);   -- Defines the operation
            out_s      : out unsigned(15 downto 0); -- Result of the operation
            flag       : out std_logic              -- Flag
        );
    end component;

    signal a1, a2, a3 : unsigned(2 downto 0);
    signal wd3 : unsigned(15 downto 0);
    signal we3 : std_logic;
    signal rd1, rd2 : unsigned(15 downto 0);
    signal in_A : unsigned(15 downto 0);
    signal in_B : unsigned(15 downto 0);
    signal out_s : unsigned(15 downto 0);
    signal data1, data2 : unsigned(15 downto 0);

begin
    -- Mux used to select the 2nd data operator:
    --           0 - selects the data from the 2nd register read
    --           1 - selects the data from the immediate
    data2 <= rd2 when sel = '0' else
             imm when sel = '1' else
            x"0000";

    regs : register_file port map(
        a1  => ra1,
        a2  => ra2,
        a3  => wa3,
        wd3 => wd3,
        we3 => wen,
        clk => clk,
        rst => rst,
        rd1 => data1,
        rd2 => data2
        );
    alu : ula port map(
            in_A  => rd1,
            in_B  => rd2,
            op    => op,
            out_s => out_s,
            flag  => flag
        );

end architecture;