library ieee;
use ieee.std_logic_1164.all;

entity Comparator is
    generic(
        size : integer := 8
    );
    port(
        A : in std_logic_vector(size-1 downto 0);   -- Input 1
        B : in std_logic_vector(size-1 downto 0);   -- Input 2

        eq : out std_logic                          -- Input 1 == Input 2
    );
end Comparator;

architecture compareBehav of Comparator is

    signal track : std_logic_vector(size downto 0);
    signal bit_eq : std_logic_vector(size-1 downto 0);

begin

    track(0) <= '1';

    CMP_GENERATE:
        for i in size-1 downto 0 generate
            bit_eq(i) <= A(i) xnor B(i);
            track(i+1) <= track(i) and bit_eq(i);
        end generate;

    eq <= track(size);
end;
