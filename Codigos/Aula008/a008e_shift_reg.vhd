-- Este módulo VHDL implementa um registro de deslocamento de 4 bits.
-- O registro de deslocamento aceita um bit de entrada e o desloca através
-- de um vetor de 4 bits a cada borda de subida do clock, enquanto que o bit mais
-- antigo é exposto como saída.
-- Fonte: https://embarcados.com.br/implementacao-de-um-shift-register-em-vhdl/

library ieee;
use ieee.std_logic_1164.all;  -- Inclui os tipos de lógica padrão.

entity a008e_shift_reg is
    port (
        sys_clk : in std_logic;         -- Clock do sistema
        sys_rst : in std_logic;         -- Reset assíncrono (ativa em baixo)
        dado_entrada : in std_logic;    -- Bit de entrada para o registro de deslocamento
        dado_saida : out std_logic      -- Bit de saída do registro de deslocamento
    );
end a008e_shift_reg;

architecture rtl of a008e_shift_reg is
    signal dado_registrado : std_logic_vector(3 downto 0);  -- Vetor interno de 4 bits para o registro de deslocamento
begin
    dado_saida <= dado_registrado(3);  -- Atribui o bit mais significativo do vetor ao dado de saída

    -- Processo para controlar o estado do registro de deslocamento
    process(sys_clk, sys_rst)
    begin
        if (sys_rst = '0') then
            dado_registrado <= "0000";  -- Reseta o registro de deslocamento para 0000 quando sys_rst é ativado
        elsif rising_edge(sys_clk) then
            dado_registrado(0) <= dado_entrada;             -- Desloca o bit de entrada para a posição mais baixa
            dado_registrado(1) <= dado_registrado(0);       -- Desloca o conteúdo de cada bit para a posição subsequente
            dado_registrado(2) <= dado_registrado(1);
            dado_registrado(3) <= dado_registrado(2);
        end if;
    end process;
end rtl;

 