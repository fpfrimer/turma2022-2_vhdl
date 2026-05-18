library ieee;
use ieee.std_logic_1164.all;

use std.env.stop;

entity a009e_timer_proc_top_tb is
end entity;

architecture sim of a009e_timer_proc_top_tb is
    constant clockFreq : positive := 10;
    constant clkPer    : time     := 1000 ms / clockFreq;

    signal clk : std_logic := '0';
    signal key : std_logic_vector(0 downto 0) := (others => '0');

    signal HEX0, HEX1 : std_logic_vector(0 to 6);
    signal HEX2, HEX3 : std_logic_vector(0 to 6);
    signal HEX4, HEX5 : std_logic_vector(0 to 6);

    constant SEG_0 : std_logic_vector(0 to 6) := not "1111110";
    constant SEG_1 : std_logic_vector(0 to 6) := not "0110000";
begin
    dut: entity work.a009e_timer_proc_top(main)
        generic map(
            clockFreq => clockFreq
        )
        port map(
            MAX10_CLK1_50 => clk,
            KEY           => key,
            HEX0          => HEX0,
            HEX1          => HEX1,
            HEX2          => HEX2,
            HEX3          => HEX3,
            HEX4          => HEX4,
            HEX5          => HEX5
        );

    clk <= not clk after clkPer / 2;

    process is
    begin
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        key(0) <= '1';

        wait until HEX0 = SEG_1;
        assert HEX1 = SEG_0 and HEX2 = SEG_0 and HEX3 = SEG_0 and HEX4 = SEG_0 and HEX5 = SEG_0
            report "Falha ao exibir 00:00:01 no top-level"
            severity failure;

        wait until HEX2 = SEG_1;
        assert HEX0 = SEG_0 and HEX1 = SEG_0 and HEX3 = SEG_0 and HEX4 = SEG_0 and HEX5 = SEG_0
            report "Falha ao exibir 00:01:00 no top-level"
            severity failure;

        report "Simulacao do top-level com unsigned concluida com sucesso";
        stop;
    end process;
end architecture;
