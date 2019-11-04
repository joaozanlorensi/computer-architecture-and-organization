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
end entity;

architecture a_uc of uc is
    signal state_s : unsigned(1 downto 0);
    signal opcode  : unsigned(5 downto 0);
begin
    -- Fetch, Decode, Execute states
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

    -- Decode registers
    reg1_sel <= instruction(9 downto 7);
    reg2_sel <= instruction(2 downto 0);

    regs_wr_sel <= '1' when opcode = "100110" else
        '0';

    regs_wr_en <= '1' when opcode = "100110" and state_s = "10" else
        '0';

    -- Decode immediate value
    imm <= instruction(6 downto 0);

    jump_en <= '1' when state_s = "01" and opcode = "1111" else
        '0';

    pc_wr_en <= '1' when state_s = "01" else
        '0';

end architecture;