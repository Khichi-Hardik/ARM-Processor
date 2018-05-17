
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
    Port ( a : in STD_LOGIC_VECTOR (31 downto 0);
           typ : in STD_LOGIC_VECTOR (1 downto 0);
           amt : in STD_LOGIC_VECTOR (4 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           carry : out STD_LOGIC);
end shifter;

architecture Behavioral of shifter is 
signal output1, output2, output3: std_logic_vector(31 downto 0);
signal carryout1, carryout2, carryout3: std_logic;
begin
lsls: entity work.lsl port map (
    opr => a,
    amount => amt,
    carryin => '0',
    output => result,
    carryout => carryout1);
    
rss: entity work.rs  port map (
    opr => a,
    amount => amt,
    opcode => typ,
    output => output2,
    carry => carryout2);

result <= output1 when typ = "00" else 
          output2;
carry <= carryout1 when typ = "00" else
         carryout2;

end Behavioral;
