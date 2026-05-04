library ieee;
use ieee.std_logic_1164.all;

entity AND2 is
    port (
        A, B : in  std_logic;
        Y    : out std_logic
    );
end AND2;

architecture rtl of AND2 is
begin
    Y <= A and B;
end rtl;
