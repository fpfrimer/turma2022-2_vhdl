-- Este módulo VHDL implementa um registro de deslocamento genérico com
-- tamanho configurável através de um parâmetro genérico 'n'. O registro
-- desloca os bits armazenados para a esquerda em cada borda de subida do clock,
-- introduzindo o novo bit de entrada no lado direito do registro.
-- O bit na posição mais alta é continuamente exposto na saída 'data_out'.

library ieee;
use ieee.std_logic_1164.all;  -- Inclui os tipos de lógica padrão.

entity a008f_generic_shift_reg is
    generic(
        n : integer := 10  -- Número de bits do registro de deslocamento, padrão é 10 bits.
    );
    port(
        clk      : in std_logic;    -- Clock de entrada.
        rst      : in std_logic;    -- Sinal de reset, limpa o registro quando ativo.
        data_in  : in std_logic;    -- Dado de entrada para ser inserido no registro.
        data_out : out std_logic    -- Saída do bit mais significativo do registro.
    );
end a008f_generic_shift_reg;

architecture behavioral of a008f_generic_shift_reg is
    signal temp: std_logic_vector(n - 1 downto 0);  -- Vetor interno para armazenar os bits do registro.
begin
    process(clk, rst)
    begin
        if rst = '1' then
            temp <= (others => '0');  -- Inicializa todos os bits de 'temp' com 0 quando 'rst' é ativado.
        elsif rising_edge(clk) then
            temp <= temp(temp'high-1 downto 0) & data_in;  -- Desloca os bits para esquerda e adiciona 'data_in' na posição menos significativa.
        end if;
    end process;

    data_out <= temp(temp'high);  -- Atribui o bit mais significativo do vetor ao 'data_out'.
end behavioral;

