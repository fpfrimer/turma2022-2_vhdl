-- Este exemplo tem o intuito de demonstrar como utilizar o comando "wait for".
-- O comando "wait for" faz com que a simulação aguarde pelo tempo especificado 
-- pelo projetista antes de continuar a execução.

-- Declaração da entidade sem portas, pois é um testbench que não necessita 
-- de interfaces externas.
entity a002a_wait_for_tb is
end entity;

-- Arquitetura da entidade, contendo o processo que utiliza o comando "wait for".
architecture sim of a002a_wait_for_tb is
begin

    -- Processo que executa comandos sequencialmente.
    process
    begin
        -- Emitindo a mensagem inicial para o console de simulação.
        report "Hello World!";

        -- O comando "wait for 10 ns" pausa a execução do processo por 10 nanossegundos.
        -- Isso é útil para testes que exigem atrasos temporais para simular 
        -- condições reais de operação.
        wait for 10 ns;

        -- Após o atraso, o processo reinicia automaticamente do início.
        -- Em VHDL, um processo é reiniciado do começo após completar sua 
        -- execução, a menos que haja uma condição de parada.
    end process;

end architecture;
