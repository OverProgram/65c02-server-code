library ieee;
use ieee.std_logic_1164.all;

entity VGAController is
    port(
        hsync : out std_logic;  -- Horizontal Sync
        vsync : out std_logic;  -- Vertical Sync

        clk : in std_logic;     -- Pixle Clock (25.175MHz)
        rst : in std_logic      -- Reset
    );
end VGAController;

architecture vgaControllerBehav of VGAController is

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

    component Latch
        port(
            S : in std_logic;
            R : in std_logic;
            
            Q: out std_logic;
            QB : out std_logic
        );
    end component;

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

    signal pixle : std_logic_vector(9 downto 0);
    signal vpixle : std_logic_vector(9 downto 0);
    signal vpixle_rst : std_logic;
    signal hsyncS : std_logic;
    signal hsyncR : std_logic;
    signal vsyncS : std_logic;
    signal vsyncR : std_logic;
    signal vclk : std_logic;

    signal rst_col : std_logic;
    signal rst_row : std_logic;

begin

    rst_col <= rst or vclk;
    rst_row <= rst or vpixle_rst;

    COL_COUNTER: BitCounter generic map (10) port map (
        pixle,
        rst_col,
        clk
    );

    ROW_COUNTER: BitCounter generic map (10) port map (
        vpixle,
        rst_row,
        vclk
    );

    HSYNC_SET: Comparator generic map (10) port map (
        pixle,
        "1010010000",
        hsyncS
    );

    HSYNC_RESET: Comparator generic map (10) port map (
        pixle,
        "1011110000",
        hsyncR
    );

    VSYNC_CLK: Comparator generic map (10) port map (
        pixle,
        "1100100000",
        vclk
    );

    VSYNC_SET: Comparator generic map (10) port map (
        vpixle,
        "0111010110",
        vsyncS
    );

    VSYNC_RESET: Comparator generic map (10) port map (
        vpixle,
        "0111011000",
        vsyncR
    );

    VSYNC_RST: Comparator generic map (10) port map (
        vpixle,
        "1000001101",
        vpixle_rst
    );

    HSYNC_LATCH: Latch port map(
        hsyncS,
        hsyncR,
        hsync,
        open
    );

    VSYNC_LATCH: Latch port map(
        vsyncS,
        vsyncR,
        vsync,
        open
    );

end;
