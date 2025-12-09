-- Este código, diferentemente do a01_hello_tb.vhd, utiliza o pacote textio para imprimir uma mensagem
-- no console de simulação. A mensagem impressa ajuda na depuração do código.
-- Embora este código seja mais complexo, a mensagem impressa não inclui o tempo de simulação.

-- Inclusão de bibliotecas e pacotes antes da declaração da entidade.
-- A chamada para a biblioteca padrão (std) é opcional e pode ser omitida.
library std; -- opcional
use std.textio.all; -- utilizado para manipulação de texto 

-- Entidade vazia para testbench; não há portas porque é apenas para simulação e teste.
entity a001d_hello_tb is
end entity;

architecture tb of a001d_hello_tb is
begin
    process
        -- Tipo de dado 'line' do pacote textio usado para manipular e armazenar texto.
        -- 'Line' é um buffer de texto onde as strings são armazenadas temporariamente antes de serem processadas ou exibidas.
        variable L: line;
    begin
        -- Escreve a mensagem desejada no buffer 'L'. Um buffer é uma área de armazenamento temporário usado para armazenar dados
        -- enquanto eles são transferidos de um lugar para outro. Aqui, ele armazena texto para ser impresso.
        write(L, string'("Olá, esta é a mensagem impressa no console!"));

        -- Imprime a mensagem no console de simulação. 'writeline' envia o conteúdo do buffer 'L' para o dispositivo de saída padrão.
        writeline(output, L);

        -- Finaliza o processo.
        wait; -- O testbench para aqui, aguardando indefinidamente.
    end process;
end architecture tb;
