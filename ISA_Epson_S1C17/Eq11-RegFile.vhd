-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        a1, a2   : in unsigned(2 downto 0);  -- Address of the registers that we will read
        a3       : in unsigned(2 downto 0);  -- Address of the register in which we will write 
        wd3      : in unsigned(15 downto 0); -- Write data
        we3      : in std_logic;             -- Write enable
        clk      : in std_logic;             -- Clock
        rst      : in std_logic;             -- Reset
        rd1, rd2 : out unsigned(15 downto 0) -- Data read from the 1st and the 2nd registers
    );
end entity;

architecture a_register_file of register_file is
    component reg16bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7                         : std_logic;
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);

begin

    -- 8 registers of 16 bits
    reg0 : reg16bits port map(clk => clk, rst => rst, wr_en => '0', data_in => wd3, data_out => data_out0);
    reg1 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => wd3, data_out => data_out1);
    reg2 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => wd3, data_out => data_out2);
    reg3 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => wd3, data_out => data_out3);
    reg4 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => wd3, data_out => data_out4);
    reg5 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => wd3, data_out => data_out5);
    reg6 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => wd3, data_out => data_out6);
    reg7 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => wd3, data_out => data_out7);

    -- Start of Read Logic
    -- Selects which register has it's output at RD1
    -- Register 0 always outputs 0
    rd1 <= x"0000" when a1 = "000" else
        data_out1 when a1 = "001" else
        data_out2 when a1 = "010" else
        data_out3 when a1 = "011" else
        data_out4 when a1 = "100" else
        data_out5 when a1 = "101" else
        data_out6 when a1 = "110" else
        data_out7 when a1 = "111" else
        x"0000";

    rd2 <= x"0000" when a2 = "000" else
        data_out1 when a2 = "001" else
        data_out2 when a2 = "010" else
        data_out3 when a2 = "011" else
        data_out4 when a2 = "100" else
        data_out5 when a2 = "101" else
        data_out6 when a2 = "110" else
        data_out7 when a2 = "111" else
        x"0000";

    -- Cannot write to Register 0
    wr_en1 <= '1' when a3 = "001" and we3 = '1' else
        '0';
    wr_en2 <= '1' when a3 = "010" and we3 = '1' else
        '0';
    wr_en3 <= '1' when a3 = "011" and we3 = '1' else
        '0';
    wr_en4 <= '1' when a3 = "100" and we3 = '1' else
        '0';
    wr_en5 <= '1' when a3 = "101" and we3 = '1' else
        '0';
    wr_en6 <= '1' when a3 = "110" and we3 = '1' else
        '0';
    wr_en7 <= '1' when a3 = "111" and we3 = '1' else
        '0';
end architecture;