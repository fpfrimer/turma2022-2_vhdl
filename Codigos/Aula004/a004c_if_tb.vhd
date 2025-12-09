-- Este testbench VHDL demonstra o uso de estruturas condicionais 'if' em combinação com
-- listas de sensibilidade em processos para responder a mudanças nos valores dos sinais.
-- Existem três processos principais que ilustram diferentes maneiras de usar o comando 'if'
-- para controlar o fluxo lógico com base no estado dos sinais CntUp e CntDown:
-- 1. Processo A: Utiliza uma condição 'if' dentro do processo e aguarda mudanças nos sinais
--    através do comando 'wait on', que ativa o processo quando há mudanças em CntUp ou CntDown.
-- 2. Processo B: Usa uma lista de sensibilidade declarada diretamente na definição do processo
--    para reagir automaticamente a mudanças em CntUp ou CntDown e avalia a condição 'if'.
-- 3. Processo C: Apresenta um 'if' completo com múltiplas condições para relatar diferentes
--    relações entre CntUp e CntDown, também utilizando 'wait on' para reativar o processo.
-- Esses exemplos ilustram como combinar condições lógicas com sensibilidade de sinal para
-- criar respostas dinâmicas em simulações de circuitos digitais.

entity a004c_if_tb is
end entity;

architecture sim of a004c_if_tb is
    signal CntUp    :   integer := 0;
    signal CntDown  :   integer := 10;

begin
    -- Processo que modifica os contadores CntUp e CntDown.
    process is
    begin
        CntUp <= CntUp + 1;
        CntDown <= CntDown - 1;
        wait for 10 ns; -- Espera 10 nanosegundos antes de repetir.
    end process;

    -- Processo A: Utiliza 'wait on' com uma condição 'if'.
    process is
    begin
        if CntUp = CntDown then
            report "Processo A: Bingo!";
        end if;
        wait on CntUp, CntDown; -- Reativação do processo em mudanças de CntUp ou CntDown.
    end process;

    -- Processo B: Declaração da sensibilidade no início.
    -- O processo é executado apenas quando um dos sinais especificados sofre uma mudança.
    process(CntUp, CntDown) is
    begin
        if CntUp = CntDown then
            report "Processo B: Bingo!";
        end if;
    end process;

    -- Processo C: Uso extensivo de 'if', 'elsif' e 'else'.
    process is
    begin
        if CntUp > CntDown then
            report "CntUp eh maior";
        elsif CntUp < CntDown then
            report "CntUp eh menor";
        else
            report "Iguais!";
        end if;
        wait on CntUp, CntDown; -- Reativa o processo quando CntUp ou CntDown mudam.
    end process;
end architecture;
