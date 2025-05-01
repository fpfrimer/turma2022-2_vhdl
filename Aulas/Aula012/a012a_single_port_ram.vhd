-- Quartus Prime VHDL Template
-- Single-port RAM with single read/write address and initial contents	

library ieee;                                  
use ieee.std_logic_1164.all;                   
use ieee.numeric_std.all;                      

entity single_port_ram_with_init is

	generic 
	(
		DATA_WIDTH : natural := 8;              -- Largura dos dados (bits por palavra)
		ADDR_WIDTH : natural := 6              -- Largura do endereço (bits do endereço)
	);

	port 
	(
		clk		: in std_logic;                                         -- Clock de entrada
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;             -- Endereço de leitura/escrita
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);        -- Dado de entrada para escrita
		we		: in std_logic := '1';                                 -- Sinal de habilitação de escrita (write enable)
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)       -- Dado de saída (leitura)
	);

end single_port_ram_with_init;

architecture rtl of single_port_ram_with_init is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);         -- Define o tipo de uma palavra na RAM
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;          -- Define o tipo da memória como um array de palavras

	-- Função para inicializar a RAM com o próprio valor do endereço
	function init_ram
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));         -- Inicializa todas as posições com zeros
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Initialize each address with the address itself
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));  -- Atribui o valor do endereço à posição correspondente
		end loop;
		return tmp;
	end init_ram;	 

	-- Declare the RAM signal and specify a default value.	Quartus Prime
	-- will create a memory initialization file (.mif) based on the 
	-- default value.
	signal ram : memory_t := init_ram;            -- Instancia a RAM com conteúdo inicial

	-- Register to hold the address 
	signal addr_reg : natural range 0 to 2**ADDR_WIDTH-1;   -- Registrador para armazenar o endereço lido

begin

	process(clk)
	begin
	if(rising_edge(clk)) then                     -- Executa na borda de subida do clock
		if(we = '1') then                         -- Verifica se escrita está habilitada
			ram(addr) <= data;                    -- Escreve o dado no endereço especificado
		end if;

		-- Register the address for reading
		addr_reg <= addr;                         -- Armazena o endereço atual para leitura futura
	end if;
	end process;

	q <= ram(addr_reg);                           -- Atribui à saída o conteúdo lido da RAM

end rtl;
