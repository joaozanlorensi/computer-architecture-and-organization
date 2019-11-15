
-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
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
        flags_write_en     : out std_logic;
        flags_data_out     : in unsigned(5 downto 0)
    );
end entity;

architecture a_uc of uc is
    signal state      : unsigned(1 downto 0);
    signal opcode     : unsigned(5 downto 0);
    signal opcode_ext : unsigned(3 downto 0);
begin
    -- Fetch, Decode, Execute states
    -- 00 = fetch
    -- 01 = decode
    -- 10 = execute
    process (clk, rst)
    begin
        if rst = '1' then
            state <= "00";
        elsif rising_edge(clk) then
            if state = "10" then
                state <= "00";
            else
                state <= state + 1;
            end if;
        end if;
    end process;

    opcode     <= rom_out(15 downto 10);
    opcode_ext <= rom_out(6 downto 3);

    -- Decode registers
    reg_write_addr <= rom_out(9 downto 7);
    reg_addr_1     <= rom_out(9 downto 7);
    reg_addr_2     <= rom_out(2 downto 0);

    -- Verifies if data comes from imm or reg (1 = imm, 0 = reg)
    reg_write_data_sel <= "01" when opcode = "100110" else
        "10" when opcode = "001010" else
        "00";

    -- "time to opperate with imm/reg"
    reg_write_en <= '1' when opcode = "100110" and state = "10" else
        '1' when opcode = "001100" and state = "10" else
        '1' when opcode = "001010" and state = "10" else
        '0';

    -- Decode immediate value
    imm <= rom_out(6 downto 0);

    jump_en <= '1' when opcode = "000000" else
        '0';

    pc_write_en <= '1' when state = "01" else
        '0';

    ula_op_control <= "00" when opcode = "001100" and opcode_ext = "1000" else -- ADD opcode
        "01" when opcode = "001100" and opcode_ext = "1010" else                   -- SUB opcode
        "01" when opcode = "100100" else                                           -- CMP opcode
        "00";

    use_imm <= '1' when opcode = "100100" else
        '0';

    -- Relative jump enable
    jump_rel_en <= '1' when opcode = "000010" and flags_data_out(0) = '1' else -- Less than 
        '0';

    flags_write_en <= '1' when opcode = "100100" and state = "10" else
        '0'; -- CMP opcode

end architecture;