-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_regs is
    port (
        clk                      : in std_logic;              -- clock
        rst                      : in std_logic;              -- reset
        read_addr_1, read_addr_2 : in unsigned(2 downto 0);   -- 2 addresses to read
        read_data_1, read_data_2 : out unsigned(23 downto 0); -- Data from register 1
        write_addr               : in unsigned(2 downto 0);   -- address to write in
        write_en                 : in std_logic;              -- write enable
        write_data               : in unsigned(23 downto 0);  -- data to write
        use_imm                  : in std_logic;              -- selector to choose whether the data from the 2nd operator will come from a register or imm 
        imm                      : in unsigned(23 downto 0);  -- immediate: constant value
        ula_out                  : out unsigned(23 downto 0); -- result of the operation
        ula_op                   : in unsigned(1 downto 0);   -- operation selector
        ula_flag                 : out std_logic              -- ULA flag
    );
end entity;

architecture a_ula_regs of ula_regs is

    -- Register file
    component register_file
        port (
            clk                      : in std_logic;              -- Clock
            rst                      : in std_logic;              -- Reset
            read_addr_1, read_addr_2 : in unsigned(2 downto 0);   -- Address of the registers that we will read
            read_data_1, read_data_2 : out unsigned(23 downto 0); -- Data read from the 1st and the 2nd registers
            write_addr               : in unsigned(2 downto 0);   -- Address of the register in which we will write 
            write_data               : in unsigned(23 downto 0);  -- Write data
            write_en                 : in std_logic               -- Write enable
        );
    end component;

    -- ULA
    component ula
        port (
            in_A, in_B : in unsigned(23 downto 0);  -- Data inputs 
            op         : in unsigned(1 downto 0);   -- Defines the operation
            out_s      : out unsigned(23 downto 0); -- Result of the operation
            flag       : out std_logic              -- Flag
        );
    end component;

    signal reg_write_data         : unsigned(23 downto 0);
    signal reg_write_addr         : unsigned(2 downto 0);
    signal reg_data_1, reg_data_2 : unsigned(23 downto 0);
    signal reg_addr_1, reg_addr_2 : unsigned(2 downto 0);
    signal ula_in_1, ula_in_2     : unsigned(23 downto 0);

begin
    regs : register_file port map(
        clk         => clk,
        rst         => rst,
        read_data_1 => reg_data_1,
        read_data_2 => reg_data_2,
        read_addr_1 => reg_addr_1,
        read_addr_2 => reg_addr_2,
        write_addr  => write_addr,
        write_data  => write_data,
        write_en    => write_en
    );

    alu : ula port map(
        in_A  => ula_in_1,
        in_B  => ula_in_2,
        op    => ula_op,
        out_s => ula_out,
        flag  => ula_flag
    );

    -- Map signals to the output ports
    read_data_1 <= reg_data_1;
    read_data_2 <= reg_data_2;

    -- ULA Inputs
    ula_in_1    <= reg_data_1;
    ula_in_2    <= imm when use_imm = '1' else
        reg_data_2;

end architecture;