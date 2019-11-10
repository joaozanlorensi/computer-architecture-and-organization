-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        clk                      : in std_logic;              -- Clock
        rst                      : in std_logic;              -- Reset
        read_addr_1, read_addr_2 : in unsigned(2 downto 0);   -- Address of the registers that we will read
        read_data_1, read_data_2 : out unsigned(23 downto 0); -- Data read from the 1st and the 2nd registers
        write_addr               : in unsigned(2 downto 0);   -- Address of the register in which we will write 
        write_data               : in unsigned(23 downto 0);  -- Write data
        write_en                 : in std_logic               -- Write enable
    );
end entity;

architecture a_register_file of register_file is
    component reg24bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(23 downto 0);
            data_out : out unsigned(23 downto 0)
        );
    end component;

    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7                         : std_logic;
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(23 downto 0);

begin

    -- 8 registers of 24 bits
    reg0 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en0, data_in => write_data, data_out => data_out0);
    reg1 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => write_data, data_out => data_out1);
    reg2 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => write_data, data_out => data_out2);
    reg3 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => write_data, data_out => data_out3);
    reg4 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => write_data, data_out => data_out4);
    reg5 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => write_data, data_out => data_out5);
    reg6 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => write_data, data_out => data_out6);
    reg7 : reg24bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => write_data, data_out => data_out7);

    -- Start of Read Logic
    -- Selects which register has it's output at RD1
    -- Register 0 always outputs 0
    read_data_1 <= data_out0 when read_addr_1 = "000" else
        data_out1 when read_addr_1 = "001" else
        data_out2 when read_addr_1 = "010" else
        data_out3 when read_addr_1 = "011" else
        data_out4 when read_addr_1 = "100" else
        data_out5 when read_addr_1 = "101" else
        data_out6 when read_addr_1 = "110" else
        data_out7 when read_addr_1 = "111" else
        x"000000";

    read_data_2 <= data_out0 when read_addr_2 = "000" else
        data_out1 when read_addr_2 = "001" else
        data_out2 when read_addr_2 = "010" else
        data_out3 when read_addr_2 = "011" else
        data_out4 when read_addr_2 = "100" else
        data_out5 when read_addr_2 = "101" else
        data_out6 when read_addr_2 = "110" else
        data_out7 when read_addr_2 = "111" else
        x"000000";

    wr_en0 <= '1' when write_addr = "000" and write_en = '1' else
        '0';
    wr_en1 <= '1' when write_addr = "001" and write_en = '1' else
        '0';
    wr_en2 <= '1' when write_addr = "010" and write_en = '1' else
        '0';
    wr_en3 <= '1' when write_addr = "011" and write_en = '1' else
        '0';
    wr_en4 <= '1' when write_addr = "100" and write_en = '1' else
        '0';
    wr_en5 <= '1' when write_addr = "101" and write_en = '1' else
        '0';
    wr_en6 <= '1' when write_addr = "110" and write_en = '1' else
        '0';
    wr_en7 <= '1' when write_addr = "111" and write_en = '1' else
        '0';
end architecture;