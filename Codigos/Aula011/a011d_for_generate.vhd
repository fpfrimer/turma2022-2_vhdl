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
    constant clk_freq       : natural := 50_000_000;                       -- Frequência do clock do sistema (50 MHz)
    constant blink_freqs    : int_array(0 to 2**n - 1) := (                -- Frequências configuradas para cada índice
                                    1, 5, 10, 4,                           -- Índices 0 a 3
                                    8 => 2,                                -- Índice 8 recebe 2 Hz
                                    others => 1);                          -- Demais índices recebem 1 Hz
    
	-- Saída dos contadores para cada frequência 
    signal osc		:	std_logic_vector(0 to 2**n - 1) := (others => '0');  -- Vetor de saídas osciladoras, um para cada frequência
	 
begin 

    -- Selecionar o período baseado nas switches
    led <= osc(to_integer(sw));              -- LED é controlado pela saída correspondente ao valor da chave `sw`
    
	-- Estrutura Generate
    CONT_GEN : for i in 0 to 2**n - 1 generate          -- Geração de processos para cada frequência (de 0 até 2^n - 1)
        process(clk)                                   -- Processo sensível ao clock
            variable counter : natural range 0 to 50e6 := 0; -- Contador para controlar o tempo de alternância da saída
        begin
            if rising_edge(clk) then                   -- Verifica borda de subida do clock
                if counter >= clk_freq / blink_freqs(i) / 2 then  -- Verifica se o tempo de meia onda foi atingido
                    -- Inverter o estado do LED e reiniciar o contador
                    osc(i) <= not osc(i);              -- Inverte a saída correspondente à frequência i
                    counter := 0;                      -- Reinicia o contador
                else
                    counter := counter + 1;            -- Incrementa o contador
                end if;            
            end if;
        end process;
    end generate;							 
							 
end architecture;
