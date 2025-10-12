library ieee;
use ieee.std_logic_1164.all;

entity a009b_timer_tb is
end entity;

architecture sim of a009b_timer_tb is
    -- Parâmetros do clock para o testbench
    constant clockFreq : integer := 10;               -- Frequência de referência (Hz)
    constant clkPer    : time    := 1000 ms / clockFreq; -- Período de clock (1/clockFreq s)

    -- Sinais de estímulo e observação
    signal clk, nRst  : std_logic := '0';            -- Clock e reset assíncrono (ativo em '0')
    signal segundo    : integer range 0 to 60;        -- Contador de segundos (0–59)
    signal minuto     : integer range 0 to 60;        -- Contador de minutos (0–59)
    signal hora       : integer range 0 to 24;        -- Contador de horas (0–23)
begin
    -- Instanciação do dispositivo sob teste (DUT): timer com horas, minutos e segundos
    i_timer: entity work.a009a_timer(rtl)
        generic map (
            clockFreq => clockFreq  -- Mapeia a frequência genérica ao DUT
        )
        port map (
            clk     => clk,        -- Conecta sinal de clock ao DUT
            nRst    => nRst,       -- Conecta sinal de reset ao DUT
            s       => segundo,    -- Conecta saída de segundos do DUT
            m       => minuto,     -- Conecta saída de minutos do DUT
            h       => hora        -- Conecta saída de horas do DUT
        );

    -- Geração de clock: alterna o sinal clk após metade do período definido
    clk <= not clk after clkPer / 2;

    -- Processo de controle de reset
    process is
    begin
        -- Aguarda duas bordas de subida para garantir sincronização inicial
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        -- Libera o reset para começar a contagem
        nRst <= '1';          -- Desativa o reset assíncrono (nível alto)

        wait;                -- Suspende o processo indefinidamente, mantendo o testbench ativo
    end process;

end architecture;
