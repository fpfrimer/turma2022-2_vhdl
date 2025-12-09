-- O objetivo deste código é imprimir os números inteiros de 1 a 10 no console de simulação.
-- Note que não é necessário chamar a biblioteca std. No entanto, o pacote textio 
-- precisa ser chamado devido à utilização do tipo line e das funções write e writeline.

use std.textio.all;

-- Note novamente a entidade vazia para o testbench.
-- Procure memorizar esta sintaxe.
-- Note que a01c_hello_tb é o nome dessa entidade, definido pelo projetista.
entity a003c_for_loop_tb is
end entity;

-- Note que a arquitetura foi chamada de tb, nome também definido pelo projetista.
architecture tb of a003c_for_loop_tb is
    
begin
    process
        variable L: line;  -- Variável do tipo line para armazenamento e manipulação de texto.
    begin
        -- Loop for para imprimir números de 1 a 10 no console.
        -- Explicações futuras detalharão melhor esse tipo de loop.
        for i in 1 to 10 loop
            
            -- Converter o número para uma string com a função 'image'.
            write(L, "loop " & integer'image(i));
            -- Imprimir o número no console de simulação.
            writeline(output, L);
            
        end loop;

        -- Aguardar um tempo antes de finalizar o processo (opcional).
        wait for 100 ms;

        -- Finalizar o processo.        
        wait;  -- O processo para aqui, aguardando indefinidamente.
    end process;
end architecture;
