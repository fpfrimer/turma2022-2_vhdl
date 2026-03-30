-- Este testbench VHDL demonstra o uso do comando 'next' para pular iterações em um loop.
-- O comando 'next' ignora o restante do codigo na iteracao atual e passa para a proxima.
-- Exemplo: imprime apenas numeros impares de 1 a 10, pulando os pares com 'next'.

entity a003j_next_example_tb is
end entity;

architecture sim of a003j_next_example_tb is
begin
    process
    begin
        report "**** INICIO ****";
        report "Imprimindo apenas numeros impares de 1 a 10:";

        for i in 1 to 10 loop
            -- Pula a iteracao se o numero for par
            next when i mod 2 = 0;

            -- So executa para numeros impares
            report "Numero impar: " & integer'image(i);
        end loop;

        report "**** FIM ****";
        wait;
    end process;
end architecture;
