library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_AND2 is
end tb_AND2;

architecture behavior of tb_AND2 is
    signal A, B : std_logic := '0';
    signal Y    : std_logic;

    component AND2
        port (
            A, B : in  std_logic;
            Y    : out std_logic
        );
    end component;
begin
    uut: AND2 port map (A => A, B => B, Y => Y);

    process
    begin
        A <= '0'; B <= '0'; wait for 10 ns;
        A <= '0'; B <= '1'; wait for 10 ns;
        A <= '1'; B <= '0'; wait for 10 ns;
        A <= '1'; B <= '1'; wait for 10 ns;
        wait;
    end process;
end behavior;
