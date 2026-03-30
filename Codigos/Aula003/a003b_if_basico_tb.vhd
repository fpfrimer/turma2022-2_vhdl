-- Este testbench VHDL demonstra o uso básico da estrutura condicional 'if'.
-- O comando 'if' permite executar código apenas quando uma condição é verdadeira.
-- Este exemplo mostra as formas básica, com 'else' e com 'elsif'.

entity a003b_if_basico_tb is
end entity;

architecture sim of a003b_if_basico_tb is
    signal valor : integer := 5;
begin
    process
    begin
        report "**** INICIO ****";

        -- Exemplo 1: if simples
        if valor = 5 then
            report "valor eh igual a 5";
        end if;

        -- Exemplo 2: if com else
        if valor > 10 then
            report "valor eh maior que 10";
        else
            report "valor eh menor ou igual a 10";
        end if;

        -- Exemplo 3: if com elsif e else
        if valor < 5 then
            report "valor eh menor que 5";
        elsif valor = 5 then
            report "valor eh igual a 5";
        else
            report "valor eh maior que 5";
        end if;

        report "**** FIM ****";
        wait;
    end process;
end architecture;
