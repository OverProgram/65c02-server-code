library ieee;
use ieee.std_logic_1164.all;

entity Adder is
    generic(
        size : integer := 8
    );
    port(
        A : in std_logic_vector(size-1 downto 0);
        B : in std_logic_vector(size-1 downto 0);

        S : out std_logic_vector(size-1 downto 0)
    );
end Adder;

architecture adderBehav of Adder is

    component BitAdder
    port(
        A : in std_logic;
        B : in std_logic;

        S : out std_logic;

        Cin : in std_logic;
        Cout : out std_logic
    );
    end component;

    signal carry : std_logic_vector(size downto 0);

begin

    carry(0) <= '0';

    GENERATE_BIT_ADDERS:
        for i in size-1 downto 0 generate
            X_BIT_ADDER: BitAdder port map(A(i), B(i), S(i), carry(i), carry(i+1));
        end generate;
end;
