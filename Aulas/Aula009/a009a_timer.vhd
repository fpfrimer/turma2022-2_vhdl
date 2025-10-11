-- Código em VHDL que representa um timer com mostrador de horas, minutos e segundos

library ieee;
use ieee.std_logic_1164.all;    -- permite uso de std_logic ou slv

entity a009a_timer is 
    generic(
        clockFreq : integer := 10  -- Frequência de entrada em Hz (padrão: 10 Hz)
    );
    port(
        clk   : in      std_logic;                    -- Sinal de clock para contagem
        nRst  : in      std_logic;                    -- Reset assíncrono ativo em nível baixo
        s     : buffer  integer range 0 to 60;        -- Contador de segundos (0–59)
        m     : buffer  integer range 0 to 60;        -- Contador de minutos (0–59)
        h     : buffer  integer range 0 to 24         -- Contador de horas (0–23)
    );
end entity;

architecture rtl of a009a_timer is
    -- Sinal interno para acumular ciclos de clock até completar 1 segundo
    signal ticks : integer range 0 to clockFreq := 0;
begin

    process(clk, nRst) is
    begin
        -- Tratamento de reset assíncrono:
        if nRst = '0' then
            ticks <= 0;    -- Zera contador de ticks
            s     <= 0;    -- Zera segundos
            m     <= 0;    -- Zera minutos
            h     <= 0;    -- Zera horas

        -- A cada borda de descida do clock, incrementa ticks
        elsif falling_edge(clk) then
            -- Verifica se completou 1 segundo (ticks == clockFreq - 1)
            if ticks = clockFreq - 1 then
                ticks <= 0;  -- Reinicia contador de ticks

                -- Incrementa segundos e trata transbordo
                if s = 59 then
                    s <= 0;  -- Reseta segundos ao chegar a 59

                    -- Incrementa minutos e trata transbordo de minuto
                    if m = 59 then
                        m <= 0;  -- Reseta minutos ao chegar a 59

                        -- Incrementa horas e trata transbordo diário
                        if h = 23 then
                            h <= 0;  -- Reseta horas ao chegar a 23 (novo dia)
                        else
                            h <= h + 1;  -- Incrementa hora
                        end if;
                    else
                        m <= m + 1;  -- Incrementa minuto
                    end if;
                else
                    s <= s + 1;  -- Incrementa segundo
                end if;

            else
                -- Ainda não completou 1 segundo: incrementa ticks
                ticks <= ticks + 1;
            end if;
        end if;
    end process;
end architecture;

-- Fim do módulo a009a_timer.vhd
