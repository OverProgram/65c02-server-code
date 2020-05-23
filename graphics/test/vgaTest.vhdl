library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGATest is
end VGATest;

architecture vgaTestBehav of VGATest is

    component VGAController
    port(
        hsync : out std_logic;  -- Horizontal Sync
        vsync : out std_logic;  -- Vertical Sync

        clk : in std_logic;     -- Pixle Clock (25.175MHz)
        rst : in std_logic      -- Reset
    );
    end component;

    signal hsync : std_logic;
    signal vsync : std_logic;
    signal clk : std_logic;

begin

    TEST_VGA: VGAController port map (
        hsync => hsync,
        vsync => vsync,
        clk => clk,
        rst => '1'
    );

    process
    begin
        for i in 420000 downto 0 loop
            clk <= '1';
            wait for 20 ns;
            clk <= '0';
            wait for 20 ns;
        end loop;
        wait;
    end process;

end;
