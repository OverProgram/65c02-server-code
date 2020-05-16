library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegTest is
end RegTest;

architecture regTestBehav of RegTest is

    component Reg
    generic (
        size : integer := 8
    );
    port(
        A : in std_logic_vector(size-1 downto 0);
        B : out std_logic_vector(size-1 downto 0);

        OE : in std_logic;
        WE : in std_logic;

        rst : in std_logic;
        clk : in std_logic
    );
    end component;

    signal A : std_logic_vector(7 downto 0) := "00000000";
    signal B : std_logic_vector(7 downto 0);

    signal OE : std_logic := '1';
    signal WE : std_logic := '1';

    signal rst : std_logic := '1';
    signal clk : std_logic := '0';

begin
    TEST_REG: Reg generic map (8) port map (
        A, B, OE, WE, rst, clk
    );


    process
    begin
        rst <= '0';
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        OE <= '0';
        wait for 5 ns;
        assert (B = "00000000") report "Reset not working: B is " & integer'image(to_integer(unsigned(B))) severity failure;
        OE <= '1';
        rst <= '1';

        for i in A'REVERSE_RANGE loop
            A <= std_logic_vector(to_unsigned(i, 8));
            clk <= '1';
            WE <= '0';
            wait for 5 ns;
            clk <= '0';
            OE <= '0';
            WE <= '1';
            wait for 5 ns;
            assert (B = std_logic_vector(to_unsigned(i, 8))) report "Error on cycle " & integer'image(i) & ": B is " & integer'image(to_integer(unsigned(B))) severity failure;
        end loop;
        wait;
    end process;
end;
