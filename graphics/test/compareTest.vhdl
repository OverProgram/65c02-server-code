library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CmpTest is
end CmpTest;

architecture cmpTestBehav of CmpTest is

    component Comparator
        generic(
            size : integer := 8
        );
        port(
            A : in std_logic_vector(size-1 downto 0);   -- Input 1
            B : in std_logic_vector(size-1 downto 0);   -- Input 2

            eq : out std_logic                          -- Input 1 == Input 2
        );
    end component;

    signal A : std_logic_vector(9 downto 0);
    signal B : std_logic_vector(9 downto 0);
    signal eq : std_logic;

begin
    TEST_CMP: Comparator generic map (10) port map (
        A,
        B,
        eq
    );

    process
    begin
        for i in 1023 downto 0 loop
            A <= std_logic_vector(to_unsigned(i, 10));
            for j in 1023 downto 0 loop
                B <= std_logic_vector(to_unsigned(j, 10));
                wait for 5 ns;
                if (i = j) then
                    assert (eq = '1') report "Error: A = " & integer'image(i) & " B = " & integer'image(j) severity failure;
                else
                    assert (eq = '0') report "Error: A = " & integer'image(i) & " B = " & integer'image(j) severity failure;
                end if;
                wait for 5 ns;
            end loop;
        end loop;
        wait;
    end process;
end;
