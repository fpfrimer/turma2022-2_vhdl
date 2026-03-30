 -- Este arquivo VHDL é o banco de testes para o módulo flip-flop D.
-- Ele configura um ambiente de simulação que testa o comportamento do flip-flop
-- gerando um sinal de clock e reset assíncrono, aplicando estímulos na entrada D
-- e verificando a saída Q em resposta às bordas de clock.

library ieee;
use ieee.std_logic_1164.all;      -- Inclui os tipos de lógica padrão.
use ieee.numeric_std.all;         -- Inclui tipos e operações numéricas.

entity a008b_flipFlop_tb is
end entity;

architecture sim of a008b_flipFlop_tb is
    -- Parâmetros de clock para o testbench
    constant clkFreq : integer := 100e6;         -- Define a frequência de clock de 100 MHz
    constant clkPer  : time    := 1000 ms / clkFreq; -- Calcula o período do clock

    -- Declaração dos sinais de estímulo e monitoramento
    signal clk  : std_logic := '1';  -- Sinal de clock inicializado em nível alto
    signal nRst : std_logic := '0';  -- Reset assíncrono ativo em nível baixo
    signal d    : std_logic := '0';  -- Entrada D do flip-flop
    signal q    : std_logic;         -- Saída Q do flip-flop a ser observada

begin

    -- Instanciação do dispositivo sob teste (DUT)
    i_ff: entity work.a008a_flipFlop(rtl)
        port map(
            clk  => clk,   -- Conecta o clock do testbench ao DUT
            nRst => nRst,  -- Conecta o reset assíncrono ao DUT
            d    => d,     -- Conecta a entrada de dado D ao DUT
            q    => q      -- Monitora a saída Q do DUT
        );

    -- Geração de clock: inverte 'clk' após metade do período para produzir o sinal de 100 MHz
    clk <= not clk after clkPer / 2;

    -- Processo de aplicação de estímulos
    process is
    begin
        -- Libera o reset para iniciar a operação normal
        nRst <= '1';

        -- Sequência de valores aplicados à entrada D para testar a captura em borda
        wait for 20 ns;
        d <= '1';        -- Aplica valor alto após 20 ns

        wait for 22 ns;
        d <= '0';        -- Aplica valor baixo após mais 22 ns

        wait for 6 ns;
        d <= '1';        -- Aplica valor alto após mais 6 ns

        wait for 20 ns;
        -- Verifica se Q segue D na borda de clk

        -- Aciona o reset assíncrono para verificar retorno a zero
        nRst <= '0';    -- Coloca o sistema em condição de reset

        -- Suspende o processo indefinidamente, encerrando a simulação
        wait;
    end process;

end architecture;

-- Fim do testbench a008b_flipFlop_tb.vhd
