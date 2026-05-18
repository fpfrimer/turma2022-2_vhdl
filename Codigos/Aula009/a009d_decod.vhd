library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a009d_decod is
    port(
        contador : in  unsigned(5 downto 0);       -- Entrada do valor a ser decodificado (0 a 63)
        d0, d1   : out std_logic_vector(0 to 6)    -- Saidas para segmentos dos displays
    );
end entity;

architecture rtl of a009d_decod is
    -- Funcao que recebe um digito decimal e retorna o vetor de segmentos.
    function decodificando(valor: integer) return std_logic_vector is
        variable saida : std_logic_vector(0 to 6);
    begin
        case valor is
            when 0  => saida := not "1111110";
            when 1  => saida := not "0110000";
            when 2  => saida := not "1101101";
            when 3  => saida := not "1111001";
            when 4  => saida := not "0110011";
            when 5  => saida := not "1011011";
            when 6  => saida := not "1011111";
            when 7  => saida := not "1110000";
            when 8  => saida := not "1111111";
            when 9  => saida := not "1111011";
            when others => saida := "0000000";
        end case;
        return saida;
    end decodificando;

begin
    process(contador) is
        variable valor   : integer range 0 to 63;
        variable dezena  : integer range 0 to 6;
        variable unidade : integer range 0 to 9;
    begin
        if is_x(std_logic_vector(contador)) then
            valor := 0;
        else
            valor := to_integer(contador);
        end if;

        dezena  := valor / 10;
        unidade := valor mod 10;

        d1 <= decodificando(dezena);
        d0 <= decodificando(unidade);
    end process;

end architecture;

-- Fim do decodificador de displays a009d_decod.vhd
