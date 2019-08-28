-- Lab 1 - ULA (S11)
-- Students: Francisco Miamoto
--           João Pedro Zanlorensi Cardoso
--           Luan Roberto Estrada Martins
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
    component ula --Aqui fiquei em duvida se eh o nome do arquivo ou o nome da entidade
        port (
            in_A, in_B : in unsigned(15 downto 0);
            op         : in unsigned(1 downto 0);
            out_s      : out unsigned(15 downto 0);
            flag       : out std_logic
    );
    end component; --Esta sessao indica que vamos usar um componente do outro arquivo
    -- Eh necessario utilizar a mesma estrutura do outro arquivo

--Sinais a serem definidos
    signal flag                     :   std_logic; 
    signal in_A, in_B, out_s        :   unsigned(15 downto 0);
    signal op                       :   unsigned(1 downto 0);
--Inseri um s na frente de todas as variaveis para dizer que estas sao sinais e nao portas

    begin
        utt: ula port map(
            in_A    =>  in_A,
            in_B    =>  in_B,
            op      =>  op,
            out_s   =>  out_s
        );

end architecture;