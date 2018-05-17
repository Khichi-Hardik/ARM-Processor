library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;  
use UNISIM.Vcomponents.all;

entity alu is
    port (
        a: in std_logic_vector(31 downto 0);
        b: in std_logic_vector(31 downto 0);
        operation: in std_logic_vector(3 downto 0);
        carryIn: in std_logic;
        c_in_from_shifter: in std_logic;
        result: out std_logic_vector(31 downto 0);
        flags: out std_logic_vector(3 downto 0)
        -- 3z 2n 1v 0c
    );    
end entity;

architecture beh of alu is
signal res: std_logic_vector (0 to 31);
signal c31: std_logic;
signal c32: std_logic;
begin
    process(a,b,operation)
    begin
        
        --Arithmetic
        --add   
        if (operation = "0100") then
            res <= a + b;
--            c31 <= ((a(31) xor b(31)) xor res(31));
--            c32 <= (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);
        --sub    
        elsif (operation = "0010") then
            res <= a + (not b) + "00000000000000000000000000000001";
--            c31 <= ((a(31) xor (not b(31))) xor res(31));
--            c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
        --rsb    
        elsif (operation = "0011") then
            res <= (not a) + b + "00000000000000000000000000000001";
--            c31 <= ((not (a(31)) xor b(31)) xor res(31));
--            c32 <= ((not (a(31)) and b(31)) or ((not (a(31))) and c31) or (b(31) and c31));
        --adc    
        elsif (operation = "0101") then
            res <= a + b + ("0000000000000000000000000000000" & carryIn);
--            c31 <= ((a(31) xor b(31)) xor res(31));
--            c32 <= (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);
        --sbc
        elsif (operation = "0110") then
            res <= a + (not b) + ("0000000000000000000000000000000" & carryIn);
--            c31 <= ((a(31) xor (not b(31))) xor res(31));
--            c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
        --rsc
        elsif (operation = "0111") then 
            res <= (not a) + b + ("0000000000000000000000000000000" & carryIn);
--            c31 <= (((not a(31)) xor b(31)) xor res(31));
--            c32 <= ((not a(31)) and b(31)) or ((not a(31)) and c31) or (b(31) and c31);
        
        --Logical
        --and
        elsif (operation = "0000") then
            res <= a and b;
--            c31 <= '0';
--            c32 <= '0';
        --orr
        elsif (operation = "1100") then
            res <= a or b;
--            c31 <= '0';
--            c32 <= '0';
        --eor
        elsif (operation = "0001") then
            res <= a xor b;
--            c31 <= '0';
--            c32 <= '0';     
        --bic
        elsif (operation = "1110") then
            res <= a and (not b);
--            c31 <= ((a(31) xor (not b(31))) xor res(31));
--            c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
        
        --Test
        --cmp
        elsif (operation = "1010") then
            res <= a + (not b) + "00000000000000000000000000000001";
--            c31 <= ((a(31) xor (not b(31))) xor res(31));
--            c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
        --cmn
        elsif (operation = "1011") then
            res <= a + b;
--            c31 <= ((a(31) xor b(31)) xor res(31));
--            c32 <= (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);
        --tst
        elsif (operation = "1000") then
            res <= a and b;
--            c31 <= '0';
--            c32 <= '0';
        --teq
        elsif (operation = "1001") then
            res <= a xor b; 
--            c31 <= '0';
--            c32 <= '0';
        
        --Move
        --mov
        elsif (operation = "1101") then
            res <= b;
--            c31 <= '0';
--            c32 <= '0';
        --mvn
        elsif (operation = "1111") then
            res <= (not b);
--            c31 <= '0';
--            c32 <= '0';
        end if;
    end process;

process(a,b,res)
    begin
    --Arithmetic
    --add   
    if (operation = "0100") then
        c31 <= ((a(31) xor b(31)) xor res(31));
        c32 <= (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);
    --sub    
    elsif (operation = "0010") then
        c31 <= ((a(31) xor (not b(31))) xor res(31));
        c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
    --rsb    
    elsif (operation = "0011") then
        c31 <= ((not (a(31)) xor b(31)) xor res(31));
        c32 <= ((not (a(31)) and b(31)) or ((not (a(31))) and c31) or (b(31) and c31));
    --adc    
    elsif (operation = "0101") then
        c31 <= ((a(31) xor b(31)) xor res(31));
        c32 <= (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);
    --sbc
    elsif (operation = "0110") then
        c31 <= ((a(31) xor (not b(31))) xor res(31));
        c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
    --rsc
    elsif (operation = "0111") then 
        c31 <= (((not a(31)) xor b(31)) xor res(31));
        c32 <= ((not a(31)) and b(31)) or ((not a(31)) and c31) or (b(31) and c31);
    
    --Logical
    --and
    elsif (operation = "0000") then
        c31 <= '0';
        c32 <= '0';
    --orr
    elsif (operation = "1100") then
        c31 <= '0';
        c32 <= '0';
    --eor
    elsif (operation = "0001") then
        c31 <= '0';
        c32 <= '0';     
    --bic
    elsif (operation = "1110") then
        c31 <= ((a(31) xor (not b(31))) xor res(31));
        c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
    
    --Test
    --cmp
    elsif (operation = "1010") then
        c31 <= ((a(31) xor (not b(31))) xor res(31));
        c32 <= (a(31) and (not b(31))) or (a(31) and c31) or ((not b(31)) and c31);
    --cmn
    elsif (operation = "1011") then
        c31 <= ((a(31) xor b(31)) xor res(31));
        c32 <= (a(31) and b(31)) or (a(31) and c31) or (b(31) and c31);
    --tst
    elsif (operation = "1000") then
        c31 <= '0';
        c32 <= '0';
    --teq
    elsif (operation = "1001") then
        c31 <= '0';
        c32 <= '0';
    
    --Move
    --mov
    elsif (operation = "1101") then
        c31 <= '0';
        c32 <= '0';
    --mvn
    elsif (operation = "1111") then
        c31 <= '0';
        c32 <= '0';
    end if;
end process;

result <= res;
flags(3) <= '0' when res = "00000000000000000000000000000000" else
                     '1';
flags(2) <= res(31);
flags(1) <= c31 xor c32;
flags(0) <= c32 when (not (operation = "1101") and not(operation = "1111")) else c_in_from_shifter;

end architecture;