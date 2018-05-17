library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

entity Bctrl is
    port (
        ins31_28: in std_logic_vector(3 downto 0);
        znvc: in std_logic_vector(3 downto 0);
        p: out std_logic
    );    
end entity;

architecture beh of Bctrl is
signal z: std_logic := '0';
signal n: std_logic := '0';
signal v: std_logic := '0';
signal c: std_logic := '0';
begin
    process(ins31_28,znvc)
    begin
        z <= znvc(3);
        n <= znvc(2);
        v <= znvc(1);
        c <= znvc(0);
    
        if(ins31_28 = "0000" and (z='1') ) then p<='1';
        elsif(ins31_28 = "0001" and (not(z)='1')) then p<='1';
        elsif(ins31_28 = "0010" and (c='1')) then p<='1';
        elsif(ins31_28 = "0011" and (not(c) = '1')) then p<='1';
        elsif(ins31_28 = "0100" and (n = '1')) then p<='1';
        elsif(ins31_28 = "0101" and (not(n) = '1')) then p<='1';
        elsif(ins31_28 = "0110" and (v = '1')) then p<='1';
        elsif(ins31_28 = "0111" and (not(v) = '1')) then p<='1';
        elsif(ins31_28 = "1000" and ((not(z) and c) = '1')) then p<='1';
        elsif(ins31_28 = "1001" and (not(not(z) and c) = '1')) then p<='1';
        elsif(ins31_28 = "1010" and (not(n xor v) = '1')) then p<='1';
        elsif(ins31_28 = "1011" and ((n xor v) = '1')) then p<='1';
        elsif(ins31_28 = "1100" and ( ((not(z)) and (not(n xor v))) = '1')) then p<='1';
        elsif(ins31_28 = "1101" and ( not((not(z)) and (not(n xor v))) = '1')) then p<='1';
        elsif(ins31_28 = "1110") then p<='1';
        else p<='0';
        end if;
    end process;
end architecture;