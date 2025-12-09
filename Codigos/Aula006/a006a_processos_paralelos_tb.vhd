-- Este testbench VHDL demonstra a execução simultânea de múltiplos processos, 
-- destacando como diferentes processos podem operar em paralelo e modificar sinais de forma independente.
-- Usando os tipos 'unsigned' do pacote ieee.numeric_std e 'std_logic' do ieee.std_logic_1164,
-- este exemplo cria vários processos que executam operações aritméticas e lógicas, 
-- além de simular a geração de um sinal de clock e o controle de reset.

library ieee;
use ieee.std_logic_1164.all; -- Importa tipos e operações para std_logic e std_logic_vector.
use ieee.numeric_std.all;    -- Importa tipos e operações para signed e unsigned.

entity a006a_processos_paralelos_tb is
end entity;

architecture sim of a006a_processos_paralelos_tb is
    -- Sinais usados para demonstração de operações paralelas e manipulação de sinal.
    signal Uns   : unsigned(5 downto 0) := (others => '0'); -- Contador incrementado a cada 10 ns.
    signal Mul1, Mul2, Mul3  : unsigned(7 downto 0); -- Resultados de multiplicação.
    signal clk, rst : std_logic := '0'; -- Sinais de clock e reset.
    
begin

    -- Processo para incrementar 'Uns' a cada 10 ns.
    process is
    begin
        Uns <= Uns + 1;
        wait for 10 ns;                
    end process;
    
    -- Multiplica 'Uns' por 4, usando concatenação para adicionar dois bits zero.
    process is
    begin
        Mul1 <= Uns & "00"; -- A concatenação simula uma multiplicação por 4.
        wait on Uns; -- Este processo reage a mudanças em 'Uns'.
    end process;

    -- Multiplica 'Uns' por 4, equivalente ao processo anterior.
    process(Uns) is
    begin
        Mul2 <= Uns & "00"; -- Utiliza uma lista de sensibilidade explicitamente definida.
    end process;

    -- Multiplicação de forma concorrente, demonstrando alternativa aos processos.
    Mul3 <= Uns & "00"; -- Execução concorrente que replica a funcionalidade do processo.

    -- Geração de clock através de um sinal concorrente.
    clk <= not clk after 10 ns; -- Inverte o clock a cada 10 ns.
    
    -- Controle de reset concorrente com múltiplas transições.
    rst <= '1' after 35 ns, '0' after 55 ns; -- Define um pulso de reset.
    
end architecture;
