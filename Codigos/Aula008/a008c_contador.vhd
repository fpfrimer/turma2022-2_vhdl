-- Este módulo VHDL define um contador ascendente genérico. Ele usa
-- uma entidade genérica que permite definir o número de bits do contador.
-- O contador incrementa a cada borda de subida do clock e é
-- resetado assincronamente através do sinal nRst.

library ieee;
use ieee.std_logic_1164.all;      -- Inclui os tipos de lógica padrão.
use ieee.numeric_std.all;         -- Inclui tipos e operações numéricas.

entity a008c_contador is
    generic(
        n   : integer := 8          -- Número de bits do contador.
    );
    port(
        clk, nRst : in std_logic;   -- 'clk' é o clock de entrada e 'nRst' é o reset assíncrono.
        q         : out unsigned(n - 1 downto 0) -- Saída do contador, de tamanho 'n'.
    );
end entity;

architecture rtl of a008c_contador is
    signal q_temp : unsigned(n - 1 downto 0); -- Sinal interno para manter o valor atual do contador.
begin
    -- Processo que define o comportamento do contador.
    process(clk, nRst) is
    begin
        if nRst = '0' then              -- Se nRst é 0, reseta o contador.
            q_temp <= (others => '0');  -- Define todos os bits de q_temp para 0.
        elsif rising_edge(clk) then     -- Verifica se há uma borda de subida no clock.
            q_temp <= q_temp + 1;       -- Incrementa o valor do contador.
        end if;
    end process;
    q <= q_temp;                        -- Atribui o valor temporário ao sinal de saída.
end architecture;
