library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IncTest is
end IncTest;

architecture incTestBehav of IncTest is

    component BitCounter
        generic(
            size : integer := 8
        );
        port (
            C : out std_logic_vector(size-1 downto 0);
            
            rst : in std_logic;
            clk : in std_logic
        );
    end component;

    signal C : std_logic_vector(7 downto 0);
    signal rst : std_logic := '1';
    signal clk : std_logic := '0';

begin
    TEST_COUNTER: BitCounter generic map (8) port map (
        C,
        rst,
        clk
    );

    process
    begin
        rst <= '0';
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        assert (C = "00000000") report "Reset not working: C is " & integer'image(to_integer(unsigned(C))) severity failure;
        rst <= '1';

        for i in C'REVERSE_RANGE loop
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
            wait for 5 ns;
            assert (C = std_logic_vector(to_unsigned(i+1, 8))) report "Error on cycle " & integer'image(i+1) & ": C is " & integer'image(to_integer(unsigned(C))) severity failure;
        end loop;
        wait;
    end process;
end;
