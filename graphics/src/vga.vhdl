library ieee;
use ieee.std_logic_1164.all;

entity VGAController is
    port(
        pixle : out std_logic_vector(9 downto 0);
        vpixle : out std_logic_vector(9 downto 0);

        hsync : out std_logic;  -- Horizontal Sync
        vsync : out std_logic;  -- Vertical Sync

        clk : in std_logic;     -- pixle_val Clock (25.175MHz)
        rst : in std_logic;     -- Reset
        vclk_out : out std_logic;
        dbg : out std_logic
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
            S : in std_logic;   -- Set
            R : in std_logic;   -- Reset
            
            Q: out std_logic;   -- Output
            clk : in std_logic  -- Clock input
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

    signal pixle_val : std_logic_vector(9 downto 0);
    signal vpixle_val : std_logic_vector(9 downto 0);
    signal vpixle_val_rst : std_logic;
    signal hsyncS : std_logic;
    signal hsyncR : std_logic;
    signal vsyncS : std_logic;
    signal vsyncR : std_logic;
    signal rst_hsync_latch : std_logic;
    signal rst_vsync_latch : std_logic;
    signal vclk : std_logic;
    signal vpixelclk : std_logic;

    signal rst_col : std_logic;
    signal rst_row : std_logic;

    signal first_rst : std_logic := '0';

begin

    rst_col <= rst and (not vclk) when first_rst = '1' else
               rst;
    rst_row <= rst and (not vpixle_val_rst) when first_rst = '1' else
               rst;

    rst_hsync_latch <= (not rst) or hsyncR;
    rst_vsync_latch <= (not rst) or vsyncR;

    pixle <= pixle_val;
    vpixle <= vpixle_val;

    vclk_out <= vclk;
    dbg <= vpixle_val_rst;

    vpixelclk <= vclk when first_rst = '1' else
                 clk;
                                  

    RST_LATCH: Latch port map (
        rst,
        '0',
        first_rst,
        clk
    );

    COL_COUNTER: BitCounter generic map (10) port map (
        pixle_val,
        rst_col,
        clk
    );

    ROW_COUNTER: BitCounter generic map (10) port map (
        vpixle_val,
        rst_row,
        vclk
    );

    HSYNC_SET: Comparator generic map (10) port map (
        pixle_val,
        "1010001111",
        hsyncS
    );

    HSYNC_RESET: Comparator generic map (10) port map (
        pixle_val,
        "1011101111",
        hsyncR
    );

    VSYNC_CLK: Comparator generic map (10) port map (
        pixle_val,
        "1100100000",
        vclk
    );

    VSYNC_SET: Comparator generic map (10) port map (
        vpixle_val,
        "0111101001",
        vsyncS
    );

    VSYNC_RESET: Comparator generic map (10) port map (
        vpixle_val,
        "0111101011",
        vsyncR
    );

    VSYNC_RST: Comparator generic map (10) port map (
        vpixle_val,
        "0111010111",
        vpixle_val_rst
    );

    HSYNC_LATCH: Latch port map(
        hsyncS,
        rst_hsync_latch,
        hsync,
        clk
    );

    VSYNC_LATCH: Latch port map(
        vsyncS,
        rst_vsync_latch,
        vsync,
        clk
    );

end;