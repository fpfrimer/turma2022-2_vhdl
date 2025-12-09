-- Este testbench VHDL é projetado para demonstrar o uso dos tipos 'unsigned' e 'signed', ambos baseados no tipo 'std_logic_vector'.
-- Diferente do 'std_logic_vector', os tipos 'unsigned' e 'signed' permitem realizar operações aritméticas diretamente sobre os sinais.
-- O 'unsigned' é usado para representar números binários sem sinal, enquanto o 'signed' é usado para representar números com sinal.
-- Este código inicializa contadores e realiza operações aritméticas básicas, ilustrando como operações como adição são aplicadas a esses tipos.

library ieee;
use ieee.std_logic_1164.all;         -- Biblioteca padrão para tipos 'std_logic' e 'std_logic_vector'.
use ieee.numeric_std.all;            -- Biblioteca que fornece os tipos 'unsigned' e 'signed' e operações aritméticas.

entity a005c_sig_unsig_tb is
end entity;

architecture sim of a005c_sig_unsig_tb is
    -- Sinais definidos como 'unsigned' e 'signed' para demonstrar operações aritméticas.
    signal UnsCnt   : unsigned(7 downto 0) := (others => '0');  -- Contador 'unsigned', iniciado em 0.
    signal SigCnt   : signed(7 downto 0) := (others => '0');    -- Contador 'signed', também iniciado em 0.

    signal Uns4   : unsigned(3 downto 0) := "1000";  -- Um valor 'unsigned' pequeno para operações de adição.
    signal Sig4   : signed(3 downto 0) := "1000";    -- Um valor 'signed' correspondente para comparação.

    signal Uns8   : unsigned(7 downto 0) := (others => '0');  -- Sinal 'unsigned' para acumular resultados de adições.
    signal Sig8   : signed(7 downto 0) := (others => '0');    -- Sinal 'signed' para acumular resultados de adições.

begin
    -- Processo para demonstrar a atualização e adição usando 'unsigned' e 'signed'.
    process is
    begin
        wait for 10 ns; -- Espera 10 nanosegundos entre cada operação.
        -- Incrementa ambos os contadores em 1 a cada ciclo.
        UnsCnt <= UnsCnt + 1;  -- Adição simples em 'unsigned'.
        SigCnt <= SigCnt + 1;  -- Adição simples em 'signed'.

        -- Realiza adições entre diferentes sinais 'unsigned' e 'signed'.
        Uns8 <= Uns8 + Uns4;  -- Adição entre sinais 'unsigned'.
        Sig8 <= Sig8 + Sig4;  -- Adição entre sinais 'signed'.
    end process; -- Encerra o processo após cada ciclo de simulação.
end architecture;
