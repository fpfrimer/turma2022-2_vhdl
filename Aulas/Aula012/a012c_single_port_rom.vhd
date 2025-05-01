-- Quartus Prime VHDL Template
-- Single-Port ROM

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_port_rom is

	generic 
	(
		DATA_WIDTH : natural := 8;              -- Largura dos dados (bits por palavra)
		ADDR_WIDTH : natural := 8              -- Largura do endereço (bits de endereçamento)
	);

	port 
	(
		clk		: in std_logic;                                         -- Clock de leitura
		addr	: in natural range 0 to 2**ADDR_WIDTH - 1;             -- Endereço de leitura
		q		: out std_logic_vector((DATA_WIDTH -1) downto 0)       -- Saída de dados da ROM
	);

end entity;

architecture rtl of single_port_rom is

	-- Define o tipo de uma palavra da ROM (vetor de bits)
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);

	-- Define a ROM como um array de palavras (tamanho: 2^ADDR_WIDTH)
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Função para inicializar a ROM com valores padrão
	function init_rom
		return memory_t is 
		variable tmp : memory_t := (others => (others => '0'));           -- Inicializa com zeros
	begin 
		for addr_pos in 0 to 2**ADDR_WIDTH - 1 loop 
			-- Inicializa cada posição da ROM com o valor de seu próprio endereço
			tmp(addr_pos) := std_logic_vector(to_unsigned(addr_pos, DATA_WIDTH));
		end loop;
		return tmp;
	end init_rom;	 

	-- Declara a ROM com valores iniciais definidos pela função acima.
	signal rom : memory_t := init_rom;

begin

	-- Processo sensível à borda de subida do clock
	process(clk)
	begin
		if rising_edge(clk) then
			q <= rom(addr);     -- Lê o valor da ROM no endereço especificado
		end if;
	end process;

end rtl;
