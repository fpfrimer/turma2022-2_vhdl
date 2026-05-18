library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a009e_timer_proc_top is
    generic(
        clockFreq : positive := 50e6  -- Valor padrao para o clock de 50 MHz da DE10-Lite
    );
    port(
        MAX10_CLK1_50 : in  std_logic;                   -- Clock principal de 50 MHz do FPGA
        KEY           : in  std_logic_vector(0 downto 0); -- Botao de reset (indice 0)
        HEX0, HEX1    : out std_logic_vector(0 to 6);     -- Displays de segundos
        HEX2, HEX3    : out std_logic_vector(0 to 6);     -- Displays de minutos
        HEX4, HEX5    : out std_logic_vector(0 to 6)      -- Displays de horas
    );
end entity;

architecture main of a009e_timer_proc_top is
    -- Sinais internos que recebem valores de segundos, minutos e horas do timer.
    signal segundos : unsigned(5 downto 0) := (others => '0');
    signal minutos  : unsigned(5 downto 0) := (others => '0');
    signal horas    : unsigned(4 downto 0) := (others => '0');
begin
    -- Instancia decodificador para segundos (unidade: HEX0, dezena: HEX1).
    decod_s: entity work.a009d_decod(rtl)
        port map(
            contador => segundos,
            d0       => HEX0,
            d1       => HEX1
        );

    -- Instancia decodificador para minutos (unidade: HEX2, dezena: HEX3).
    decod_m: entity work.a009d_decod(rtl)
        port map(
            contador => minutos,
            d0       => HEX2,
            d1       => HEX3
        );

    -- Instancia decodificador para horas (unidade: HEX4, dezena: HEX5).
    decod_h: entity work.a009d_decod(rtl)
        port map(
            contador => resize(horas, 6),
            d0       => HEX4,
            d1       => HEX5
        );

    -- Instancia o timer com procedimento.
    timer_0: entity work.a009c_timer_proc(rtl)
        generic map(
            clockFreq => clockFreq
        )
        port map(
            clk  => MAX10_CLK1_50,
            nRst => KEY(0),
            s    => segundos,
            m    => minutos,
            h    => horas
        );
end architecture;

-- Fim do a009e_timer_proc_top.vhd
