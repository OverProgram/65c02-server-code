library ieee;
use ieee.std_logic_1164.all;

entity Latch is
    port(
        S : in std_logic;   -- Set
        R : in std_logic;   -- Reset
        
        Q: out std_logic;   -- Output
        clk : in std_logic  -- Clock input
    );
end Latch;

architecture latchBehav of Latch is

    signal Qlatch : std_logic;

begin

    process(clk)
    begin
        if S = '1' and R = '1' then
            Q <= '0';
        elsif S = '1' then
            Q <= '1';
            Qlatch <= '1';
        elsif R = '1' then
            Q <= '0';
            Qlatch <= '0';
        else
            Q <= Qlatch;
        end if;
    end process;

--    process (S, R)
--    begin
--        if (S and lastR) = '1' then
--            Q <= '1';
--            lastS <= '1';
--            lastR <= '0';
--        end if;

--        if (R and lastS) = '1' then
--            Q <= '0';
--            QB <= '1';
--            lastR <= '1';
--            lastS <= '0';
--        end if;
--    end process;

end;