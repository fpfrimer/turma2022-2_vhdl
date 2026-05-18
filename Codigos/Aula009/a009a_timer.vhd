-- Codigo em VHDL que representa um timer com mostrador de horas, minutos e segundos
-- Versao usando unsigned para explicitar a representacao binaria dos contadores.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a009a_timer is 
    generic(
        clockFreq : positive := 10  -- Frequencia de entrada em Hz (padrao: 10 Hz)
    );
    port(
        clk   : in  std_logic;             -- Sinal de clock para contagem
        nRst  : in  std_logic;             -- Reset assincrono ativo em nivel baixo
        s     : out unsigned(5 downto 0);  -- Contador de segundos (0 a 59)
        m     : out unsigned(5 downto 0);  -- Contador de minutos (0 a 59)
        h     : out unsigned(4 downto 0)   -- Contador de horas (0 a 23)
    );
end entity;

architecture rtl of a009a_timer is
    -- Calcula quantos bits sao necessarios para representar valores ate n - 1.
    function bits_necessarios(n : positive) return natural is
        variable valor : natural := n - 1;
        variable bits  : natural := 0;
    begin
        while valor > 0 loop
            bits  := bits + 1;
            valor := valor / 2;
        end loop;

        if bits = 0 then
            return 1;
        else
            return bits;
        end if;
    end function;

    -- Sinais internos para guardar o estado do timer.
    signal ticks  : unsigned(bits_necessarios(clockFreq) - 1 downto 0) := (others => '0');
    signal segReg : unsigned(5 downto 0) := (others => '0');
    signal minReg : unsigned(5 downto 0) := (others => '0');
    signal horReg : unsigned(4 downto 0) := (others => '0');
begin
    -- As portas de saida apenas expõem os registradores internos.
    s <= segReg;
    m <= minReg;
    h <= horReg;

    process(clk, nRst) is
    begin
        -- Tratamento de reset assincrono:
        if nRst = '0' then
            ticks  <= (others => '0');
            segReg <= (others => '0');
            minReg <= (others => '0');
            horReg <= (others => '0');

        -- A cada borda de descida do clock, incrementa ticks.
        elsif falling_edge(clk) then
            -- Verifica se completou 1 segundo (ticks == clockFreq - 1).
            if ticks = to_unsigned(clockFreq - 1, ticks'length) then
                ticks <= (others => '0');

                -- Incrementa segundos e trata transbordo.
                if segReg = to_unsigned(59, segReg'length) then
                    segReg <= (others => '0');

                    -- Incrementa minutos e trata transbordo de minuto.
                    if minReg = to_unsigned(59, minReg'length) then
                        minReg <= (others => '0');

                        -- Incrementa horas e trata transbordo diario.
                        if horReg = to_unsigned(23, horReg'length) then
                            horReg <= (others => '0');
                        else
                            horReg <= horReg + 1;
                        end if;
                    else
                        minReg <= minReg + 1;
                    end if;
                else
                    segReg <= segReg + 1;
                end if;

            else
                -- Ainda nao completou 1 segundo: incrementa ticks.
                ticks <= ticks + 1;
            end if;
        end if;
    end process;
end architecture;

-- Fim do modulo a009a_timer.vhd
