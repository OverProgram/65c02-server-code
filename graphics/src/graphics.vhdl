library ieee;
library unimacro;
use ieee.std_logic_1164.all;
use unimacro.vcomponents.all;

entity Graphics is
    port(
        color_out   : out std_logic_vector(7 downto 0); -- 8-bit color output
        hsync       : out std_logic;                    -- Hsync VGA signal
        vsync       : out std_logic;                    -- Vsync VGA signal
        clk         : in std_logic;                     -- 25MHz clock input
        rst         : in std_logic;                     -- Reset
        dbg         : out std_logic_vector(9 downto 0)
    );
end Graphics;

architecture graphicsBehav of Graphics is

    component IBUFG
        port(
            I : in std_logic;
            
            O : out std_logic
        );
    end component;

    -- component ODDR2
    --     port(
    --         D0 : in std_logic;
    --         D1 : in std_logic;
    --         C0 : in std_logic;
    --         C1 : in std_logic;
    --         Q : out std_logic
    --     );
    -- end component;

    -- component BUFG
    --     port(
    --         I : in std_logic;
            
    --         O : out std_logic
    --     );
    -- end component;

    -- component DCM_SP
    --     generic(
    --         CLKFX_DIVIDE : integer;
    --         CLKFX_MULTIPLY : integer
    --     );

    --     port(
    --         CLKIN : in std_logic;
    --         RST : in std_logic;
    --         CLKFX : out std_logic;
    --         CLKFX180 : out std_logic;
    --         STATUS : out std_logic_vector(7 downto 0);
    --         LOCKED : out std_logic
    --     );
    -- end component;

    component VGAController
        port(
            pixle : out std_logic_vector(9 downto 0);
            vpixle : out std_logic_vector(9 downto 0);
    
            hsync : out std_logic;  
            vsync : out std_logic;
    
            clk : in std_logic;
            rst : in std_logic
        );
    end component;


    -- signal pixle_clk : std_logic;
    signal clk_int : std_logic;
    -- signal clk_dcm : std_logic;
    -- signal clk_buf : std_logic;
    -- signal pixle : std_logic_vector(9 downto 0);
    signal dbga : std_logic_vector(9 downto 0);
    signal dbgb : std_logic_vector(9 downto 0);

begin

    color_out <= "11111111";

    -- hsync <= '1';
    -- vsync <= '1';

    CLK_IN_BUFFER: IBUFG port map (
        I => clk,
        O => clk_int
    );

    -- DCM_CLK: DCM_SP generic map (8, 25) port map (
    --     CLKIN => clk_int,
    --     RST => '1',
    --     CLKFX => clk_dcm
    -- );

    -- CLK_BUFFER: BUFG port map (
    --     I => clk_dcm,
    --     O => clk_buf
    -- );

    -- CLK_FORWARD: ODDR2 port map (
    --     D0 => '1',
    --     D1 => '0',
    --     C0 => clk_buf,
    --     C1 => not clk_buf,
    --     Q => clk_out
    -- );

    -- clk_out <= clk_buf;

    TIMING_CONTROLLER: VGAController port map (
        hsync => hsync,
        vsync => vsync,
        clk => clk_int,
        rst => rst,
        pixle => dbga,
        vpixle => dbgb
    );

    --dbg <= '1' when (pixle = "1000000000") else '0';
    dbg <= dbga and dbgb;
end;