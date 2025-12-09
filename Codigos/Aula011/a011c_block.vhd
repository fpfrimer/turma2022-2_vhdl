library ieee;                                  -- Importa a biblioteca padrão IEEE
use ieee.std_logic_1164.all;                   -- Importa os tipos de sinais lógicos padrão (std_logic, etc.)

entity blinker is
    port (
        clk : in std_logic;                    -- Sinal de clock de entrada
        sw 	: in std_logic_vector(1 downto 0); -- Vetor de switches para seleção de frequência
        led : out std_logic                    -- Saída de controle do LED
    );
end entity;

architecture behavior of blinker is

    -- define um array de inteiros (necessário no vhdl 1993)
	type int_array is array(natural range <>) of integer range 1 to 31;
	 
	-- Define a frequência de operação e os períodos para 1 Hz, 5 Hz e 10 Hz
    constant clk_freq       : natural := 50_000_000;             -- Frequência do clock do sistema (50 MHz)
	constant blink_freqs    : int_array(0 to 2) := (1, 5, 10);    -- Frequências desejadas para piscar o LED
    
	-- Saída dos contadores para cada frequência 
    signal osc		:	std_logic_vector(0 to 2) := (others => '0'); -- Vetor de sinais que controlam o LED em cada frequência
	 
begin 

    -- Selecionar o período baseado nas switches
    with sw select
        led <=  osc(0) when "00",     -- Quando sw = "00", o LED pisca com a saída osc(0) (1 Hz)
                osc(1) when "01",     -- Quando sw = "01", o LED pisca com osc(1) (5 Hz)
                osc(2) when others;   -- Qualquer outro valor, usa osc(2) (10 Hz)

    -- 1 Hz
    F1HZ:   block                                              -- Bloco nomeado F1HZ para geração de 1 Hz
        signal counter : natural range 0 to 50e6 := 0;         -- Sinal contador para controlar a frequência de 1 Hz
    begin
        process(clk)	                                        -- Processo sensível ao clock
        begin
            if rising_edge(clk) then                          -- Verifica borda de subida do clock
                if counter >= clk_freq / blink_freqs(0) / 2 then  -- Se contador atingir meio período de 1 Hz
                    -- Inverter o estado do LED e reiniciar o contador
                    osc(0) <= not osc(0);                      -- Inverte a saída correspondente a 1 Hz
                    counter <= 0;                              -- Reinicia o contador
                else
                    counter <= counter + 1;                    -- Incrementa o contador
                end if;            
            end if;
        end process;
    end block F1HZ;
	 
	-- 5 Hz
    F5HZ:   block                                              -- Bloco nomeado F5HZ para geração de 5 Hz
        signal counter : natural range 0 to 50e6 := 0;         -- Sinal contador para controlar a frequência de 5 Hz
    begin
        process(clk)	                                        -- Processo sensível ao clock
        begin
            if rising_edge(clk) then                          -- Verifica borda de subida do clock
                if counter >= clk_freq / blink_freqs(1) / 2 then  -- Se contador atingir meio período de 5 Hz
                    -- Inverter o estado do LED e reiniciar o contador
                    osc(1) <= not osc(1);                      -- Inverte a saída correspondente a 5 Hz
                    counter <= 0;                              -- Reinicia o contador
                else
                    counter <= counter + 1;                    -- Incrementa o contador
                end if;            
            end if;
        end process;
    end block F5HZ;
	 
	-- 10 Hz
    F10HZ:   block                                             -- Bloco nomeado F10HZ para geração de 10 Hz
        signal counter : natural range 0 to 50e6 := 0;         -- Sinal contador para controlar a frequência de 10 Hz
    begin
        process(clk)	                                        -- Processo sensível ao clock
        begin
            if rising_edge(clk) then                          -- Verifica borda de subida do clock
                if counter >= clk_freq / blink_freqs(2) / 2 then  -- Se contador atingir meio período de 10 Hz
                    -- Inverter o estado do LED e reiniciar o contador
                    osc(2) <= not osc(2);                      -- Inverte a saída correspondente a 10 Hz
                    counter <= 0;                              -- Reinicia o contador
                else
                    counter <= counter + 1;                    -- Incrementa o contador
                end if;            
            end if;
        end process;
    end block F10HZ;							 
							 
end architecture;
