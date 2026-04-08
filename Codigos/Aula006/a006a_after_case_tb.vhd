-- Este testbench VHDL demonstra dois conceitos fundamentais:
-- 1. O comando 'after' para geração de clocks de diferentes frequências e controle de reset.
-- 2. O comando 'case' para multiplexar sinais em um processo sequencial.
-- Observe que 'after' é usado apenas para simulação (não sintetizável), enquanto
-- 'case' é amplamente utilizado em código sintetizável para lógica condicional.

library ieee;
use ieee.std_logic_1164.all; -- Importa tipos e operações para std_logic e std_logic_vector.
use ieee.numeric_std.all;    -- Importa tipos e operações para signed e unsigned.

entity a006a_after_case_tb is
end entity;

architecture sim of a006a_after_case_tb is
    -- Sinais de clock com frequências diferentes
    signal clk0   : std_logic := '0';  -- 50 MHz (período de 20 ns)
    signal clk1   : std_logic := '0';  -- 25 MHz (período de 40 ns)
    signal clk2   : std_logic := '0';  -- 10 MHz (período de 100 ns)
    signal clk3   : std_logic := '0';  -- 5 MHz  (período de 200 ns)

    -- Sinal de seleção do multiplexador
    signal sel    : unsigned(1 downto 0) := "00";

    -- Sinal de saída do multiplexador
    signal clk_mux : std_logic;

    -- Sinal de reset com agendamento múltiplo
    signal rst    : std_logic := '1';

begin

    ---------------------------------------------------------------------------
    -- Geração de clocks com 'after' (atribuição concorrente)
    ---------------------------------------------------------------------------
    -- O comando 'after' inverte o sinal após o tempo especificado.
    -- Como a atribuição é concorrente, ela se repete indefinidamente.
    clk0 <= not clk0 after 10 ns;   -- Meio período = 10 ns → período = 20 ns (50 MHz)
    clk1 <= not clk1 after 20 ns;   -- Meio período = 20 ns → período = 40 ns (25 MHz)
    clk2 <= not clk2 after 50 ns;   -- Meio período = 50 ns → período = 100 ns (10 MHz)
    clk3 <= not clk3 after 100 ns;  -- Meio período = 100 ns → período = 200 ns (5 MHz)

    ---------------------------------------------------------------------------
    -- Reset com 'after' (agendamento múltiplo)
    ---------------------------------------------------------------------------
    -- Múltiplas transições podem ser agendadas em uma única linha.
    -- O reset começa em '1', vai para '0' em 55 ns e permanece assim.
    rst <= '1' after 0 ns, '0' after 55 ns;

    ---------------------------------------------------------------------------
    -- Multiplexador com 'case' (processo sequencial)
    ---------------------------------------------------------------------------
    -- O 'case' seleciona qual clock será conectado à saída clk_mux.
    -- A lista de sensibilidade garante reavaliação sempre que sel ou
    -- qualquer clock mudar de valor.
    mux_clk: process(sel, clk0, clk1, clk2, clk3)
    begin
        case sel is
            when "00"   => clk_mux <= clk0;  -- Seleciona clock de 50 MHz
            when "01"   => clk_mux <= clk1;  -- Seleciona clock de 25 MHz
            when "10"   => clk_mux <= clk2;  -- Seleciona clock de 10 MHz
            when others => clk_mux <= clk3;  -- Seleciona clock de 5 MHz
        end case;
    end process;

    ---------------------------------------------------------------------------
    -- Processo para trocar o seletor ao longo do tempo
    ---------------------------------------------------------------------------
    -- A cada 100 ns, o seletor avança para o próximo clock.
    -- Isso permite observar diferentes frequências na saída clk_mux.
    troca_sel: process is
    begin
        wait for 500 ns;
        sel <= sel + 1;
        if sel = "11" then
            wait;  -- Para a simulação após testar todos os clocks
        end if;
    end process;

end architecture;
