-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity rs is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           amount : in std_logic_vector (4 downto 0);
           opcode : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carry : out STD_LOGIC);
end rs;

architecture Behavioral of rs is
signal output1, output2, output3, output4 : std_logic_vector(31 downto 0);
signal carry1, carry2, carry3, carry4: std_logic;
begin
s1: entity work.rs1 port map (
    opr => opr,
    active => amount(0),
    opcode => opcode, 
    carryin => amount(0), 
    output => output1, 
    carryout => carry1);
    
s2: entity work.rs2 port map (
    opr => output1,
    active => amount(1),
    opcode => opcode,
    carryin => carry1,
    output => output2,
    carryout => carry2);
    
s3: entity work.rs4 port map (
    opr => output2,
    active => amount(2),
    opcode => opcode,
    carryin => carry2,
    output => output3,
    carryout => carry3);
    
s4: entity work.rs8 port map (
    opr => output3,
    active => amount(3),
    opcode => opcode,
    carryin => carry3,
    output => output4,
    carryout => carry4);
    
s5: entity work.rs16 port map (
    opr  => output4,
    active => amount(4),
    opcode => opcode,
    carryin => carry4,
    output => output,
    carryout => carry);

end Behavioral;
