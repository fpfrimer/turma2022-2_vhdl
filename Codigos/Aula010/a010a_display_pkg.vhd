-- Importa a biblioteca padrão para lógica digital
library ieee;
-- Importa o pacote std_logic_1164 (contém std_logic e std_logic_vector)
use ieee.std_logic_1164.all;
-- Importa o pacote numeric_std (permite conversões entre tipos e operações aritméticas)
use ieee.numeric_std.all;

-- Início da definição do pacote 'display'
package display is

	-- Define um tipo enumerado que representa o tipo de display: anodo comum ou catodo comum
	type display_type is (anode, catode);
	
	-- Define um vetor de vetores de 7 bits para múltiplos displays de 7 segmentos
	type display_vector is array(natural range <>) of std_logic_vector(0 to 6);

	-- Declara a função que converte um número hexadecimal em sinais de controle para o display
	function seven_segment_decode (hex_num : in std_logic_vector(3 downto 0); mode : in display_type) return std_logic_vector;

	-- Declara a função que converte um sinal std_logic ('0' ou '1') para o tipo enumerado display_type
	function sl_to_dt(mode	:	std_logic) return display_type;

	-- Declara função que converte um número inteiro em um vetor de segmentos para múltiplos dígitos
	function display(number : integer; digits: positive; num_base : integer; mode : in display_type) return display_vector;

	-- Declara função que converte um número do tipo unsigned para vetor de displays
	function display(number : unsigned; digits: positive; num_base : integer; mode : in display_type) return display_vector;

	-- Declara função que converte um std_logic_vector para vetor de displays
	function display(number : std_logic_vector; digits: positive; num_base : integer; mode : in display_type) return display_vector;
	
	-- Declaração do componente contador reutilizável
	component counter is
		generic(
			clk_freq		:	integer := 50e6;   -- Frequência do clock de entrada
			update_freq		:	integer := 100;    -- Frequência de atualização do contador
			n_bits			:	integer := 10      -- Número de bits da saída
		);
		port(
			clk		:	in		std_logic;                             -- Clock
			nRst		:	in		std_logic;                             -- Reset assíncrono (ativo em 0)
			en		:	in		std_logic;                             -- Habilita o contador
			q		:	out 	unsigned(n_bits - 1 downto 0)         -- Saída com valor do contador
		);
	end component counter;

end package;

-- Início da implementação das funções do pacote
package body display is

	-- Implementação da função que decodifica de hexadecimal para display de 7 segmentos
	function seven_segment_decode (hex_num : in std_logic_vector(3 downto 0); mode : in display_type) return std_logic_vector is
		variable segment_out : std_logic_vector(6 downto 0); -- Segmentos de saída
	begin
		-- Verifica o valor do número hexadecimal e define os segmentos correspondentes
		case hex_num is
			when "0000" => segment_out := "0000001";  -- Displays 0
          		when "0001" => segment_out := "1001111";  -- Displays 1
          		when "0010" => segment_out := "0010010";  -- Displays 2
          		when "0011" => segment_out := "0000110";  -- Displays 3
          		when "0100" => segment_out := "1001100";  -- Displays 4
          		when "0101" => segment_out := "0100100";  -- Displays 5
          		when "0110" => segment_out := "0100000";  -- Displays 6
          		when "0111" => segment_out := "0001111";  -- Displays 7
          		when "1000" => segment_out := "0000000";  -- Displays 8
          		when "1001" => segment_out := "0000100";  -- Displays 9
          		when "1010" => segment_out := "0001000";  -- Displays A
          		when "1011" => segment_out := "1100000";  -- Displays B
          		when "1100" => segment_out := "0110001";  -- Displays C
          		when "1101" => segment_out := "1000010";  -- Displays D
          		when "1110" => segment_out := "0110000";  -- Displays E
          		when "1111" => segment_out := "0111000";  -- Displays F
          		when others => segment_out := "1111111";  -- Turns off all segments
		end case;

		-- Se for display de cátodo comum, inverte os bits
		if mode = catode then
			return not segment_out;
		else
			return segment_out;
		end if;

	end function seven_segment_decode;

	-- Converte um std_logic ('0' ou '1') para o tipo enumerado display_type
	function sl_to_dt(mode	:	std_logic) return display_type is
	begin
		if mode = '1' then
			return catode; -- '1' representa cátodo comum
		else 
			return anode;  -- '0' representa ânodo comum
		end if;

	end function sl_to_dt;

	-- Conversão de número inteiro para vetor de display de 7 segmentos
	function display(number : integer; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0); -- Vetor para armazenar os dígitos convertidos
		variable temp			:	integer;                             -- Cópia temporária do número
	begin
		-- Verifica se a base está entre 0 e 16
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;

		-- Inicializa variável com o número original
		temp := number;

		-- Loop para extrair e converter cada dígito
		for i in 0 to digits - 1 loop
			-- Converte os 4 bits menos significativos para 7 segmentos
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			-- Divide para pegar o próximo dígito
			temp := temp / num_base;
		end loop;

		-- Retorna vetor com todos os dígitos convertidos
		return dec_digits;

	-- Fim da função display (versão com inteiro)
	end function display;

	-- Versão da função display para valores do tipo unsigned
	function display(number : unsigned; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0); -- Vetor para armazenar os dígitos
		variable temp			:	integer;                             -- Conversão para inteiro
	begin
		-- Verifica base válida
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;

		-- Converte o número unsigned para inteiro
		temp := to_integer(number);

		-- Loop para conversão de cada dígito
		for i in 0 to digits - 1 loop
			-- Converte para 7 segmentos
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp / num_base;
		end loop;

		-- Retorna o vetor final
		return dec_digits;

	-- Fim da função display (unsigned)
	end function display;

	-- Versão da função display para std_logic_vector
	function display(number : std_logic_vector; digits: positive; num_base : integer; mode : in display_type) return display_vector is
		variable dec_digits	:	display_vector(digits - 1 downto 0); -- Vetor para armazenar os dígitos
		variable temp			:	integer;                             -- Conversão para inteiro
	begin
		-- Verifica base válida
		assert num_base <= 16 and num_base >= 0
			report "num_base is greater than 16"
			severity error;

		-- Converte std_logic_vector para inteiro
		temp := to_integer(unsigned(number));

		-- Loop para conversão dos dígitos
		for i in 0 to digits - 1 loop
			dec_digits(i) := seven_segment_decode(std_logic_vector(to_unsigned(temp mod num_base, 4)), mode);
			temp := temp / num_base;
		end loop;

		-- Retorna o vetor final
		return dec_digits;

	end function display;

-- Fim da implementação do corpo do pacote
end display;

-- Importação das bibliotecas necessárias novamente
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
	generic(
		clk_freq	:	integer := 50e6;  -- Frequência do clock em Hz
		update_freq	:	integer := 100;   -- Frequência de atualização
		n_bits		:	integer := 10     -- Número de bits da saída
	);
	port(
		clk		:	in		std_logic;                         -- Clock de entrada
		nRst		:	in		std_logic;                         -- Reset assíncrono
		en		:	in		std_logic;                         -- Habilitação do contador
		q		:	out 	unsigned(n_bits - 1 downto 0)     -- Saída do contador
	);
end entity counter;

architecture behavioral of counter is
	constant max	:	integer := clk_freq / update_freq; -- Número máximo de ciclos de clock antes de incrementar o contador
begin
	process(clk, nRst) is
		variable ticks	:	integer range 0 to max - 1;            -- Contador interno de ciclos
		variable cnt 	:	unsigned(n_bits - 1 downto 0);        -- Contador principal
	begin
		-- Reset assíncrono
		if nRst = '0' then
			cnt := (others => '0'); -- Zera o contador
			ticks := 0;             -- Zera os ticks
		-- Verifica borda de subida do clock
		elsif rising_edge(clk) then
			if en = '1' then
				if ticks = max - 1 then
					ticks := 0;      -- Reinicia os ticks
					cnt := cnt + 1; -- Incrementa o contador
				else 
					ticks := ticks + 1; -- Incrementa os ticks
				end if;
			end if;
		end if;
		-- Atualiza a saída com o valor do contador
		q <= cnt;
	end process;

end architecture;
