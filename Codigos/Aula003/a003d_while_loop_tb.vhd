-- Este testbench VHDL utiliza um loop 'while' para imprimir os números pares de 0 a 20 no console de simulação.
-- A variável 'i' controla as iterações do loop e é inicializada em 0. Este exemplo é útil para aprender como controlar
-- fluxos de execução usando loops em VHDL e como variáveis são declaradas e utilizadas dentro de processos.

entity a003d_while_loop_tb is
end entity;

architecture sim of a003d_while_loop_tb is
begin

    -- Define um único processo chamado 'imprime_pares'
    imprime_pares: process is
        -- Declaração de uma variável 'i' com range de 0 a 20. O range restringe os valores que 'i' pode assumir,
        -- proporcionando segurança adicional ao evitar valores fora do esperado. Caso seja omitido, o inteiro é de 32 bits
        variable i  :   integer range 0 to 20 := 0; -- Verifique a forma que a variável foi declarada
       -- Declarações de variáveis e outros objetos são feitos sempre antes da palavra begin
    begin
        report "Start!";
        
        while i <= 20 loop
            report "i = " & integer'image(i); -- Imprime i
            i := i + 2;
        end loop;

        report "Ateh!";
        wait;
    end process;

end architecture;