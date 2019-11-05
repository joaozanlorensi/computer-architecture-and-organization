-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto

-- TODO: Connect UC to ULARegs
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

    -- ULA + RegFile
    component ula_regs is
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
    end component;

    -- UC signals
    signal state          : unsigned(1 downto 0);
    signal imm            : unsigned(6 downto 0);
    signal pc_wr_en       : std_logic;
    signal regs_wr_en     : std_logic;
    signal regs_wr_sel    : unsigned(1 downto 0);
    signal reg1_sel       : unsigned(2 downto 0);
    signal reg2_sel       : unsigned(2 downto 0);
    signal jump_en        : std_logic;
    signal regs_wr_addr   : unsigned(2 downto 0);
    signal ula_op_control : unsigned(1 downto 0);

    -- PC signals
    signal pc_out         : unsigned(6 downto 0);
    signal pc_in          : unsigned(6 downto 0);

    -- ROM signals
    signal rom_out        : unsigned(15 downto 0);

    -- ULA + RegFile signals
    signal reg1_data      : unsigned(23 downto 0);
    signal reg2_data      : unsigned(23 downto 0);
    signal reg1_addr      : unsigned(2 downto 0);
    signal reg2_addr      : unsigned(2 downto 0);
    signal write_data     : unsigned(23 downto 0);
    signal ula_imm        : unsigned(23 downto 0);
    signal sel            : std_logic;
    signal write_addr     : unsigned(2 downto 0);
    signal op             : unsigned(1 downto 0);
    signal ula_out        : unsigned(23 downto 0);
    signal flag           : std_logic;

    signal jump_addr      : unsigned(6 downto 0);

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
        reg_addr_1         => reg1_sel,
        reg_addr_2         => reg2_sel,
        imm                => imm
    );

    -- ULA + Register File
    inner_ularegs : ula_regs port map(
        clk         => clk,
        rst         => rst,
        read_addr_1 => reg1_sel,
        read_addr_2 => reg2_sel,
        read_data_1 => reg1_data,
        read_data_2 => reg2_data,
        write_addr  => regs_wr_addr,
        write_en    => regs_wr_en,
        write_data  => write_data,
        use_imm     => sel,
        imm         => ula_imm,
        ula_out     => ula_out,
        ula_op      => ula_op_control,
        ula_flag    => flag
    );

    -- Jump address 
    jump_addr <= imm;

    -- PC input
    pc_in     <= pc_out + 1 when jump_en = '0' else
        jump_addr;

    ula_imm <= x"0000" & "0" & imm when imm(6) = '0' else
        x"FFFF" & "1" & imm;

    -- Jump address 
    jump_addr <= rom_out(6 downto 0) when jump_en = '1' else
        "0000000";

    -- PC input
    pc_in <= pc_out + 1 when jump_en = '0' else
        jump_addr;

    write_data <= ula_out when regs_wr_sel = "00" else
        ula_imm when regs_wr_sel = "01" else
        reg2_data when regs_wr_sel = "10"
        else
        x"000000";

    sel <= '0';

end architecture;