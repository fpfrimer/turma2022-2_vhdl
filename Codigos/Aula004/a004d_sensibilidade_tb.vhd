-- Este testbench compara TRES formas de um processo VHDL reagir a mudancas em sinais:
-- 1. wait on: o processo espera explicitamente por eventos em sinais especificos
-- 2. Lista de sensibilidade: o processo e automaticamente acionado quando sinais mudam
-- 3. if/elsif/else com wait on: avalia multiplas condicoes apos evento
-- 
-- Diferenca chave: wait on da controle manual; lista de sensibilidade e declarativa.
-- Nota: lista de sensibilidade e preferivel para codigo sintetizavel.

entity a004d_sensibilidade_tb is
end entity;

architecture sim of a004d_sensibilidade_tb is
    signal CntUp    :   integer := 0;
    signal CntDown  :   integer := 10;

begin
    -- Gerador de eventos: incrementa/decrementa sinais a cada 10 ns
    -- Este processo cria as mudancas que os outros processos vao detectar.
    process is
    begin
        CntUp <= CntUp + 1;
        CntDown <= CntDown - 1;
        wait for 10 ns; -- Ciclo de atualizacao a cada 10 nanosegundos.
    end process;

    -- Metodo 1: wait on (controle manual)
    -- O processo so executa quando CntUp ou CntDown mudam de valor.
    -- O wait on fica no FINAL do processo, criando um loop implicito.
    -- Equivalente a: "quando mudar, execute uma vez e espere novamente"
    processo_wait_on: process is
    begin
        if CntUp = CntDown then
            report "Metodo 1 (wait on): Bingo!";
        end if;
        wait on CntUp, CntDown; -- Reativacao do processo em mudancas de CntUp ou CntDown.
    end process;

    -- Metodo 2: lista de sensibilidade (controle declarativo)
    -- A lista (CntUp, CntDown) na declaracao do processo faz o mesmo papel do wait on.
    -- Vantagem: mais legivel e padrao em codigo sintetizavel.
    -- O processo e automaticamente re-agendado quando um sinal da lista muda.
    processo_sensibilidade: process(CntUp, CntDown) is
    begin
        if CntUp = CntDown then
            report "Metodo 2 (sensibilidade): Bingo!";
        end if;
    end process;

    -- Metodo 3: if/elsif/else para multiplas condicoes
    -- Demonstra avaliacao de multiplas condicoes em cadeia.
    -- A ordem importa: a primeira condicao verdadeira executa, as outras sao ignoradas.
    -- Util para estados mutuamente exclusivos (ex: maquina de estados).
    processo_completo: process is
    begin
        if CntUp > CntDown then
            report "CntUp > CntDown";
        elsif CntUp < CntDown then
            report "CntUp < CntDown";
        else
            report "CntUp = CntDown";
        end if;
        wait on CntUp, CntDown; -- Reativa o processo quando CntUp ou CntDown mudam.
    end process;

    -- RESUMO DA SIMULACAO:
    -- - Processo 1 e 2 imprimem "Bingo!" quando CntUp = CntDown (em 50 ns)
    -- - Processo 3 imprime "CntUp < CntDown" repetidamente ate 50 ns,
    --   depois "CntUp = CntDown" uma vez, entao "CntUp > CntDown"
    -- 
    -- Nota: Processo 2 (lista de sensibilidade) e preferivel para sintese.
    --       wait on e mais comum em testbenches e simulacao.

end architecture;
