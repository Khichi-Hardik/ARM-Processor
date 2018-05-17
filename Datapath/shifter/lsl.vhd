
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

S1: entity work.lsl1 port map (opr, amount(0), carryin, output1, carry1);
S2: entity work.lsl2 port map (output1, amount(1), carry1, output2, carry2);
s3: entity work.lsl4 port map (output2, amount(2), carry2, output3, carry3);
s4: entity work.lsl8 port map (output3, amount(3), carry3, output4, carry4);
s5: entity work.lsl16 port map (output4, amount(4), carry4, output, carryout); 

end Behavioral;
