library ieee;
use ieee.std_logic_1164.all;

entity BitCounter is
    generic(
        size : integer := 8
    );
    port (
        C : out std_logic_vector(size-1 downto 0);
        
        rst : in std_logic;
        clk : in std_logic
    );
end BitCounter;

architecture counterBehav of BitCounter is

    component Incrementer
        generic(
            size : integer := 8
        );
        port (
            A : in std_logic_vector(size-1 downto 0);
            S : out std_logic_vector(size-1 downto 0)
        );
    end component;

    signal counter : std_logic_vector(size-1 downto 0);
    signal counterPlus : std_logic_vector(size-1 downto 0);

begin

    COUNTER_INC: Incrementer generic map (size) port map (counter, counterPlus);

    C <= counter;

    process(clk)
    begin
        if clk = '1' then
            if rst = '0' then 
                counter <= (size-1 downto 0 => '0');
            else
                counter <= counterPlus;
            end if;
        end if;
    end process;

end;
