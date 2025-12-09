library ieee;                                  
use ieee.std_logic_1164.all;                  
use ieee.numeric_std.all;                     

entity blinker is
    generic(
        n   : natural := 4                     -- Número de chaves de seleção
    );
    port (
        clk : in std_logic;                    -- Clock de entrada
        sw 	: in unsigned(n - 1 downto 0);     -- Vetor de entrada com switches (unsigned)
        led : out std_logic                    -- Saída de controle do LED
    );
end entity;

architecture behavior of blinker is
    
    -- define um array de inteiros (necessário no vhdl 1993)
	type int_array is array(natural range <>) of integer range 1 to 31;
	 
	-- Define a frequência de operação e os períodos para 1 Hz, 5 Hz e 10 Hz
   constant clk_freq       : natural := 50_000_000;                                   -- Frequência do clock do sistema (50 MHz)
	constant blink_freqs    : int_array(0 to 2**n - 1) := (                            -- Vetor de frequências para cada índice de chave
        1, 5, 10, 4,                                                                 -- Índices 0 a 3
        4 to 7 => 20,                                                                -- Índices 4 a 7 com frequência de 20 Hz
        8 => 2,                                                                      -- Índice 8 com 2 Hz
        others => 1);                                                                -- Demais índices com frequência padrão de 1 Hz
    
	-- Saída dos contadores para cada frequência 
    signal osc		:	std_logic_vector(0 to 2**n - 1) := (others => '0');            -- Vetor de saídas de oscilação para cada índice de chave
	 
begin 

    -- Selecionar o período baseado nas switches
    led <= osc(to_integer(sw));               -- LED é controlado pela saída correspondente ao valor convertido da chave
    
	-- Estrutura Generate
    CONT_GEN : for i in 0 to 2**n - 1 generate           -- Geração de processos para cada índice de chave
		  
        EXCLUDE : if i /= 13 generate                    -- Gera o processo apenas se o índice for diferente de 13
			  
            process(clk)                                -- Processo sensível à borda de subida do clock
                variable counter : natural range 0 to 50e6 := 0;  -- Contador para controlar a frequência de piscada
            begin
                if rising_edge(clk) then                -- Detecta borda de subida
                    if counter >= clk_freq / blink_freqs(i) / 2 then  -- Verifica se o tempo correspondente à metade do período foi atingido
                        -- Inverter o estado do LED e reiniciar o contador
                        osc(i) <= not osc(i);           -- Inverte o sinal de saída correspondente ao índice
                        counter := 0;                   -- Reinicia o contador
                    else
                        counter := counter + 1;         -- Incrementa o contador
                    end if;            
                end if;
            end process;

        end generate EXCLUDE;

    end generate CONT_GEN;							 
							 
end architecture;
