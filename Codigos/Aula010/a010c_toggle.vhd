library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a010c_toggle is
	port(
		MAX10_CLK1_50		:	in		std_logic;
		KEY					:	in 		std_logic_vector(1 downto 0);
		LEDR				:	out 	std_logic_vector(9 downto 0)
	);
end entity;

architecture rtl of a010c_toggle is

	constant DEBOUNCE_DELAY : integer := 100000; -- ajustar segundo a frequencia do clock e o tempo de debounce desejado

	-- Alias para facilitar a leitura do codigo
	alias clk is MAX10_CLK1_50;
	alias button_n is KEY(0);
	alias reset_n is KEY(1);

	-- Definicao dos estados da maquina de estados
	type state_t is (idle, debounce_press, wait_release, debounce_release);
	signal current_state, next_state : state_t := idle;
	signal current_button : std_logic := '0';
	signal led_state : std_logic := '0';

	-- Sinais para controle do debounce
	signal reset_counter : std_logic := '0';
	signal debounce_done : std_logic := '0';
	signal toggle_led : std_logic := '0';

begin

	-- Processo de transicao de estados, leitura do botao e registrador do LED
	process(clk) is
  	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				current_state <= idle;
				current_button <= '0';
				led_state <= '0';
			else
				current_state <= next_state;
				current_button <= not button_n;

				if toggle_led = '1' then
					led_state <= not led_state;
				end if;
			end if;
		end if;
	end process;

	process(current_state, current_button, debounce_done, led_state) is
	begin

		-- Padrao de saida
		LEDR <= (others => '0');
		LEDR(0) <= led_state;
		reset_counter <= '0';
		next_state <= current_state;
		toggle_led <= '0';

		case current_state is
			-- Espera uma nova pressao do botao.
			when idle =>
				if current_button = '1' then
					next_state <= debounce_press;
					reset_counter <= '1';
				else
					next_state <= idle;
				end if;

			-- Confirma que a pressao permaneceu estavel antes de alternar o LED.
			when debounce_press =>
				if debounce_done = '1' then
					if current_button = '1' then
						next_state <= wait_release;
						toggle_led <= '1';
					else
						next_state <= idle;
					end if;
				else
					next_state <= debounce_press;
				end if;

			-- Depois do toggle, espera soltar para nao alternar repetidamente.
			when wait_release =>
				if current_button = '0' then
					next_state <= debounce_release;
					reset_counter <= '1';
				else
					next_state <= wait_release;
				end if;

			-- Confirma que a soltura permaneceu estavel antes de aceitar novo clique.
			when debounce_release =>
				if debounce_done = '1' then
					next_state <= idle;
				else
					next_state <= debounce_release;
				end if;

			when others =>
				next_state <= idle;
		end case;
		
	end process;

	-- Contador para debounce
	process(clk) is
		variable counter : integer range 0 to DEBOUNCE_DELAY := 0;
	begin
		if rising_edge(clk) then
			if reset_n = '0' or reset_counter = '1' then
				counter := 0;
				debounce_done <= '0';
			elsif debounce_done = '0' then
				counter := counter + 1;
				if counter >= DEBOUNCE_DELAY then
					debounce_done <= '1';
				end if;
			end if;
		end if;
	end process;

end architecture;
