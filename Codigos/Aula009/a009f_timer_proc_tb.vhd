library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.stop;

entity a009f_timer_proc_tb is
end entity;

architecture sim of a009f_timer_proc_tb is
    constant clockFreq : positive := 10;
    constant clkPer    : time     := 1000 ms / clockFreq;

    signal clk, nRst : std_logic := '0';

    signal segundo : unsigned(5 downto 0);
    signal minuto  : unsigned(5 downto 0);
    signal hora    : unsigned(4 downto 0);

begin
    i_timer : entity work.a009c_timer_proc(rtl)
        generic map(
            clockFreq => clockFreq
        )
        port map(
            clk  => clk,
            nRst => nRst,
            s    => segundo,
            m    => minuto,
            h    => hora
        );

    clk <= not clk after clkPer / 2;

    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);

        nRst <= '1';
        wait;
    end process;

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

        report "Simulacao do timer com procedimento e unsigned concluida com sucesso";
        stop;
    end process;

end architecture;
