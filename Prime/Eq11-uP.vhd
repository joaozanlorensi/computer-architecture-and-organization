-- Lab 8 - Prime
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
    -- Main memory (RAM)
    component ram is
        port (
            clk      : in std_logic;
            address  : in unsigned(6 downto 0);
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

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

    -- Flags
    component flags is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(5 downto 0);
            data_out : out unsigned(5 downto 0)
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
            jump_rel_en        : out std_logic;
            ula_op_control     : out unsigned(1 downto 0);
            pc_write_en        : out std_logic;
            reg_write_en       : out std_logic;
            reg_write_addr     : out unsigned(2 downto 0);
            reg_write_data_sel : out unsigned(1 downto 0);
            reg_addr_1         : out unsigned(2 downto 0);
            reg_addr_2         : out unsigned(2 downto 0);
            imm                : out unsigned(6 downto 0);
            use_imm            : out std_logic;
            flags_data_out     : in unsigned(5 downto 0);
            flags_write_en     : out std_logic;
            ram_write_en       : out std_logic
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

    component reg24bits
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(23 downto 0);
            data_out : out unsigned(23 downto 0)
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
    signal jump_rel_en    : std_logic;
    signal regs_wr_addr   : unsigned(2 downto 0);
    signal ula_op_control : unsigned(1 downto 0);

    -- PC signals
    signal pc_out         : unsigned(6 downto 0);
    signal pc_in          : unsigned(6 downto 0);

    -- Flag signals
    signal flags_write_en : std_logic;
    signal flags_data_in  : unsigned (5 downto 0);
    signal flags_data_out : unsigned(5 downto 0);

    -- ROM signals
    signal rom_out        : unsigned(15 downto 0);

    -- ULA signals
    signal ula_in_1       : unsigned(23 downto 0);
    signal ula_in_2       : unsigned(23 downto 0);

    -- ULA + RegFile signals
    signal reg_data_1     : unsigned(23 downto 0);
    signal reg_data_2     : unsigned(23 downto 0);
    signal write_data     : unsigned(23 downto 0);
    signal ula_imm        : unsigned(23 downto 0);
    signal use_imm        : std_logic;
    signal write_addr     : unsigned(2 downto 0);
    signal op             : unsigned(1 downto 0);
    signal ula_out        : unsigned(23 downto 0);
    signal flag           : std_logic;

    signal jump_addr      : unsigned(6 downto 0);

    signal ram_in         : unsigned(15 downto 0);
    signal ram_out        : unsigned(15 downto 0);
    signal ram_out_ext    : unsigned(23 downto 0);
    signal ram_wr_en      : std_logic;
    signal ram_addr       : unsigned(6 downto 0);

begin
    -- Main memory (RAM)
    inner_ram : ram port map(
        clk      => clk,
        address  => ram_addr,
        wr_en    => ram_wr_en,
        data_in  => ram_in,
        data_out => ram_out
    );

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
        jump_rel_en        => jump_rel_en,
        ula_op_control     => ula_op_control,
        pc_write_en        => pc_wr_en,
        reg_write_en       => regs_wr_en,
        reg_write_addr     => regs_wr_addr,
        reg_write_data_sel => regs_wr_sel,
        reg_addr_1         => reg_addr_1,
        reg_addr_2         => reg_addr_2,
        imm                => imm,
        use_imm            => use_imm,
        flags_write_en     => flags_write_en,
        flags_data_out     => flags_data_out,
        ram_write_en       => ram_wr_en
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

    -- Flags register
    inner_flags : flags port map(
        clk      => clk,
        rst      => rst,
        wr_en    => flags_write_en,
        data_in  => flags_data_in,
        data_out => flags_data_out
    );

    -- ALU inputs
    ula_in_1 <= reg_data_1;
    ula_in_2 <= ula_imm when use_imm = '1' else
        reg_data_2;

    -- ALU immediate with sign extend
    ula_imm <= x"0000" & "0" & imm when imm(6) = '0' else
        x"FFFF" & "1" & imm;

    -- Jump address 
    jump_addr <= imm when jump_en = '1' or jump_rel_en = '1' else
        "0000000";

    -- PC input
    pc_in <= jump_addr when jump_en = '1' and jump_rel_en = '0' else
        pc_out + jump_addr when jump_en = '0' and jump_rel_en = '1' else
        pc_out + 1; -- ANCHOR relative jump 

    -- RAM input with sign extend
    -- ram_in <= imm & "000000000" when ram_wr_en = '1' else
    --     "0000000000000000";
    ram_in      <= reg_data_1(15 downto 0);
    ram_addr    <= reg_data_2(6 downto 0);
    ram_out_ext <= "11111111" & ram_out when ram_out(15) = '1' else
        "00000000" & ram_out;

    write_data <= ula_out when regs_wr_sel = "00" else
        ula_imm when regs_wr_sel = "01" else
        reg_data_2 when regs_wr_sel = "10" else
        ram_out_ext when regs_wr_sel = "11"
        else
        x"000000";

    flags_data_in <= "000001" when ula_out(23) = '1' else -- Negative
        "000010" when ula_out = x"000000" else                -- Zero
        "000000";

end architecture;