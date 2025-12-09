-- Este código em VHDL tem o intuito de mostrar como implementar um Flip-Flop tipo D
-- em VHDL. A detecção da borda de clock é feita pela função rising_edge() ou falling_edge.


library ieee;
use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;

entity a008a_flipFlop is
    port(
        clk     :   in  std_logic;  -- Sinal de clock de entrada
        nRst    :   in  std_logic;  -- Reset assíncrono ativo em nível baixo
        d       :   in  std_logic;  -- Entrada de dado do Flip-Flop D
        q       :   out std_logic   -- Saída registrada
    );
end entity;

architecture rtl of a008a_flipFlop is
begin

    -- Versão com reset síncrono (comentada)
    -- process(clk) is
    -- begin
    --     if rising_edge(clk) then  --  falling_edge()  -- Verifica borda de subida/descida do clock
    --         if nRst = '0' then       -- Se reset ativo, força q a '0'
    --             q <= '0';
    --         else                     -- Caso contrário, captura valor de 'd'
    --             q <= d;
    --         end if;
    --     end if;
    -- end process;

    -- Processo principal com reset assíncrono e detecção de borda
    process(clk, nRst) is        
    begin
        -- Reset assíncrono: independentemente do clock, se nRst for '0' zera q
        if nRst = '0' then
            q <= '0';            
        -- Detecção de borda de subida do clock após reset inativo
        elsif rising_edge(clk) then    -- Pode usar falling_edge para borda descendente
            q <= d;                  -- Atribui valor de 'd' a 'q' na borda de clock
        end if;
    end process;

end architecture;

-- Alternativa de detecção de borda usando evento:
-- if clk'event and clk = '1' then
--     -- Captura em borda de subida sem função rising_edge
--     q <= d;
-- end if;
