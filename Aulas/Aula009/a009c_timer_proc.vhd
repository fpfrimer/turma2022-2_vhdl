library ieee;
use ieee.std_logic_1164.all;    -- Permite uso de tipos std_logic e std_logic_vector

entity a009c_timer_proc is 
    generic(
        clockFreq : integer := 50e6  -- Frequência de clock do sistema (padrao 50 MHz)
    );
    port(
        clk  : in       std_logic;       -- Sinal de clock de entrada
        nRst : in       std_logic;       -- Reset assíncrono ativo em nível baixo
        s    : buffer   integer;       -- Contador de segundos (0–59)
        m    : buffer   integer;       -- Contador de minutos (0–59)
        h    : buffer   integer        -- Contador de horas   (0–23)
    );
end entity;

architecture rtl of a009c_timer_proc is
    -- Sinal interno para acumular ciclos de clock até completar 1 segundo
    signal ticks : integer := 0;

    -- Procedimento auxiliares para incrementar contadores com estouro
    procedure incrementa(
        signal   contador : inout integer;   -- Variável de contagem a ser incrementada
        constant max       : in    integer;   -- Limite máximo antes de transbordo
        constant habilita  : in    boolean;   -- Habilita incremento quando true
        variable estouro   : out   boolean    -- Indica se houve transbordo no contador
    ) is
    begin
        estouro := false;                 -- Inicializa flag de estouro
        if habilita then                  -- Só incrementa se habilitado
            if contador = max - 1 then   -- Verifica condição de transbordo
                contador <= 0;           -- Reseta contador ao limite
                estouro := true;         -- Sinaliza que ocorreu transbordo
            else
                contador <= contador + 1;-- Incrementa contador normalmente
            end if;
        end if;
    end procedure;

begin
    -- Processo principal sensível a clk e nRst
    process(clk, nRst) is
        variable controle : boolean;      -- Variável para propagar flag de estouro entre procedimentos
    begin
        -- Tratamento de reset assíncrono
        if nRst = '0' then
            ticks <= 0;  -- Zera o acumulador de ciclos
            s     <= 0;  -- Zera segundos
            m     <= 0;  -- Zera minutos
            h     <= 0;  -- Zera horas

        -- A cada borda de descida do clock, atualiza contadores
        elsif falling_edge(clk) then
            -- Incrementa ticks e captura flag de estouro para 1 segundo
            incrementa(ticks, clockFreq, true, controle);
            -- Ao completar 1 segundo (controle=true), incrementa segundos
            incrementa(s, 60, controle, controle);
            -- Se houve transbordo de segundos, propaga para minutos
            incrementa(m, 60, controle, controle);
            -- Se houve transbordo de minutos, propaga para horas
            incrementa(h, 24, controle, controle);
        end if;
    end process;
end architecture;

-- Fim do módulo a009c_timer_proc.vhd
