library ieee;
use ieee.std_logic_1164.all;  -- Biblioteca para tipos std_logic e std_logic_vector
use ieee.numeric_std.all;     -- Biblioteca para conversões e operações aritméticas em tipos numéricos

entity a009d_decod is
    port(
        contador : in  integer range 0 to 60;       -- Entrada do valor a ser decodificado (0–60)
        d0, d1   : out std_logic_vector(0 to 6)     -- Saídas para segmentos dos displays (unidade e dezena)
    );
end entity;

architecture rtl of a009d_decod is
    -- Função que recebe um valor decimal e retorna o vetor de segmentos para display 7 segmentos
    function decodificando(valor: integer) return std_logic_vector is
        variable saida : std_logic_vector(0 to 6);  -- Vetor que representa segmentos a–g do display
    begin
        case valor is
            when 0  => saida := not "1111110"; -- Segmentos a,b,c,d,e,f on e g off
            when 1  => saida := not "0110000"; -- Segmentos b,c on
            when 2  => saida := not "1101101"; -- Segmentos a,b,d,e,g on
            when 3  => saida := not "1111001"; -- Segmentos a,b,c,d,g on
            when 4  => saida := not "0110011"; -- Segmentos b,c,f,g on
            when 5  => saida := not "1011011"; -- Segmentos a,c,d,f,g on
            when 6  => saida := not "1011111"; -- Segmentos a,c,d,e,f,g on
            when 7  => saida := not "1110000"; -- Segmentos a,b,c on
            when 8  => saida := not "1111111"; -- Todos segmentos on
            when 9  => saida := not "1111011"; -- Segmentos a,b,c,d,f,g on
            when others => saida := "0000000"; -- Desliga todos segmentos para valores fora do intervalo
        end case;
        return saida;  -- Retorna o padrão de segmentos invertido (ativo baixo)
    end decodificando;

begin
    -- Processo sensível somente à mudança de 'contador'
    process(contador) is
        variable dezena, unidade : integer range 0 to 60;  -- Variáveis auxiliares para decompor o valor em dígitos
    begin
        -- Calcula dígito das dezenas e das unidades a partir do contador
        dezena   := contador / 10;   -- Divide por 10 para obter as dezenas
        unidade  := contador mod 10; -- Resto da divisão por 10 para as unidades

        -- Chama a função para obter os vetores de segmentos
        d1 <= decodificando(dezena);   -- Exibe no display de dezenas
        d0 <= decodificando(unidade);  -- Exibe no display de unidades
    end process;

end architecture;

-- Fim do decodificador de displays a009d_decod.vhd
