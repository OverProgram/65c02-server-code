library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGATest is
end VGATest;

architecture vgaTestBehav of VGATest is

    component VGAController
    port(
        pixle : out std_logic_vector(9 downto 0);
        vpixle : out std_logic_vector(9 downto 0);

        hsync : out std_logic;  -- Horizontal Sync
        vsync : out std_logic;  -- Vertical Sync

        clk : in std_logic;     -- Pixle Clock (25.175MHz)
        rst : in std_logic;     -- Reset
        vclk_out : out std_logic;
        dbg : out std_logic
    );
    end component;

    signal pixle : std_logic_vector(9 downto 0);
    signal vpixle : std_logic_vector(9 downto 0);
    signal hsync : std_logic;
    signal vsync : std_logic;
    signal clk : std_logic;
    signal rst : std_logic;
    signal vclk_out : std_logic;
    signal dbg : std_logic;

begin

    TEST_VGA: VGAController port map (
        pixle => pixle,
        vpixle => vpixle,
        hsync => hsync,
        vsync => vsync,
        clk => clk,
        rst => rst,
        vclk_out => vclk_out,
        dbg => dbg
    );

    process
    begin
        rst <= '0';
        clk <= '0';
        wait for 20 ns;
        clk <= '1';
        wait for 20 ns;
        rst <= '1';
        clk <= '0';

        for i in 0 to 524 loop
            for j in 0 to 799 loop
                clk <= '1';
                wait for 20 ns;
                clk <= '0';
                wait for 20 ns;

                assert (to_integer(unsigned(pixle)) = j) report "Error: pixle is " & integer'image(to_integer(unsigned(pixle))) & " but should be " & integer'image(j) severity failure;
                assert (to_integer(unsigned(vpixle)) = i) report "Error: vpixle is " & integer'image(to_integer(unsigned(vpixle))) & " but should be " & integer'image(i) severity failure;

                if (j > 653) and (j < 750) then
                    assert (hsync = '1') report "Error: hsync is not up on cycle " & integer'image(j) severity failure;
                else
                    assert (hsync = '0') report "Error: hsync is not down on cycle " & integer'image(j) severity failure;
                end if;

                if (i > 489) and (i < 492) then
                    assert (vsync = '1') report "Error: vsync is not up on cycle " & integer'image(i) severity failure;
                else
                    assert (vsync = '0') report "Error: vsync is not down on cycle " & integer'image(i) severity failure;
                end if;
            end loop;
        end loop;
        wait;
    end process;

end;
