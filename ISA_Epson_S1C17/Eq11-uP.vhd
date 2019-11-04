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
            instruction    : in unsigned(15 downto 0);
            clk            : in std_logic;
            rst            : in std_logic;
            state          : out unsigned(1 downto 0);
            jump_en        : out std_logic;
            ula_op_control : out unsigned(1 downto 0);
            pc_wr_en       : out std_logic;
            regs_wr_en     : out std_logic;
            regs_wr_sel    : out std_logic;
            reg1_sel       : out unsigned(2 downto 0);
            reg2_sel       : out unsigned(2 downto 0);
            imm            : out unsigned(6 downto 0);
            regs_wr_addr   : out unsigned(2 downto 0)
        );
    end component;

    -- ULA + RegFile
    component ularegs is
        port (
            ra1, ra2 : in unsigned(2 downto 0);   -- 2 addresses to read
            wa3      : in unsigned(2 downto 0);   -- address to write in
            wen      : in std_logic;              -- write enable
            data_in  : in unsigned(23 downto 0);  -- data to write
            sel      : in std_logic;              -- selector to choose whether the data from the 2nd operator will come from a register or imm 
            imm      : in unsigned(23 downto 0);  -- immediate: constant value
            rst      : in std_logic;              -- reset
            clk      : in std_logic;              -- clock
            op       : in unsigned(1 downto 0);   -- operation selector
            rd1      : out unsigned(23 downto 0); -- Data from register 1
            rd2      : out unsigned(23 downto 0); -- Data from register 2
            data_out : out unsigned(23 downto 0); -- result of the operation
            flag     : out std_logic              -- flag
        );
    end component;

    -- UC signals
    signal state       : unsigned(1 downto 0);
    signal imm         : unsigned(6 downto 0);
    signal pc_wr_en    : std_logic;
    signal regs_wr_en  : std_logic;
    signal regs_wr_sel : std_logic;
    signal reg1_sel    : unsigned(2 downto 0);
    signal reg2_sel    : unsigned(2 downto 0);
    signal jump_en     : std_logic;

    -- PC signals
    signal pc_out : unsigned(6 downto 0);
    signal pc_in  : unsigned(6 downto 0);

    -- ROM signals
    signal rom_out : unsigned(15 downto 0);

    -- ULA + RegFile signals
    signal reg1_data  : unsigned(23 downto 0);
    signal reg2_data  : unsigned(23 downto 0);
    signal reg1_addr  : unsigned(2 downto 0);
    signal reg2_addr  : unsigned(2 downto 0);
    signal write_data : unsigned(23 downto 0);
    signal ula_imm    : unsigned(23 downto 0);
    signal sel        : std_logic;
    signal write_addr : unsigned(2 downto 0);
    signal op         : unsigned(1 downto 0);
    signal ula_out    : unsigned(23 downto 0);
    signal flag       : std_logic;

    signal jump_addr : unsigned(6 downto 0);

begin
    inner_pc : pc port map(
        clk      => clk,
        rst      => rst,
        wr_en    => pc_wr_en,
        data_in  => pc_in,
        data_out => pc_out
    );
    inner_rom : rom port map(
        clk     => clk,
        address => pc_out,
        data    => rom_out
    );

    inner_uc : uc port map(
        instruction => rom_out,
        clk         => clk,
        rst         => rst,
        state       => state,
        pc_wr_en    => pc_wr_en,
        jump_en     => jump_en,
        regs_wr_en  => regs_wr_en,
        regs_wr_sel => regs_wr_sel,
        reg1_sel    => reg1_sel,
        reg2_sel    => reg2_sel,
        imm         => imm
    );
    inner_ularegs : ularegs port map(
        ra1      => reg1_addr,
        ra2      => reg2_addr,
        wa3      => write_addr,
        wen      => regs_wr_en,
        data_in  => write_data,
        sel      => sel,
        imm      => ula_imm,
        rst      => rst,
        clk      => clk,
        op       => op,
        rd1      => reg1_data,
        rd2      => reg2_data,
        data_out => ula_out,
        flag     => flag
    );

    ula_imm <= x"0000" & "0" & imm when imm(6) = '0' else
        x"FFFF" & "1" & imm;

    -- Jump address 
    jump_addr <= rom_out(6 downto 0) when jump_en = '1' else
        "0000000";

    -- PC input
    pc_in <= pc_out + 1 when jump_en = '0' else
        jump_addr;

    write_data <= ula_out when regs_wr_sel = '0' else
        ula_imm when regs_wr_sel = '1'
        else
        x"000000";

end architecture;