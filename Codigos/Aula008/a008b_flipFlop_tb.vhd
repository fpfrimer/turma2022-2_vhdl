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
