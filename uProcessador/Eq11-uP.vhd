-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uprocessor is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity;

architecture a_uprocessor of uprocessor is
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
            data    : out unsigned(15 downto 0)
        );
    end component;

    -- Control unit
    component uc is
        port (
            clk                : in std_logic;
            rst                : in std_logic;
            rom_out            : in unsigned(15 downto 0);
            jump_en            : out std_logic;
            ula_op_control     : out unsigned(1 downto 0);
            pc_write_en        : out std_logic;
            reg_write_en       : out std_logic;
            reg_write_addr     : out unsigned(2 downto 0);
            reg_write_data_sel : out unsigned(1 downto 0);
            reg_addr_1         : out unsigned(2 downto 0);
            reg_addr_2         : out unsigned(2 downto 0);
            imm                : out unsigned(6 downto 0)
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

    -- UC signals
    signal imm            : unsigned(6 downto 0);
    signal pc_wr_en       : std_logic;
    signal regs_wr_en     : std_logic;
    signal regs_wr_sel    : unsigned(1 downto 0);
    signal reg_addr_1     : unsigned(2 downto 0);
    signal reg_addr_2     : unsigned(2 downto 0);
    signal jump_en        : std_logic;
    signal regs_wr_addr   : unsigned(2 downto 0);
    signal ula_op_control : unsigned(1 downto 0);

    -- PC signals
    signal pc_out : unsigned(6 downto 0);
    signal pc_in  : unsigned(6 downto 0);

    -- ROM signals
    signal rom_out : unsigned(15 downto 0);

    -- ULA signals
    signal ula_in_1 : unsigned(23 downto 0);
    signal ula_in_2 : unsigned(23 downto 0);

    -- ULA + RegFile signals
    signal reg_data_1 : unsigned(23 downto 0);
    signal reg_data_2 : unsigned(23 downto 0);
    signal write_data : unsigned(23 downto 0);
    signal ula_imm    : unsigned(23 downto 0);
    signal use_imm    : std_logic;
    signal write_addr : unsigned(2 downto 0);
    signal op         : unsigned(1 downto 0);
    signal ula_out    : unsigned(23 downto 0);
    signal flag       : std_logic;

    signal jump_addr : unsigned(6 downto 0);

begin
    -- Program counter
    inner_pc : pc port map(
        clk      => clk,
        rst      => rst,
        wr_en    => pc_wr_en,
        data_in  => pc_in,
        data_out => pc_out
    );

    -- ROM 
    inner_rom : rom port map(
        clk     => clk,
        address => pc_out,
        data    => rom_out
    );

    -- Control unit
    inner_uc : uc port map(
        clk                => clk,
        rst                => rst,
        rom_out            => rom_out,
        jump_en            => jump_en,
        ula_op_control     => ula_op_control,
        pc_write_en        => pc_wr_en,
        reg_write_en       => regs_wr_en,
        reg_write_addr     => regs_wr_addr,
        reg_write_data_sel => regs_wr_sel,
        reg_addr_1         => reg_addr_1,
        reg_addr_2         => reg_addr_2,
        imm                => imm
    );

    -- Register file
    inner_regfile : register_file port map(
        clk         => clk,
        rst         => rst,
        read_addr_1 => reg_addr_1,
        read_addr_2 => reg_addr_2,
        read_data_1 => reg_data_1,
        read_data_2 => reg_data_2,
        write_addr  => regs_wr_addr,
        write_data  => write_data,
        write_en    => regs_wr_en
    );

    -- ALU
    inner_ula : ula port map(
        in_A  => ula_in_1,
        in_B  => ula_in_2,
        op    => ula_op_control,
        out_s => ula_out,
        flag  => flag
    );

    -- ALU inputs
    ula_in_1 <= reg_data_1;
    ula_in_2 <= ula_imm when use_imm = '1' else
        reg_data_2;

    -- ALU immediate with sign extend
    ula_imm <= x"0000" & "0" & imm when imm(6) = '0' else
        x"FFFF" & "1" & imm;

    -- Jump address 
    jump_addr <= imm when jump_en = '1' else
        "0000000";

    -- PC input
    pc_in <= pc_out + 1 when jump_en = '0' else
        jump_addr;

    write_data <= ula_out when regs_wr_sel = "00" else
        ula_imm when regs_wr_sel = "01" else
        reg_data_2 when regs_wr_sel = "10"
        else
        x"000000";

    use_imm <= '0';

end architecture;