library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uart_sw is
    generic (
        frequency : integer := 50000000;
        baudrate  : integer := 115200;
        delay_ms  : integer := 200
    );
    port (
        MAX10_CLK1_50 : in    std_logic;
        KEY           : in    std_logic_vector(1 downto 0);
        SW            : in    std_logic_vector(9 downto 0);
        LEDR          : out   std_logic_vector(9 downto 0);
        ARDUINO_IO    : inout std_logic_vector(15 downto 0);
        HEX0          : out   std_logic_vector(6 downto 0);
        HEX1          : out   std_logic_vector(6 downto 0);
        HEX2          : out   std_logic_vector(6 downto 0)
    );
end entity;

architecture rtl of uart_sw is

    type state_type is (IDLE, LOAD_BYTE, WAIT_BYTE);
    type tx_buffer_type is array(0 to 4) of std_logic_vector(7 downto 0);

    alias clk   : std_logic is MAX10_CLK1_50;
    alias rst_n : std_logic is KEY(0);
    alias data  : std_logic_vector(7 downto 0) is SW(7 downto 0);

    constant baud_cycles  : integer := frequency / baudrate;
    constant delay_cycles : integer := (frequency / 1000) * delay_ms;

    signal state      : state_type := IDLE;
    signal tx_buffer  : tx_buffer_type := (others => (others => '0'));
    signal char_index : integer range 0 to 4 := 0;
    signal last_index : integer range 0 to 4 := 0;

    signal tx      : std_logic := '1';
    signal tx_en   : std_logic := '0';
    signal tx_done : std_logic := '0';
    signal tx_load : std_logic := '0';
    signal tx_reg  : std_logic_vector(9 downto 0) := (others => '1');
    signal tx_data : std_logic_vector(7 downto 0) := (others => '0');

    -- Converts an 8-bit binary value to three BCD digits using double dabble.
    function to_bcd(value : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable bcd_value : unsigned(11 downto 0) := (others => '0');
    begin
        for i in 7 downto 0 loop
            if bcd_value(3 downto 0) > to_unsigned(4, 4) then
                bcd_value(3 downto 0) := bcd_value(3 downto 0) + to_unsigned(3, 4);
            end if;

            if bcd_value(7 downto 4) > to_unsigned(4, 4) then
                bcd_value(7 downto 4) := bcd_value(7 downto 4) + to_unsigned(3, 4);
            end if;

            if bcd_value(11 downto 8) > to_unsigned(4, 4) then
                bcd_value(11 downto 8) := bcd_value(11 downto 8) + to_unsigned(3, 4);
            end if;

            bcd_value := bcd_value(10 downto 0) & value(i);
        end loop;

        return std_logic_vector(bcd_value);
    end function;

    -- Active-low seven-segment encoding: HEX(0)=a, ..., HEX(6)=g.
    function bcd_to_7seg(bcd_digit : std_logic_vector(3 downto 0)) return std_logic_vector is
        variable seg : std_logic_vector(6 downto 0);
    begin
        case bcd_digit is
            when "0000" => seg := "1000000"; -- 0
            when "0001" => seg := "1111001"; -- 1
            when "0010" => seg := "0100100"; -- 2
            when "0011" => seg := "0110000"; -- 3
            when "0100" => seg := "0011001"; -- 4
            when "0101" => seg := "0010010"; -- 5
            when "0110" => seg := "0000010"; -- 6
            when "0111" => seg := "1111000"; -- 7
            when "1000" => seg := "0000000"; -- 8
            when "1001" => seg := "0010000"; -- 9
            when others => seg := "1111111"; -- blank
        end case;

        return seg;
    end function;

begin

    ARDUINO_IO <= (1 => tx, others => 'Z');

    LEDR <= "00" & data;

    process(data) is
        variable display_bcd : std_logic_vector(11 downto 0);
    begin
        display_bcd := to_bcd(data);

        HEX0 <= bcd_to_7seg(display_bcd(3 downto 0));
        HEX1 <= bcd_to_7seg(display_bcd(7 downto 4));
        HEX2 <= bcd_to_7seg(display_bcd(11 downto 8));
    end process;

    -- UART transmitter: 8 data bits, no parity, one stop bit.
    -- busy is internal to this process: it blocks a new tx_load while a frame is active.
    -- tx_done is the external one-clock pulse used by the FSM to request the next byte.
    process(clk, rst_n)
        variable bit_count : integer range 0 to 10 := 0;
        variable busy      : std_logic := '0';
    begin
        if rst_n = '0' then
            tx        <= '1';
            tx_done   <= '0';
            tx_reg    <= (others => '1');
            bit_count := 0;
            busy      := '0';
        elsif rising_edge(clk) then
            tx_done <= '0';

            if tx_load = '1' and busy = '0' then
                tx_reg    <= '1' & tx_data & '0';
                busy      := '1';
                bit_count := 0;
            elsif tx_en = '1' and busy = '1' then
                if bit_count < 10 then
                    tx        <= tx_reg(bit_count);
                    bit_count := bit_count + 1;
                else
                    tx        <= '1';
                    tx_done   <= '1';
                    bit_count := 0;
                    busy      := '0';
                end if;
            end if;
        end if;
    end process;

    -- Generates one clock-wide enable pulses at the configured baud rate.
    process(clk, rst_n)
        variable baud_count : integer range 0 to baud_cycles := 0;
    begin
        if rst_n = '0' then
            tx_en      <= '0';
            baud_count := 0;
        elsif rising_edge(clk) then
            if baud_count < baud_cycles - 1 then
                baud_count := baud_count + 1;
                tx_en      <= '0';
            else
                baud_count := 0;
                tx_en      <= '1';
            end if;
        end if;
    end process;

    -- Sends the decimal switch value as ASCII without leading zeroes.
    -- SW(9 downto 8) selects the line ending:
    --   00: LF, 01: CR, 10: CRLF, 11: no line ending.
    process(clk, rst_n)
        variable delay_count : integer range 0 to delay_cycles := 0;
        variable captured_bcd : std_logic_vector(11 downto 0);
    begin
        if rst_n = '0' then
            state       <= IDLE;
            tx_load     <= '0';
            char_index  <= 0;
            last_index  <= 0;
            tx_buffer   <= (others => (others => '0'));
            delay_count := 0;
        elsif rising_edge(clk) then
            tx_load <= '0';

            case state is
                when IDLE =>
                    if delay_count < delay_cycles - 1 then
                        delay_count := delay_count + 1;
                    else
                        delay_count := 0;
                        captured_bcd := to_bcd(data);

                        tx_buffer(0) <= x"3" & captured_bcd(11 downto 8);
                        tx_buffer(1) <= x"3" & captured_bcd(7 downto 4);
                        tx_buffer(2) <= x"3" & captured_bcd(3 downto 0);

                        case SW(9 downto 8) is
                            when "00" =>
                                tx_buffer(3) <= x"0A"; -- LF
                                last_index   <= 3;

                            when "01" =>
                                tx_buffer(3) <= x"0D"; -- CR
                                last_index   <= 3;

                            when "10" =>
                                tx_buffer(3) <= x"0D"; -- CR
                                tx_buffer(4) <= x"0A"; -- LF
                                last_index   <= 4;

                            when others =>
                                last_index   <= 2;     -- no line ending
                        end case;

                        if captured_bcd(11 downto 8) /= "0000" then
                            char_index <= 0;
                        elsif captured_bcd(7 downto 4) /= "0000" then
                            char_index <= 1;
                        else
                            char_index <= 2;
                        end if;

                        state <= LOAD_BYTE;
                    end if;

                when LOAD_BYTE =>
                    tx_data <= tx_buffer(char_index);
                    tx_load <= '1';
                    state   <= WAIT_BYTE;

                when WAIT_BYTE =>
                    if tx_done = '1' then
                        if char_index = last_index then
                            state <= IDLE;
                        else
                            char_index <= char_index + 1;
                            state      <= LOAD_BYTE;
                        end if;
                    end if;

                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end architecture;
