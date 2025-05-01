-- Quartus Prime VHDL Template
-- Simple Dual-Port RAM with different read/write addresses but
-- single read/write clock

library ieee;                                   
use ieee.std_logic_1164.all;                    

entity simple_dual_port_ram_single_clock is

	generic 
	(
		DATA_WIDTH : natural := 8;              -- Largura dos dados (bits por palavra)
		ADDR_WIDTH : natural := 6               -- Largura do endereço (número de bits de endereço)
	);

	port 
	(
		clk		: in std_logic;                                         -- Clock de leitura/escrita
		raddr	: in natural range 0 to 2**ADDR_WIDTH - 1;             -- Endereço de leitura
		waddr	: in natural range 0 to 2**ADDR_WIDTH - 1;             -- Endereço de escrita
		data	: in std_logic_vector((DATA_WIDTH-1) downto 0);        -- Dados de entrada (para escrita)
		we		: in std_logic := '1';                                 -- Sinal de habilitação de escrita
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)       -- Dados de saída (leitura)
	);

end simple_dual_port_ram_single_clock;

architecture rtl of simple_dual_port_ram_single_clock is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);        -- Define o tipo de uma palavra da RAM
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;         -- Define a RAM como um array de palavras

	-- Declare the RAM signal.	
	signal ram : memory_t;                                              -- Instancia o sinal da RAM

begin

	process(clk)
	begin
	if(rising_edge(clk)) then                                          -- Detecta borda de subida do clock
		if(we = '1') then                                              -- Se escrita estiver habilitada
			ram(waddr) <= data;                                        -- Escreve os dados no endereço de escrita
		end if;
 
		-- On a read during a write to the same address, the read will
		-- return the OLD data at the address
		q <= ram(raddr);                                               -- Lê os dados do endereço de leitura
	end if;
	end process;

end rtl;
