-- Este testbench VHDL imprime os números de 20 até 1 em ordem decrescente.
-- O loop é interrompido se o valor atual do contador for igual a uma constante pré-definida 'n'.
-- Esta abordagem demonstra como controlar a execução de loops usando condições de saída.


entity a003e_while_loop_tb is
end entity;

architecture sim of a003e_while_loop_tb is
    constant n  :   integer := 9; -- Declara a constante 'n' com o valor 9 para uso como condição de saída do loop.
begin

    -- Thread
    process is
        variable i  :   integer := 20; -- Inicializa a variável 'i' em 20 para contar regressivamente até 1.
        -- Note que i foi declarado sem range, portanto, é uma variável de 32 bits
    begin
        report "Start!";-- Indica o início do processo de contagem regressiva
        
        -- Laço enquanto (while) para iterar enquanto i for maior que zero
        while i > 0 loop
            -- Condição de saída explícita: interrompe o loop quando i atinge o valor de 'n'
            exit when i = n;
             -- Report gera uma mensagem de simulação mostrando o valor atual de i
            report "i = " & integer'image(i); 
            i := i - 1; -- Atualiza i decrementando em 1 a cada iteração
        end loop; -- Fim do loop: o código alcança este ponto quando i == n ou i <= 0

        report "Ateh!"; -- Indica o fim do processo de contagem ou saída antecipada
        wait; -- Suspende o processo indefinidamente, finalizando a simulação
    end process;

end architecture;
    
