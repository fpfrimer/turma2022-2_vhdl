-- Este design VHDL implementa um multiplexador (mux) de 4 para 1 usando o comando 'case'.
-- O 'case' é utilizado para selecionar entre múltiplas fontes de entrada com base no valor
-- de um sinal de seleção ('sel'). Este código é otimizado para síntese, significando que pode
-- ser convertido diretamente em lógica de hardware. O 'case' facilita a implementação de
-- lógica condicional em designs de hardware, permitindo escolhas claras entre várias opções de sinal.

library ieee;
use ieee.std_logic_1164.all; -- Biblioteca padrão para o uso de sinais lógicos.
use ieee.numeric_std.all; -- Biblioteca para operações aritméticas e lógicas com tipos 'signed' e 'unsigned'.

entity a007a_mux is
    port(
        sig0, sig1, sig2, sig3  :   in  unsigned(7 downto 0); -- Entradas do mux, cada uma de 8 bits.
        sel                     :   in  unsigned(1 downto 0); -- Sinal de seleção de 2 bits para escolher entre as entradas.
        saida                   :   out unsigned(7 downto 0)); -- Saída do mux de 8 bits.
end entity;

architecture rtl of a007a_mux is
begin
    -- Processo sensível aos sinais de entrada e ao sinal de seleção.
    process(sel, sig0, sig1, sig2, sig3) is
    begin
        case sel is
            when "00" =>
                saida <= sig0; -- Se sel é "00", a saída é sig0.
            when "01" =>
                saida <= sig1; -- Se sel é "01", a saída é sig1.
            when "10" =>
                saida <= sig2; -- Se sel é "10", a saída é sig2.
            when "11" =>
                saida <= sig3; -- Se sel é "11", a saída é sig3.
            when others => -- Trata casos de valores indefinidos ou inesperados de 'sel'.
                saida <= (others => 'X'); -- Atribui 'X' (desconhecido) a toda a saída.
        end case;
    end process;
end rtl; -- Fim da arquitetura RTL.
