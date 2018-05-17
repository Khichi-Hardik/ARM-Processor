
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lsl is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           amount : in STD_LOGIC_VECTOR (4 downto 0);
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end lsl;

architecture Behavioral of lsl is
signal output1, output2, output3, output4, output5 : std_logic_vector(31 downto 0);
signal carry1, carry2, carry3, carry4, carry5 : std_logic;
begin

S1: entity work.lsl1 port map (
    opr => opr,
    shifter => amount(0),
    carryin => carryin,
    output => output1,
    carryout => carry1);
    
S2: entity work.lsl2 port map (
    opr => output1,
    shifter => amount(1),
    carryin => carry1,
    output => output2,
    carryout => carry2);
    
s3: entity work.lsl4 port map (
    opr => output2,
    shifter => amount(2),
    carryin => carry2,
    output => output3,
    carryout => carry3);
    
s4: entity work.lsl8 port map (
    opr => output3,
    shifter => amount(3),
    carryin => carry3,
    output => output4,
    carryout => carry4);
    
s5: entity work.lsl16 port map (
    opr => output4,
    shifter => amount(4),
    carryin => carry4,
    output => output,
    carryout => carryout); 

end Behavioral;
