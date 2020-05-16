library ieee;
use ieee.std_logic_1164.all;

entity BitAdder is 
    port(
        A : in std_logic;
        B : in std_logic;

        S : out std_logic;

        Cin : in std_logic;
        Cout : out std_logic
    );
end BitAdder;

architecture bitAdderBehav of BitAdder is
    signal halfSum : std_logic;
    signal halfCarry : std_logic;
    signal carrySum : std_logic;
begin
    halfSum <= A xor B;
    halfCarry <= A and B;
    carrySum <= Cin and halfSum;
    S <= halfSum xor Cin;
    Cout <= halfCarry and carrySum;
end;
