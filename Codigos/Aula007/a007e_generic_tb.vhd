-- Este testbench VHDL testa o funcionamento do multiplexador genérico definido na entidade a007d_generic.
-- A largura dos dados pode ser configurada através do parâmetro genérico 'dataWidth'. O testbench gera
-- sinais de entrada com um único bit alto em posições variadas para verificar a capacidade do mux de
-- selecionar corretamente entre várias entradas baseando-se no sinal de seleção 'sel'. Este teste simula
-- a passagem sequencial através de todas as entradas, verificando a correta funcionalidade da parametrização.

library ieee;
use ieee.std_logic_1164.all; -- Inclui a biblioteca padrão para operações com std_logic e std_logic_vector.
use ieee.numeric_std.all;    -- Inclui a biblioteca para operações com tipos aritméticos como 'unsigned'.

entity a007e_generic_tb is
end entity;

architecture sim of a007e_generic_tb is
    -- Constante 'n' define a largura das entradas e saída do mux.
    constant n   :  integer := 4; -- A largura dos dados deve ser maior que 4 para cobrir todas as entradas.

    -- Sinais de entrada, cada um com um único bit definido como '1' em diferentes posições.
    signal sig0  :   unsigned(n - 1 downto 0) := (0 => '1', others => '0');
    signal sig1  :   unsigned(n - 1 downto 0) := (1 => '1', others => '0');
    signal sig2  :   unsigned(n - 1 downto 0) := (2 => '1', others => '0');
    signal sig3  :   unsigned(n - 1 downto 0) := (3 => '1', others => '0');

    -- Sinal de seleção para o mux.
    signal sel   :   unsigned(1 downto 0) := "00";

    -- Sinal de saída do mux.
    signal saida :   unsigned(n - 1 downto 0);

begin
    -- Instanciação do mux genérico configurado com o parâmetro 'n'.
    dut_mux: entity work.a007d_generic(rtl)
        generic map(dataWidth => n)
        port map(
            sel     =>      sel,
            sig0    =>      sig0,
            sig1    =>      sig1,
            sig2    =>      sig2,
            sig3    =>      sig3,
            saida   =>      saida
        );

    -- Processo para alterar o sinal de seleção a cada 10 ns e testar cada entrada do mux.
    process is
    begin
        wait for 10 ns;
        sel <= sel + 1; -- Incrementa o sinal de seleção para testar a próxima entrada.
        if sel = "11" then
            wait; -- Pausa a simulação após testar todas as entradas.
        end if;
    end process;

end architecture; -- Fim da arquitetura de simulação.
