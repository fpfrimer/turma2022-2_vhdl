-- Este testbench VHDL é projetado para demonstrar o uso do tipo 'std_logic_vector', um vetor de sinais de 'std_logic'
-- que permite manipular múltiplos bits simultaneamente. Este tipo é amplamente usado para representar bus de dados,
-- endereços e outros grupos de sinais em projetos digitais. O código exemplifica diferentes maneiras de inicializar
-- 'std_logic_vector' e operações comuns como deslocamento de bits em um vetor.

library ieee;
use ieee.std_logic_1164.all; -- Importa a biblioteca IEEE para acesso aos tipos de dados 'std_logic' e 'std_logic_vector'.

entity a005b_slv_tb is
end entity;

architecture sim of a005b_slv_tb is
    -- Declaração de diferentes 'std_logic_vector' para demonstração.
    signal slv1 : std_logic_vector(8 downto 1);               -- Vetor não inicializado.
    signal clk  : std_logic_vector(7 downto 0) := "01010101"; -- Vetor inicializado com um padrão específico.
    signal slv2 : std_logic_vector(7 downto 0) := (others => '0'); -- Vetor inicializado com todos os bits em '0'.
    signal slv3 : std_logic_vector(9 downto 0) := (0 => '1', others => '0'); -- Vetor com o primeiro bit como '1' e os demais como '0'.
    signal slv4 : std_logic_vector(7 downto 0) := x"FE"; -- Vetor inicializado com um valor hexadecimal.
    signal slv5 : std_logic_vector(0 to 7) := x"AA"; -- Vetor com a direção inversa e inicializado com um valor hexadecimal.

begin
    -- Processo para gerar um sinal de clock alternando os bits do vetor 'clk'.
    process is
    begin
        wait for 10 ns;
        clk <= not clk; -- Inverte todos os bits no vetor a cada 10 nanosegundos.
    end process; 

    -- Processo para realizar o deslocamento circular de bits no vetor 'slv3'.
    process is
    begin
        wait for 10 ns;

        -- Desloca cada bit para a direita.
        for i in slv3'left downto slv3'right + 1 loop
            slv3(i) <= slv3(i - 1); -- Deslocamento de bit ocorre da esquerda para a direita.
        end loop;
        slv3(slv3'right) <= slv3(slv3'left); -- O bit mais à direita recebe o valor do bit mais à esquerda, completando o deslocamento circular.
    end process;

end architecture;
