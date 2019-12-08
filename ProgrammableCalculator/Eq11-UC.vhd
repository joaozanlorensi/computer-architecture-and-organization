-- Lab 5 - "Programmable calculator"
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi
--           Luan Roberto

-- TODO: Decode ROM instructions

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uc is
    port (
        instruction : in unsigned(15 downto 0);
        clk : in std_logic;
        rst : in std_logic;
        state : out unsigned(1 downto 0);
        jump_en : out std_logic;

        ula_op_control : out unsigned(1 downto 0); -- ANCHOR
        pc_wr_en : out std_logic;
        regs_wr_en : out std_logic;
        regs_wr_sel : out unsigned(1 downto 0);
        reg1_sel : out unsigned(2 downto 0);
        reg2_sel : out unsigned(2 downto 0);
        imm : out unsigned(6 downto 0);
        regs_wr_addr : out unsigned(2 downto 0)
    );
end entity;

architecture a_uc of uc is
    signal state_s : unsigned(1 downto 0);
    signal opcode : unsigned(5 downto 0);
    signal opcode_ext : unsigned(3 downto 0);
begin
    -- Fetch, Decode, Execute states
    -- 00 = fetch
    -- 01 = decode
    -- 10 = execute
    process (clk, rst)
    begin
        if rst = '1' then
            state_s <= "00";
        elsif rising_edge(clk) then
            if state_s = "10" then
                state_s <= "00";
            else
                state_s <= state_s + 1;
            end if;
        end if;
    end process;

    -- Exposes internal state via state pin
    state <= state_s;

    opcode <= instruction(15 downto 10);
    opcode_ext <= instruction(6 downto 3);

    -- Decode registers
    regs_wr_addr <= instruction(9 downto 7);
    reg1_sel <= instruction(9 downto 7);
    reg2_sel <= instruction(2 downto 0);

    -- Verifies if data comes from imm or reg (1 = imm, 0 = reg)
    regs_wr_sel <= "01" when opcode = "100110" else
                "10" when opcode = "001010" else
        "00";

    -- "time to opperate with imm/reg"
    regs_wr_en <= '1' when opcode = "100110" and state_s = "10" else
        '1' when opcode = "001100" and state_s = "10" else
        '1' when opcode = "001010" and state_s = "10" else
        '0';

    -- Decode immediate value
    imm <= instruction(6 downto 0);

    -- TODO: decode jump instruction
    jump_en <= '1' when opcode = "000000" else
        '0';

    pc_wr_en <= '1' when state_s = "01" else
        '0';

    ula_op_control <= "00" when opcode = "001100" and opcode_ext = "1000" else
        "01" when opcode = "001100" and opcode_ext = "1010" else
        "00";

end architecture;