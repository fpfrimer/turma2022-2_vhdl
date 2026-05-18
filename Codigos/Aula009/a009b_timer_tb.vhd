library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.stop;

entity a009b_timer_tb is
end entity;

architecture sim of a009b_timer_tb is
    -- Parametros do clock para o testbench
    constant clockFreq : positive := 10;                -- Frequencia de referencia (Hz)
    constant clkPer    : time     := 1000 ms / clockFreq; -- Periodo de clock (1/clockFreq s)

    -- Sinais de estimulo e observacao
    signal clk, nRst : std_logic := '0';       -- Clock e reset assincrono (ativo em '0')
    signal segundo   : unsigned(5 downto 0);   -- Contador de segundos (0 a 59)
    signal minuto    : unsigned(5 downto 0);   -- Contador de minutos (0 a 59)
    signal hora      : unsigned(4 downto 0);   -- Contador de horas (0 a 23)
begin
    -- Instanciacao do dispositivo sob teste (DUT): timer com horas, minutos e segundos
    i_timer: entity work.a009a_timer(rtl)
        generic map (
            clockFreq => clockFreq
        )
        port map (
            clk  => clk,
            nRst => nRst,
            s    => segundo,
            m    => minuto,
            h    => hora
        );

    -- Geracao de clock: alterna o sinal clk apos metade do periodo definido
    clk <= not clk after clkPer / 2;

    -- Processo de controle de reset
    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        nRst <= '1'; -- Desativa o reset assincrono

        wait;
    end process;

    -- Verificacao simples para automatizar a simulacao.
    process is
    begin
        wait until nRst = '1';

        wait until segundo = to_unsigned(1, segundo'length);
        assert minuto = to_unsigned(0, minuto'length) and hora = to_unsigned(0, hora'length)
            report "Falha apos o primeiro segundo simulado"
            severity failure;

        wait until minuto = to_unsigned(1, minuto'length);
        assert segundo = to_unsigned(0, segundo'length) and hora = to_unsigned(0, hora'length)
            report "Falha no transbordo de segundos para minutos"
            severity failure;

        report "Simulacao do timer com unsigned concluida com sucesso";
        stop;
    end process;

end architecture;
