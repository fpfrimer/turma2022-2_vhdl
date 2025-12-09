-- Este testbench VHDL é projetado para testar o funcionamento do multiplexador definido na entidade a15a_mux.
-- A simulação do mux é realizada chamando o componente através de mapeamento de portas, demonstrando
-- como diferentes sinais de entrada são selecionados com base no sinal de seleção 'sel_tb'.
-- O teste procede por alterar sequencialmente o valor de 'sel_tb' para cada uma das entradas do mux
-- (sig0, sig1, sig2, sig3), verificando a saída correspondente em cada caso.

library ieee;
use ieee.std_logic_1164.all; -- Inclui a biblioteca padrão para operações com std_logic e std_logic_vector.
use ieee.numeric_std.all; -- Inclui a biblioteca para operações com tipos aritméticos como 'unsigned'.

entity a007b_mux_tb is
end a007b_mux_tb;

architecture sim of a007b_mux_tb is
    -- Definindo sinais de teste para entradas do mux e para seleção.
    signal sig0  :   unsigned(7 downto 0) := x"AA"; -- Entrada 0 com valor inicial AA.
    signal sig1  :   unsigned(7 downto 0) := x"BB"; -- Entrada 1 com valor inicial BB.
    signal sig2  :   unsigned(7 downto 0) := x"CC"; -- Entrada 2 com valor inicial CC.
    signal sig3  :   unsigned(7 downto 0) := x"DD"; -- Entrada 3 com valor inicial DD.
    signal sel_tb  :   unsigned(1 downto 0) := "00"; -- Seletor inicializado para testar a primeira entrada.
    signal saida :   unsigned(7 downto 0); -- Saída do mux para ser observada no teste.

begin
    -- Chamada do componente mux do arquivo anterior utilizando mapeamento nominal das portas.
    dut_mux: entity work.a15a_mux(rtl) port map(
        sel     =>      sel_tb,   -- Mapeando sel_tb do testbench para sel do mux.
        sig0    =>      sig0,     -- Conectando sig0.
        sig1    =>      sig1,     -- Conectando sig1.
        sig2    =>      sig2,     -- Conectando sig2.
        sig3    =>      sig3,     -- Conectando sig3.
        saida   =>      saida     -- Saída para monitoramento.
    );

    -- Processo de teste que altera o seletor e monitora a saída.
    process is
    begin
        wait for 10 ns; -- Espera 10 ns entre cada mudança de seleção.
        sel_tb <= sel_tb + 1; -- Incrementa o seletor para testar a próxima entrada do mux.
        if sel_tb = "11" then -- Se todas as entradas foram testadas, o processo é concluído.
            wait; -- Pausa a simulação.
        end if;
    end process;

end architecture; -- Fim da arquitetura de simulação.
