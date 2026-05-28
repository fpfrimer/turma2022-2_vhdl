library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_sw_tb is
end entity;

architecture sim of uart_sw_tb is
    constant frequency_tb : integer := 1000;
    constant baudrate_tb  : integer := 100;
    constant delay_ms_tb  : integer := 1;

    constant clk_period : time := 1000 ms / frequency_tb;
    constant bit_period : time := 1000 ms / baudrate_tb;

    signal clk        : std_logic := '0';
    signal key        : std_logic_vector(1 downto 0) := (others => '1');
    signal sw         : std_logic_vector(9 downto 0) := (others => '0');
    signal ledr       : std_logic_vector(9 downto 0);
    signal arduino_io : std_logic_vector(15 downto 0);
    signal hex0       : std_logic_vector(6 downto 0);
    signal hex1       : std_logic_vector(6 downto 0);
    signal hex2       : std_logic_vector(6 downto 0);

    procedure recebe_byte(
        signal rx  : in  std_logic;
        variable ch : out std_logic_vector(7 downto 0)
    ) is
    begin
        wait until falling_edge(rx);

        wait for bit_period + bit_period / 2;
        for i in 0 to 7 loop
            ch(i) := rx;
            wait for bit_period;
        end loop;

        assert rx = '1'
            report "Bit de parada da UART deveria estar em nivel alto"
            severity error;
    end procedure;

    procedure confere_byte(
        signal rx       : in std_logic;
        constant esperado : in std_logic_vector(7 downto 0);
        constant contexto : in string
    ) is
        variable recebido : std_logic_vector(7 downto 0);
    begin
        recebe_byte(rx, recebido);

        assert recebido = esperado
            report contexto
            severity error;
    end procedure;

begin
    dut : entity work.uart_sw
        generic map (
            frequency => frequency_tb,
            baudrate  => baudrate_tb,
            delay_ms  => delay_ms_tb
        )
        port map (
            MAX10_CLK1_50 => clk,
            KEY           => key,
            SW            => sw,
            LEDR          => ledr,
            ARDUINO_IO    => arduino_io,
            HEX0          => hex0,
            HEX1          => hex1,
            HEX2          => hex2
        );

    clk <= not clk after clk_period / 2;

    stim_proc : process
    begin
        key(0) <= '0';
        wait for 3 * clk_period;
        key(0) <= '1';

        sw <= std_logic_vector(to_unsigned(0, sw'length));
        confere_byte(arduino_io(1), x"30", "Falha no valor 0: esperado caractere '0'");
        confere_byte(arduino_io(1), x"0A", "Falha no valor 0: esperado LF");

        sw <= std_logic_vector(to_unsigned(7, sw'length));
        confere_byte(arduino_io(1), x"37", "Falha no valor 7: esperado caractere '7'");
        confere_byte(arduino_io(1), x"0A", "Falha no valor 7: esperado LF");

        sw <= std_logic_vector(to_unsigned(42, sw'length));
        confere_byte(arduino_io(1), x"34", "Falha no valor 42: esperado caractere '4'");
        confere_byte(arduino_io(1), x"32", "Falha no valor 42: esperado caractere '2'");
        confere_byte(arduino_io(1), x"0A", "Falha no valor 42: esperado LF");

        sw <= std_logic_vector(to_unsigned(255, sw'length));
        confere_byte(arduino_io(1), x"32", "Falha no valor 255: esperado caractere '2'");
        confere_byte(arduino_io(1), x"35", "Falha no valor 255: esperado caractere '5'");
        confere_byte(arduino_io(1), x"35", "Falha no valor 255: esperado caractere '5'");
        confere_byte(arduino_io(1), x"0A", "Falha no valor 255: esperado LF");

        sw <= "01" & std_logic_vector(to_unsigned(12, 8));
        confere_byte(arduino_io(1), x"31", "Falha no valor 12 com CR: esperado caractere '1'");
        confere_byte(arduino_io(1), x"32", "Falha no valor 12 com CR: esperado caractere '2'");
        confere_byte(arduino_io(1), x"0D", "Falha no valor 12 com CR: esperado CR");

        sw <= "10" & std_logic_vector(to_unsigned(5, 8));
        confere_byte(arduino_io(1), x"35", "Falha no valor 5 com CRLF: esperado caractere '5'");
        confere_byte(arduino_io(1), x"0D", "Falha no valor 5 com CRLF: esperado CR");
        confere_byte(arduino_io(1), x"0A", "Falha no valor 5 com CRLF: esperado LF");

        report "Simulacao do uart_sw concluida com sucesso";
        wait;
    end process;

end architecture;
