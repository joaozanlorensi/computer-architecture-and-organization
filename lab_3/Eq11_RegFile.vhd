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

    -- Logica de leitura:
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
    signal data_in0, data_in1, data_in2, data_in3, data_in4, data_in5, data_in6, data_in7         : unsigned(15 downto 0);
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);

    component mux8x1 is
        port (
            in_0, in_1, in_3, in_4, in_5, in_6, in_7 : in unsigned(15 downto 0);
            sel                                      : in unsigned(2 downto 0);
            en                                       : in std_logic;
            result                                   : out unsigned(15 downto 0)
        );
    end component;
    signal en : std_logic;

begin

    reg0 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en0, data_in => data_in0, data_out => data_out0);
    reg1 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => data_in1, data_out => data_out1);
    reg2 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => data_in2, data_out => data_out2);
    reg3 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => data_in3, data_out => data_out3);
    reg4 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => data_in4, data_out => data_out4);
    reg5 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => data_in5, data_out => data_out5);
    reg6 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => data_in6, data_out => data_out6);
    reg7 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => data_in7, data_out => data_out7);

    mux1 : mux8x1 port map(
        in_0   => data_out0,
        in_1   => data_out1,
        in_2   => data_out2,
        in_3   => data_out3,
        in_4   => data_out4,
        in_5   => data_out5,
        in_6   => data_out6,
        in_7   => data_out1,
        sel    => a1,
        en     => not we3,
        result => rd1
    );
    mux2 : mux8x1 port map(
        in_0   => data_out0,
        in_1   => data_out1,
        in_2   => data_out2,
        in_3   => data_out3,
        in_4   => data_out4,
        in_5   => data_out5,
        in_6   => data_out6,
        in_7   => data_out1,
        sel    => a2,
        en     => not we3,
        result => rd2
    );
    -- Final da logica de leitura

    -- Logica de escrita

    -- Final da logica de escrita
end architecture;