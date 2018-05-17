library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

use ieee.numeric_std;

entity multiplier is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        s: out std_logic_vector(31 downto 0)
    );
end entity;

architecture behm of multiplier is
signal res: std_logic_vector (63 downto 0);
begin
    res <= a*b;
    s <= res(31 downto 0);
end architecture;