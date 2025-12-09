-- Descrição
-- Objetivo: Controlar um LED com uma máquina de estados baseada no estado das chaves.
-- Funcionamento:
-- Quando CHAVE0 está em 1, a máquina entra no estado "ligado" e acende o LED.
-- Quando CHAVE1 está em 1, a máquina entra no estado "pisca" e o LED pisca.
-- Quando ambas as chaves estão em 0, a máquina entra no estado "desligado" e apaga o LED.

library ieee;                            
use ieee.std_logic_1164.all;            

entity a010b_maquina_estados is
    Port (
        CLK     : in  STD_LOGIC;          -- Clock de entrada
        RESET   : in  STD_LOGIC;          -- Botão de reset (ativo em nível baixo)
        CHAVE0  : in  STD_LOGIC;          -- Chave de controle para estado "ligado"
        CHAVE1  : in  STD_LOGIC;          -- Chave de controle para estado "pisca"
        LED     : out STD_LOGIC           -- Saída que controla o LED
    );
end entity;

architecture Behavioral of a010b_maquina_estados is

    type state_type is (desligado, ligado, pisca);                     -- Define os estados possíveis da máquina
    signal state, next_state : state_type;                             -- Sinais para o estado atual e o próximo estado
    signal pisca_counter : integer range 0 to 50000000 := 0;           -- Contador para controlar a frequência do pisca
    signal pisca_signal : STD_LOGIC := '0';                            -- Sinal que alterna o LED no estado "pisca"

begin

    process(CLK, RESET)                                                -- Processo sequencial para transição de estado
    begin
        if RESET = '0' then
            state <= desligado;                                        -- Reinicia para o estado "desligado"
        elsif rising_edge(CLK) then
            state <= next_state;                                       -- Atualiza o estado na borda de subida do clock
        end if;
    end process;

    process(state, CHAVE0, CHAVE1)                                     -- Processo combinacional para lógica de transição
    begin
        case state is
            when desligado =>
                if CHAVE0 = '1' then
                    next_state <= ligado;                              -- Vai para "ligado" se CHAVE0 for 1
                elsif CHAVE1 = '1' then
                    next_state <= pisca;                               -- Vai para "pisca" se CHAVE1 for 1
                else
                    next_state <= desligado;                           -- Permanece em "desligado" se ambas forem 0
                end if;

            when ligado =>
                if CHAVE0 = '0' and CHAVE1 = '1' then
                    next_state <= pisca;                               -- Vai para "pisca" se CHAVE0=0 e CHAVE1=1
                elsif CHAVE0 = '0' and CHAVE1 = '0' then
                    next_state <= desligado;                           -- Vai para "desligado" se ambas forem 0
                else
                    next_state <= ligado;                              -- Permanece em "ligado" caso contrário
                end if;

            when pisca =>
                if CHAVE0 = '1' then
                    next_state <= ligado;                              -- Vai para "ligado" se CHAVE0=1
                elsif CHAVE1 = '0' then
                    next_state <= desligado;                           -- Vai para "desligado" se CHAVE1=0
                else
                    next_state <= pisca;                               -- Permanece em "pisca" caso contrário
                end if;

            when others =>
                next_state <= desligado;                               -- Segurança: volta para "desligado" se estado inválido
        end case;
    end process;

    process(CLK)                                                       -- Processo sequencial para controlar o piscar do LED
    begin
        if rising_edge(CLK) then
            if state = pisca then
                pisca_counter <= pisca_counter + 1;                    -- Incrementa o contador
                if pisca_counter = 25000000 then                       -- Alvo de meio segundo (com clock de 50MHz)
                    pisca_signal <= NOT pisca_signal;                 -- Inverte o estado do LED
                    pisca_counter <= 0;                                -- Reinicia o contador
                end if;
            else
                pisca_signal <= '0';                                   -- Garante que LED fique apagado fora do estado "pisca"
                pisca_counter <= 0;                                    -- Zera o contador
            end if;
        end if;
    end process;

    LED <= '1' when state = ligado else                                -- LED aceso no estado "ligado"
           pisca_signal when state = pisca else                        -- LED pisca no estado "pisca"
           '0';                                                        -- LED apagado no estado "desligado"

end Behavioral;
