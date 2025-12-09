-- Este testbench VHDL foi projetado para demonstrar a execução de loops 'for' com sequências
-- numéricas em ordem crescente e decrescente. O objetivo é imprimir os números de 1 a 5 e, em seguida,
-- de 4 a 0 no console de simulação. Este exemplo ajuda a entender como controlar o fluxo de execução
-- com loops em VHDL e como utilizar o comando 'report' para visualizar valores durante a simulação.

entity a003b_for_loop_tb is
end entity;

architecture sim of a003b_for_loop_tb is
begin

    -- Thread
    imprime: process is -- o Rótulo "imprime é opcional"
    begin
        report "Start!"; -- Início do testbench
        
        -- Imprime os números de 1 a 5 com o comando report
        crescente: for i in 1 to 5 loop -- O o rótulo "crescente" é opcional
            report "i = " & integer'image(i);
        end loop;

        -- Imprime os números de 4 a 1 com o comando report
        descrescente: for i in 4 downto 0 loop -- O o rótulo "decrescente" é opcional
            report "i = " & integer'image(i);
        end loop;

        report "Ateh!";
        wait;
    end process;

    -- Os loops e reports executam sem atraso real de tempo, pois não incluímos 'wait for'.
    -- Isso significa que, embora reportemos diferentes etapas, a execução é quase instantânea.

end architecture;