library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port(
        clk      : in std_logic;
        rst      : in std_logic;
        wr_en    : in std_logic;
        data_in  : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );    
    end entity;
    
architecture a_pc of pc is
    signal registro : unsigned(15 downto 0);
    signal contador : unsigned(15 downto 0);
begin
contador <= x"0000";
    process (clk, rst, wr_en)
    begin
        if rst = '1' then
            registro <= x"0000";
        elsif wr_en = '1' then
            if rising_edge(clk) then
                registro <= data_in;
            end if;
        end if;
        contador <= contador + x"0001";
    end process;    
    data_out <= contador;
end architecture;