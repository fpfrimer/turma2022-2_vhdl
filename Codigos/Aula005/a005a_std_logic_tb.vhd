-- Este testbench VHDL é projetado para demonstrar o uso do tipo 'std_logic' da biblioteca IEEE e a geração de um sinal de clock.
-- 'std_logic' é um tipo de dado escalável usado comumente em VHDL para representar um único bit com nove estados possíveis,
-- incluindo lógica alta ('1'), lógica baixa ('0'), alta impedância ('Z'), entre outros. Este exemplo cria um sinal de clock
-- simples que oscila entre 0 e 1 a cada 10 nanosegundos, ilustrando como um sinal de clock é tipicamente gerado em simulações
-- e projetos de hardware digital.

library ieee; -- Inclui a biblioteca IEEE para acesso a tipos e funções padrões.
use ieee.std_logic_1164.all; -- Usa o pacote std_logic_1164 que define o tipo std_logic.

entity a005a_std_logic_tb is -- Declara a entidade do testbench, que não tem portas.
end entity;

architecture sim of a005a_std_logic_tb is -- Define a arquitetura de simulação para o testbench.
    signal clock : std_logic := '0'; -- Inicia o sinal de clock em '0'.
    
begin
    -- Processo que gera o sinal de clock.
    process is
    begin
        wait for 10 ns; -- Espera por 10 nanosegundos.
        clock <= not clock; -- Inverte o estado do sinal de clock, alternando entre '0' e '1'.
    end process;
    -- O processo é repetido indefinidamente, criando uma onda de clock de 20 ns de período (10 ns alto, 10 ns baixo).
end architecture;
