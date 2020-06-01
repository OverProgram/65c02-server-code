library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LatchTest is
end LatchTest;

architecture latchTestBehav of LatchTest is

    component Latch
        port(
            S : in std_logic;   -- Set
            R : in std_logic;   -- Reset
            
            Q: out std_logic;   -- Output
            QB : out std_logic  -- Inverted Output
        );
    end component;

    signal S : std_logic;
    signal R : std_logic;
    signal Q : std_logic;
    signal QB : std_logic;

begin

    TEST_LATCH: Latch port map (
        S => S,
        R => R,
        Q => Q,
        QB => QB
    );

    process
    begin
        R <= '1';
        wait for 5 ns;
        assert (Q = '0') report "Q not reset" severity failure;
        assert (QB = '1') report "QB not set" severity failure;

        R <= '0';
        wait for 5 ns;
        assert (Q = '0') report "Q not reset" severity failure;
        assert (QB = '1') report "QB not set" severity failure;

        S <= '1';
        wait for 5 ns;
        assert (Q = '1') report "Q not set" severity failure;
        assert (QB = '0') report "QB not reset" severity failure;

        S <= '0';
        wait for 5 ns;
        assert (Q = '1') report "Q not set" severity failure;
        assert (QB = '0') report "QB not reset" severity failure;

        R <= '1';
        wait for 5 ns;
        assert (Q = '0') report "Q not reset" severity failure;
        assert (QB = '1') report "QB not set" severity failure;

        wait;
    end process;

end;
