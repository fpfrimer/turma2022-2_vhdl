library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a009c_timer_proc is 
    generic(
        clockFreq : positive := 50e6  -- Frequencia de clock do sistema (padrao: 50 MHz)
    );
    port(
        clk  : in  std_logic;             -- Sinal de clock de entrada
        nRst : in  std_logic;             -- Reset assincrono ativo em nivel baixo
        s    : out unsigned(5 downto 0);  -- Contador de segundos (0 a 59)
        m    : out unsigned(5 downto 0);  -- Contador de minutos (0 a 59)
        h    : out unsigned(4 downto 0)   -- Contador de horas   (0 a 23)
    );
end entity;

architecture rtl of a009c_timer_proc is
    function bits_necessarios(n : positive) return natural is
        variable valor : natural := n - 1;
        variable bits  : natural := 0;
    begin
        while valor > 0 loop
            bits  := bits + 1;
            valor := valor / 2;
        end loop;

        if bits = 0 then
            return 1;
        else
            return bits;
        end if;
    end function;

    -- Sinais internos para guardar o estado do timer.
    signal ticks  : unsigned(bits_necessarios(clockFreq) - 1 downto 0) := (others => '0');
    signal segReg : unsigned(5 downto 0) := (others => '0');
    signal minReg : unsigned(5 downto 0) := (others => '0');
    signal horReg : unsigned(4 downto 0) := (others => '0');

    -- Procedimento auxiliar para incrementar contadores unsigned com estouro.
    procedure incrementa(
        signal   contador : inout unsigned;
        constant max      : in    positive;
        constant habilita : in    boolean;
        variable estouro  : out   boolean
    ) is
    begin
        estouro := false;
        if habilita then
            if contador = to_unsigned(max - 1, contador'length) then
                contador <= to_unsigned(0, contador'length);
                estouro := true;
            else
                contador <= contador + 1;
            end if;
        end if;
    end procedure;

begin
    s <= segReg;
    m <= minReg;
    h <= horReg;

    process(clk, nRst) is
        variable controle : boolean;
    begin
        if nRst = '0' then
            ticks  <= (others => '0');
            segReg <= (others => '0');
            minReg <= (others => '0');
            horReg <= (others => '0');

        elsif falling_edge(clk) then
            incrementa(ticks,  clockFreq, true,     controle);
            incrementa(segReg, 60,        controle, controle);
            incrementa(minReg, 60,        controle, controle);
            incrementa(horReg, 24,        controle, controle);
        end if;
    end process;
end architecture;

-- Fim do modulo a009c_timer_proc.vhd
