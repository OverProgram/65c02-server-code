library ieee;
use ieee.std_logic_1164.all;

entity Reg is
    generic (
        size : integer := 8                         -- Reg Size
    );
    port(
        A : in std_logic_vector(size-1 downto 0);   -- Reg In
        B : out std_logic_vector(size-1 downto 0);  -- Reg Out

        OE : in std_logic;                          -- Output Enable (active low)
        WE : in std_logic;                          -- Write Enable (active low)

        rst : in std_logic;                         -- Reset (active low)
        clk : in std_logic                          -- Clock
    );
end Reg;

architecture regBehav of Reg is
    signal value : std_logic_vector(size-1 downto 0);
begin

    B <= value when OE='0' else "XXXXXXXX";

    process (clk)
    begin
        if clk = '1' then
            if WE = '0' then
                value <= A;
            elsif rst = '0' then
                value <= (size-1 downto 0 => '0');
            end if;
        end if;
    end process;

end;
