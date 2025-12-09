library ieee;
use ieee.std_logic_1164.all; -- Biblioteca para sinais lógicos
use ieee.numeric_std.all;    -- Biblioteca para conversões numéricas

entity a009e_timer_proc_top is
    port(
        MAX10_CLK1_50 : in  std_logic;                   -- Clock principal de 50 MHz do FPGA
        -- KEY foi definido como vetor para compatibilidade com o template DE10-Lite
        KEY           : in  std_logic_vector(0 downto 0); -- Botão de reset (índice 0)
        HEX0, HEX1    : out std_logic_vector(0 to 6);     -- Saídas para display 7-segundos (unidade e dezena)
        HEX2, HEX3    : out std_logic_vector(0 to 6);     -- Saídas para display 7-minutos (unidade e dezena)
        HEX4, HEX5    : out std_logic_vector(0 to 6)      -- Saídas para display 7-horas   (unidade e dezena)
    );
end entity;

architecture main of a009e_timer_proc_top is
    -- Sinais internos que recebem valores de segundos, minutos e horas do timer
    signal a, b, c : integer range 0 to 60;
begin
    -- Instancia decodificador para segundos (unidade: HEX0, dezena: HEX1)
    decod_s: entity work.a009d_decod(rtl)
        port map(
            contador => a,    -- Valor de segundos
            d0       => HEX0, -- Segmentos da unidade
            d1       => HEX1  -- Segmentos da dezena
        );

    -- Instancia decodificador para minutos (unidade: HEX2, dezena: HEX3)
    decod_m: entity work.a009d_decod(rtl)
        port map(
            contador => b,    -- Valor de minutos
            d0       => HEX2, -- Segmentos da unidade
            d1       => HEX3  -- Segmentos da dezena
        );

    -- Instancia decodificador para horas (unidade: HEX4, dezena: HEX5)
    decod_h: entity work.a009d_decod(rtl)
        port map(
            contador => c,    -- Valor de horas
            d0       => HEX4, -- Segmentos da unidade
            d1       => HEX5  -- Segmentos da dezena
        );

    -- Instancia o timer com procedimento para atualizar a, b, c
    timer_0: entity work.a009c_timer_proc(rtl)
        generic map(
            clockFreq => 50e6  -- Configura frequência de 50 MHz para conta de ticks
        )
        port map(
            clk  => MAX10_CLK1_50, -- Clock de entrada do FPGA
            nRst => KEY(0),        -- Reset assíncrono ativo em '0'
            s    => a,             -- Contador de segundos conectado a 'a'
            m    => b,             -- Contador de minutos conectado a 'b'
            h    => c              -- Contador de horas conectado a 'c'
        );
end architecture;

-- Fim do a009e_timer_proc_top.vhd
