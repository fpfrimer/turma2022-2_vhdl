library ieee;                                  
use ieee.std_logic_1164.all;                  

entity blinker is
    port (
        clk : in std_logic;                    -- Entrada de clock
        sw 	: in std_logic_vector(1 downto 0); -- Vetor de switches para seleção de frequência
        led : out std_logic                    -- Saída do LED
    );
end entity;

architecture behavior of blinker is
    
    -- define um array de inteiros (necessário no vhdl 1993)
	type int_array is array(natural range <>) of integer range 1 to 31;
	 
	-- Define a frequência de operação e os períodos para 1 Hz, 5 Hz e 10 Hz
    constant clk_freq       : natural := 50_000_000;             -- Frequência do clock (50 MHz)
    constant blink_freqs    : int_array(0 to 2) := (1, 5, 10);    -- Frequências desejadas para piscar o LED
    
	-- Saída dos contadores para cada frequência 
    signal osc		:	std_logic_vector(0 to 2) := (others => '0'); -- Vetor com os sinais oscilantes para cada frequência
	 
begin 

    -- Selecionar o período baseado nas switches
    with sw select
        led <=  osc(0) when "00",     -- Se sw = "00", seleciona o LED com frequência de 1 Hz
                osc(1) when "01",     -- Se sw = "01", seleciona o LED com frequência de 5 Hz
                osc(2) when others;   -- Qualquer outro valor, seleciona o LED com frequência de 10 Hz   
    
	-- 1 Hz
	process(clk)                                      -- Processo acionado na borda de subida do clock
	    variable counter : natural range 0 to 50e6 := 0; -- Variável contador para controlar a temporização
    begin
        if rising_edge(clk) then                             -- Verifica borda de subida do clock
            if counter >= clk_freq / blink_freqs(0) / 2 then -- Verifica se atingiu meio período da frequência de 1 Hz
                -- Inverter o estado do LED e reiniciar o contador
                osc(0) <= not osc(0);                        -- Inverte o valor da saída correspondente à frequência de 1 Hz
                counter := 0;                                -- Zera o contador
            else
                counter := counter + 1;                      -- Incrementa o contador
            end if;            
        end if;
    end process;
	 
	-- 5 Hz
	process(clk)                                       -- Processo acionado na borda de subida do clock
		variable counter : natural range 0 to 50e6  := 0; -- Variável contador para 5 Hz
    begin
        if rising_edge(clk) then                              -- Verifica borda de subida do clock
            if counter >= clk_freq / blink_freqs(1) / 2 then  -- Verifica se atingiu meio período da frequência de 5 Hz
                -- Inverter o estado do LED e reiniciar o contador
                osc(1) <= not osc(1);                         -- Inverte o valor da saída correspondente à frequência de 5 Hz
                counter := 0;                                 -- Zera o contador
            else
                counter := counter + 1;                       -- Incrementa o contador
            end if;            
        end if;
    end process;
	 
	-- 10 Hz
	process(clk)                                        -- Processo acionado na borda de subida do clock
		variable counter : natural range 0 to 50e6 := 0; -- Variável contador para 10 Hz
    begin
        if rising_edge(clk) then                               -- Verifica borda de subida do clock
            if counter >= clk_freq / blink_freqs(2) / 2 then   -- Verifica se atingiu meio período da frequência de 10 Hz
                -- Inverter o estado do LED e reiniciar o contador
                osc(2) <= not osc(2);                          -- Inverte o valor da saída correspondente à frequência de 10 Hz
                counter := 0;                                  -- Zera o contador
            else
                counter := counter + 1;                        -- Incrementa o contador
            end if;            
        end if;
    end process;							 
							 
end architecture;
