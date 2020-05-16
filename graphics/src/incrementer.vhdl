library ieee;
use ieee.std_logic_1164.all;

entity Incrementer is
    generic(
        size : integer := 8
    );
    port (
        A : in std_logic_vector(size-1 downto 0);   -- In port
        S : out std_logic_vector(size-1 downto 0)   -- Out port
    );
end Incrementer;

architecture incrementerBehav of Incrementer is

    signal carry : std_logic_vector(size downto 0);

begin
    carry(0) <= '1';

    GENERATE_ADDERS:
        for i in size-1 downto 0 generate
            S(i) <= A(i) xor carry(i);
            carry(i+1) <= A(i) and carry(i);
        end generate;
end;
