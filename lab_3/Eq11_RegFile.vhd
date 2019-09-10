-- Lab 2 - Register File (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port (
        a1, a2   : in unsigned(2 downto 0);  -- Address of the registers that we will read
        a3       : in unsigned(2 downto 0);  -- Address of the register in which we will write 
        wd3      : in unsigned(15 downto 0); -- Write data
        we3      : in std_logic;             -- Write enable
        clk      : in std_logic;             -- Clock
        rst      : in std_logic;             -- Reset
        rd1, rd2 : out unsigned(15 downto 0) -- Data read from the 1st and the 2nd registers
    );
end entity;

architecture a_register_file of register_file is
    component reg16bits is
        port (
            clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(15 downto 0);
            data_out : out unsigned(15 downto 0)
        );
    end component;

    signal wr_en0, wr_en1, wr_en2, wr_en3, wr_en4, wr_en5, wr_en6, wr_en7                         : std_logic;
    signal data_in0, data_in1, data_in2, data_in3, data_in4, data_in5, data_in6, data_in7         : unsigned(15 downto 0);
    signal data_out0, data_out1, data_out2, data_out3, data_out4, data_out5, data_out6, data_out7 : unsigned(15 downto 0);

begin

    -- 8 registers of 16 bits
    reg0 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en0, data_in => data_in0, data_out => data_out0);
    reg1 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en1, data_in => data_in1, data_out => data_out1);
    reg2 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en2, data_in => data_in2, data_out => data_out2);
    reg3 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en3, data_in => data_in3, data_out => data_out3);
    reg4 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en4, data_in => data_in4, data_out => data_out4);
    reg5 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en5, data_in => data_in5, data_out => data_out5);
    reg6 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en6, data_in => data_in6, data_out => data_out6);
    reg7 : reg16bits port map(clk => clk, rst => rst, wr_en => wr_en7, data_in => data_in7, data_out => data_out7);

    -- Register 0 receives 0x0000 
    process
    begin
        data_in0 <= x"0000";
        wr_en0   <= '1';
        wait for 5 ns;
        wr_en0 <= '0';
        wait;
    end process;

    -- Start of Read Logic
    -- Selects which register has it's output at RD1
    process (clk)
    begin
        if rising_edge(clk) then
            case a1 is
                when "000"  => rd1  <= data_out0;
                when "001"  => rd1  <= data_out1;
                when "010"  => rd1  <= data_out2;
                when "011"  => rd1  <= data_out3;
                when "100"  => rd1  <= data_out4;
                when "101"  => rd1  <= data_out5;
                when "110"  => rd1  <= data_out6;
                when "111"  => rd1  <= data_out7;
                when others => rd1 <= x"0000";
            end case;
        end if;
    end process;

    -- Selects which register has it's output at RD2
    process (clk)
    begin
        if rising_edge(clk) then
            case a2 is
                when "000"  => rd2  <= data_in0;
                when "001"  => rd2  <= data_in1;
                when "010"  => rd2  <= data_in2;
                when "011"  => rd2  <= data_in3;
                when "100"  => rd2  <= data_in4;
                when "101"  => rd2  <= data_in5;
                when "110"  => rd2  <= data_in6;
                when "111"  => rd2  <= data_in7;
                when others => rd2 <= x"0000";
            end case;
        end if;
    end process;
    -- End of read logic

    -- Start of write logic
    process (clk)
    begin
        if we3 = '1' and rising_edge(clk) then
            -- Selects which register will receive the write data
            -- to it's input and then enables the write
            if a3 = "001" then
                data_in1 <= wd3;
                wr_en1   <= '1';
            elsif a3 = "010" then
                data_in2 <= wd3;
                wr_en2   <= '1';
            elsif a3 = "011" then
                data_in3 <= wd3;
                wr_en3   <= '1';
            elsif a3 = "100" then
                data_in4 <= wd3;
                wr_en4   <= '1';
            elsif a3 = "101" then
                data_in5 <= wd3;
                wr_en5   <= '1';
            elsif a3 = "110" then
                data_in6 <= wd3;
                wr_en6   <= '1';
            elsif a3 = "111" then
                data_in7 <= wd3;
                wr_en7   <= '1';
            end if;
        elsif we3 = '0' and rising_edge(clk) then
            wr_en1 <= '0';
            wr_en2 <= '0';
            wr_en3 <= '0';
            wr_en4 <= '0';
            wr_en5 <= '0';
            wr_en6 <= '0';
            wr_en7 <= '0';
        end if;
    end process;
    -- End of write logic

end architecture;