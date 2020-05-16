library ieee;
use ieee.std_logic_1164.all;

entity Latch is
    port(
        S : in std_logic;   -- Set
        R : in std_logic;   -- Reset
        
        Q: out std_logic;   -- Output
        QB : out std_logic  -- Inverted Output
    );
end Latch;

architecture latchBehav of Latch is

    signal QVal : std_logic;
    signal BQVal : std_logic;

begin
    Q <= QVal;
    QB <= BQVal;

    QVal <= R nor BQVal;
    BQVal <= S nor QVal;
end;
