library ieee;
use ieee.std_logic_1164.all;    -- Biblioteca para sinais lógicos básicos

entity a009f_timer_proc_tb is
end entity;

architecture sim of a009f_timer_proc_tb is
    -- Parâmetros de clock do testbench
    constant clockFreq : integer := 10;               -- Frequência de referência em Hz
    constant clkPer    : time    := 1000 ms / clockFreq; -- Período do clock (1/clockFreq s)

    -- Sinais de estímulo e monitoramento
    signal clk, nRst : std_logic := '0';  -- Sinal de clock e reset inicializados em '0'

    -- Sinais para receber saída de segundos, minutos e horas do DUT
    signal segundo   : integer;           -- Contador de segundos (0–60)
    signal minuto    : integer;           -- Contador de minutos (0–60)
    signal hora      : integer;           -- Contador de horas   (0–24)

begin
    -- Instanciação do dispositivo sob teste (DUT): timer com procedimento
    i_timer : entity work.a19_timer(rtl)
        generic map(
            clockFreq => clockFreq        -- Mapeia a frequência genérica para o DUT
        )
        port map(
            clk     => clk,               -- Conecta sinal de clock ao DUT
            nRst    => nRst,              -- Conecta sinal de reset ao DUT
            s       => segundo,           -- Coleta saída de segundos
            m       => minuto,            -- Coleta saída de minutos
            h       => hora               -- Coleta saída de horas
        );

    -- Gerador de clock: alterna o clk após metade do período definido para simular 10 Hz
    clk <= not clk after clkPer / 2;

    -- Processo de controle de reset
    process is
    begin
        -- Aguarda duas bordas de subida do clock para sincronização inicial
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- Libera o reset: passa de '0' para '1', permitindo operação normal do timer
        nRst <= '1';

        -- Suspende o processo indefinidamente, mantendo o testbench ativo
        wait;
    end process;

end architecture;

-- Fim do testbench a009f_timer_proc_tb.vhd
