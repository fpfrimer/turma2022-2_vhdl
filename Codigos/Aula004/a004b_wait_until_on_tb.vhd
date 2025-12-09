-- Este testbench VHDL é projetado para demonstrar o funcionamento e a aplicação dos comandos 'wait on' e 'wait until',
-- dois mecanismos de controle de fluxo importantes em VHDL. O comando 'wait on' é usado para reagir a mudanças em 
-- sinais específicos, ideal para processos que devem executar ações imediatas em resposta a eventos externos.
-- O comando 'wait until', por sua vez, permite a pausa de um processo até que uma condição definida seja verdadeira,
-- sendo útil para sincronizar ações dentro de um circuito conforme estados específicos são alcançados.

entity a004b_wait_until_on_tb is
end entity;

-- Arquitetura que inclui sinais e processos que ilustram como os comandos 'wait on' e 'wait until' funcionam.
architecture sim of a004b_wait_until_on_tb is
    -- Declaração dos sinais usados para demonstrar os comandos de espera.
    signal CntUp    :   integer := 0;  -- Contador que incrementa a partir de 0.
    signal CntDown  :   integer := 10; -- Contador que decrementa a partir de 10.

begin
    -- Processo que modifica os sinais CntUp e CntDown a cada 10 ns.
    process is
    begin
        -- Modifica os valores dos sinais.
        CntUp <= CntUp + 1;          -- Incrementa o contador ascendente.
        CntDown <= CntDown - 1;      -- Decrementa o contador descendente.
        wait for 10 ns;              -- Ciclo de atualização ocorre a cada 10 nanosegundos.
    end process;

    -- Processo demonstrando o uso do 'wait on'.
    -- Este processo é acionado por alterações nos sinais especificados.
    process is
    begin
        -- Espera mudanças em qualquer um dos sinais CntUp ou CntDown.
        wait on CntUp, CntDown;      -- Aciona o processo quando CntUp ou CntDown mudam.
        -- Reporta os valores dos contadores quando eles são atualizados.
        report "CntUp = " & integer'image(CntUp) & " CntDown = " & integer'image(CntDown);
    end process;

    -- Processo demonstrando o uso do 'wait until'.
    -- Este processo espera até que uma condição específica seja atendida.
    process is
    begin
        -- Continua a espera até que CntUp seja igual a CntDown.
        wait until CntUp = CntDown;  -- Pausa o processo até que CntUp igual a CntDown.
        -- Reporta quando a condição especificada é cumprida.
        report "**** Bingo! ****";   -- Indica que ambos contadores se igualaram.
    end process;
end architecture;
