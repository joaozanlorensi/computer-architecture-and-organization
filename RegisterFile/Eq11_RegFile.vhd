-- Lab 2 - Register File (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins

--Multiplos Arquivos Fonte:
--Este se refere a criacao de 8 registradores com base no registrador base

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
    port (

        rst0, rst1, rst2, rs3, rst4, rst5, rst6, rst7                  : in std_logic;
        wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7 : in std_logic;
        a1, a2, a3                                                     : in unsigned(2 downto 0);
        clk, we3                                                       : in std_logic;
        rst                                                            : in std_logic; --Para zerar todos os registradores
        wd3                                                            : in unsigned(15 downto 0); --Dado de entrada para gravar
        rd1, rd2                                                       : out unsigned(15 downto 0)

    );
end entity

architecture a_regfile of regfile is
    component reg16bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;
begin
    reg0 : reg16bits port map(rst => rst0, wr_en => wr_en0, clk => clk);
    reg1 : reg16bits port map(rst => rst1, wr_en => wr_en1, clk => clk);
    reg2 : reg16bits port map(rst => rst2, wr_en => wr_en2, clk => clk);
    reg3 : reg16bits port map(rst => rst3, wr_en => wr_en3, clk => clk);
    reg4 : reg16bits port map(rst => rst4, wr_en => wr_en4, clk => clk);
    reg5 : reg16bits port map(rst => rst5, wr_en => wr_en5, clk => clk);
    reg6 : reg16bits port map(rst => rst6, wr_en => wr_en6, clk => clk);
    reg7 : reg16bits port map(rst => rst7, wr_en => wr_en7, clk => clk);
end architecture;