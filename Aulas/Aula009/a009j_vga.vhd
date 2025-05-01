-- Este código imprime três quadrados de cores diferentes em um monitor VGA de 800x600@72Hz.
-- Utiliza o clock de 50 MHz presente no kit DE10-Lite.
-- Para outras configurações de frequência, seria necessário um PLL.
-- Referências de temporização VGA:
--   https://martin.hinner.info/vga/timing.html
--   https://embarcados.com.br/controlador-vga-parte-1/
--   https://www.youtube.com/watch?v=WK5FT5RD1sU

library ieee;
use ieee.std_logic_1164.all; -- Biblioteca para sinais lógicos básicos
use ieee.numeric_std.all;    -- Biblioteca para aritmética com std_logic_vector

entity a009j_vga is
    port (
        MAX10_CLK1_50 : in  std_logic;               -- Clock de 50 MHz da placa
        -- KEY : in std_logic_vector(0 to 1);         -- (opcional: botões de entrada)
        VGA_R         : out std_logic_vector(3 downto 0); -- Saída de 4 bits para vermelho
        VGA_G         : out std_logic_vector(3 downto 0); -- Saída de 4 bits para verde
        VGA_B         : out std_logic_vector(3 downto 0); -- Saída de 4 bits para azul
        VGA_VS, VGA_HS: out std_logic                  -- Sinais de sincronização vertical e horizontal
    );
end entity;

architecture rtl of a009j_vga is
    -- Constantes de temporização horizontal (800 ativa + front/back porches + sync)
    constant H_ACTIVE_VIDEO : integer := 800;                          -- Pixels visíveis
    constant H_FRONT_PORCH  : integer := H_ACTIVE_VIDEO + 56;         -- Frente do pulso H-sync
    constant H_SYNC         : integer := H_FRONT_PORCH + 120;         -- Largura do pulso H-sync
    constant H_BACK_PORCH   : integer := H_SYNC + 64;                 -- Retardo após sync
    constant H_PIXELS       : integer := 1040;                        -- Total de pixels por linha

    -- Constantes de temporização vertical (600 ativa + front/back porches + sync)
    constant V_ACTIVE_VIDEO : integer := 600;                          -- Linhas visíveis
    constant V_FRONT_PORCH  : integer := V_ACTIVE_VIDEO + 37;         -- Frente do pulso V-sync
    constant V_SYNC         : integer := V_FRONT_PORCH + 6;           -- Largura do pulso V-sync
    constant V_BACK_PORCH   : integer := V_SYNC + 23;                 -- Retardo após sync
    constant V_PIXELS       : integer := 666;                         -- Total de linhas por quadro

    -- Procedimento genérico para incrementar contadores com estouro
    procedure incrementa(
        signal contador : inout integer;  -- Contador a incrementar
        constant max    : in integer;     -- Valor de estouro (max)
        constant habilita : in boolean;   -- Permite incrementar quando true
        variable estouro  : out boolean   -- Indica estouro (overflow)
    ) is
    begin
        estouro := false;
        if habilita then
            if contador = max - 1 then
                contador <= 0;            -- Reseta contador ao atingir max
                estouro := true;
            else
                contador <= contador + 1; -- Incrementa normalmente
            end if;
        end if;
    end procedure;

    -- Procedimento para desenhar um quadrado colorido na tela
    procedure quadrado(
        constant enable : in boolean;                 -- Habilita desenho
        constant h, v   : in integer;                 -- Coordenadas de varredura atuais
        constant x, y   : in integer;                 -- Centro do quadrado em pixels
        constant w      : in integer;                 -- Lado do quadrado em pixels
        constant color  : in std_logic_vector(11 downto 0); -- Cor RGB concatenada
        variable draw   : inout std_logic_vector(11 downto 0) -- Saída de cor
    ) is
    begin
        if enable then
            -- Verifica se (h,v) está dentro dos limites do quadrado
            if (v >= y - w/2 and v < y + w/2) and (h >= x - w/2 and h < x + w/2) then
                draw := color; -- Atribui cor se dentro do quadrado
            end if;
        end if;
    end procedure;

    -- Alias para simplificar uso do clock
a    alias clk : std_logic is MAX10_CLK1_50;

    -- Sinais de varredura e flag de área ativa
    signal horizontal : integer range 0 to H_PIXELS := 0; -- Contador de pixel horizontal
    signal vertical   : integer range 0 to V_PIXELS := 0; -- Contador de linha vertical
    signal active     : boolean := false;                -- Indica área visível

begin
    -- Processo de geração de sincronismos e contadores de varredura
    PIXEL_PROC : process(clk)
        variable controle : boolean; -- Sinal de overflow entre incrementos
    begin
        if rising_edge(clk) then
            -- Inicializa sinais HS/VS e área ativa
            VGA_HS <= '1';
            VGA_VS <= '1';
            active <= false;

            -- Gera pulso H-sync no intervalo definido
            if horizontal >= H_FRONT_PORCH and horizontal < H_SYNC then
                VGA_HS <= '0';
            end if;
            -- Gera pulso V-sync no intervalo vertical definido
            if vertical >= V_FRONT_PORCH and vertical < V_SYNC then
                VGA_VS <= '0';
            end if;

            -- Define área visível quando dentro dos ranges ativos
            if horizontal < H_ACTIVE_VIDEO and vertical < V_ACTIVE_VIDEO then
                active <= true;
            end if;

            -- Incrementa contadores de pixel e linha vertical em cascata
            incrementa(horizontal, H_PIXELS, true, controle);
            incrementa(vertical, V_PIXELS, controle, controle);
        end if;
    end process;

    -- Processo de desenho dos quadrados e saída RGB
    DRAW_PROC : process(horizontal, vertical, active)
        variable draw : std_logic_vector(11 downto 0); -- Vetor concatenado R[11:8]G[7:4]B[3:0]
    begin
        -- Reinicia cor de fundo (preto)
        draw := (others => '0');
        -- Desenha três quadrados com cores diferentes
        quadrado(active, horizontal, vertical, 350, 275, 60, x"F00", draw);
        quadrado(active, horizontal, vertical, 400, 300, 60, x"0F0", draw);
        quadrado(active, horizontal, vertical, 450, 325, 60, x"00F", draw);

        -- Atribui cada nibble aos sinais VGA R, G e B
        VGA_R <= draw(11 downto 8);
        VGA_G <= draw(7 downto 4);
        VGA_B <= draw(3 downto 0);
    end process;

end architecture;

-- Fim do módulo a009j_vga.vhd
