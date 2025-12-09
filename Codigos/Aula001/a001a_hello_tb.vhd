-- Este exemplo simples demonstra como imprimir a mensagem "Hello World!" na saída de simulação.
-- Pense neste exemplo como uma introdução ao conceito de testes de bancada (testbenchs).
-- A primeira ferramenta que iremos explorar é o comando "report".

-- Testbenches geralmente têm uma entidade vazia.
-- A entidade define a interface do módulo com o exterior, mas aqui não são necessárias conexões externas.
entity a001a_hello_tb is
end entity;

-- A arquitetura descreve o comportamento interno do módulo.
architecture sim of a001a_hello_tb is
begin

    -- Um process em VHDL é semelhante a uma thread em programação e executa comandos sequencialmente.
    -- Quando alcança o final, o process reinicia, comportando-se como um loop.
    imprime: process
    begin
        -- O comando 'report' é usado para imprimir mensagens na saída de simulação, útil para debugação.
        -- A mensagem geralmente é impressa com a indicação do tempo de simulação
        report "Hello World!";
        wait; -- O comando 'wait' aqui é usado para pausar indefinidamente a execução do process.

    end process;

    -- Comentários em VHDL são introduzidos com '--'.

end architecture;
