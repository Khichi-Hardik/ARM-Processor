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
s1: entity work.rs1 port map (opr,  amount(0), opcode, '0', output1, carry1);
s2: entity work.rs2 port map (output1,  opcode,amount(1), carry1, output2, carry2);
s3: entity work.rs4 port map (output2, amount(2), opcode, carry2, output3, carry3);
s4: entity work.rs8 port map (output3, amount(3), opcode, carry3, output4, carry4);
s5: entity work.rs16 port map (output4, amount(4), opcode, carry4, output, carry);

end Behavioral;
