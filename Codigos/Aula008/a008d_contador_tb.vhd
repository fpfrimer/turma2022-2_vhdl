-- Este arquivo VHDL é o banco de testes para o módulo contador.
-- Ele configura um ambiente de simulação que testa o comportamento do contador
-- gerando um sinal de clock e reset assíncrono. O banco de testes usa uma frequência
-- de clock de 100 MHz e inicia a operação do contador após um pequeno atraso.

library ieee;
use ieee.std_logic_1164.all;      -- Inclui os tipos de lógica padrão.
use ieee.numeric_std.all;         -- Inclui tipos e operações numéricas.

entity a008d_contador_tb is
end entity;

architecture sim of a008d_contador_tb is
    constant n          : integer := 5;                      -- Define o número de bits do contador.
    constant clkFreq    : integer := 100e6;                  -- Define a frequência do clock em 100 MHz.
    constant clkPer     : time    := 1000 ms / clkFreq;      -- Calcula o período do clock baseado na frequência.

    signal clk  : std_logic := '1';                          -- Inicializa o clock em alto.
    signal nRst : std_logic := '0';                          -- Inicializa o reset em baixo.
    signal q    : unsigned(n - 1 downto 0);                  -- Sinal para armazenar a saída do contador.

begin

    -- Instanciação do contador
    i_cont    : entity work.a008c_contador(rtl)
        generic map(n => n)                                  -- Mapeia o número de bits para o contador.
        port map(
            clk => clk,
            nRst => nRst,
            q => q
        );

    -- Geração de clock
    clk <= not clk after clkPer / 2;                         -- Gera um clock alternando estado a cada meio período.

    -- Inicialização do reset
    nRst <= '1' after 15 ns;                                 -- Desativa o reset após 15 nanosegundos.

end architecture;
