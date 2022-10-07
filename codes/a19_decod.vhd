library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity a19_decod is
    port(
        contador    :   in  integer;
        d0, d1      :   out unsigned(0 to 6)
    );
end entity;

architecture rtl of a19_decod is
    procedure decodificando(
        constant valor  :   in   integer;
        signal   saida  :   out  unsigned(0 to 6)
    ) is
    begin
        case(valor) is
        
            when 0 => saida <= "1111110";
            when 1 => saida <= "0110000";
            when 2 => saida <= "1101101";
            when 3 => saida <= "1111001";
            when 4 => saida <= "0110011";
            when 5 => saida <= "1011011";
            when 6 => saida <= "1011111";
            when 7 => saida <= "1110000";
            when 8 => saida <= "1111111";
            when 9 => saida <= "1111011";
        
            when others => saida <= "0000000";
        
        end case ;
    
    end;
begin

    process(contador) is
        variable dezena, unidade :   integer;
    begin

        dezena := contador / 10;
        unidade := unidade mod 10;
        decodificando(dezena, d1);
        decodificando(unidade, d0);
        
    end process;

end architecture;