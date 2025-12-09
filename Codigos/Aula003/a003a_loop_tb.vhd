-- Este exemplo de testbench VHDL demonstra o uso de um loop para imprimir uma 
-- sequência de números e controlar o fluxo de execução com uma condição de saída. 
-- O loop executa até que uma variável inteira, inicialmente definida como 0, atinja o
-- valor de 10. A cada iteração, o valor atual da variável é impresso, seguido de 
-- uma espera de 20 nanossegundos, ilustrando o controle temporal em processos VHDL.

entity a003a_loop_tb is
end entity;

architecture sim of a003a_loop_tb is
begin

    -- O processo dentro da arquitetura simula uma thread de execução.
    process
        -- Declaração de uma variável inteira 'i', iniciada com 0, para controlar o loop.
        -- Variáveis em VHDL são locais ao processo ou subprograma em que são declaradas
        -- e retêm seu valor entre execuções sucessivas do mesmo processo. Elas são 
        -- úteis para armazenar estados temporários e passar informações dentro de um
        -- bloco de código de forma isolada, sem afetar outros processos ou a 
        -- arquitetura global.
        variable i : integer := 0;

    begin
        -- Report inicial para indicar o início da simulação.
        report "Start!";

        -- Estrutura de loop que continuará a executar até que uma condição de saída 
        -- seja satisfeita.
        loop
            -- Imprime o valor atual de i a cada iteração do loop.
            report "Dentro do loop: " & integer'image(i);
            
            -- Espera por 20 nanossegundos antes de prosseguir para a próxima iteração.
            wait for 20 ns;            
                       
            -- Incremento da variável i para progressão do loop.
            i := i + 1;
        end loop;

        -- Mensagem final reportada após a conclusão do loop.
        report "Ateh!";
        
        -- O comando wait sem especificação de tempo faz com que o processo aguarde indefinidamente.
        -- Isso impede que o processo reinicie automaticamente.
        wait;

    end process;

end architecture;

-- Observações importantes sobre o código:
-- 1 - Note que a variável foi declarada antes do 'begin' no processo, o que é necessário para garantir sua visibilidade dentro do processo.
-- 2 - Não é permitido declarar variáveis diretamente na arquitetura; elas devem estar dentro de processos ou subprogramas.
-- 3 - Variáveis são declaradas dentro de processos e subprogramas porque são locais a esses blocos e mantêm seu valor entre as execuções do bloco.
-- 4 - Variáveis são um dos quatro tipos de objetos de dados em VHDL, os outros são sinais, constantes e arquivos.

