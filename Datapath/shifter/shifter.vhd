
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           opcode : in STD_LOGIC_VECTOR (1 downto 0);
           amt : in STD_LOGIC_VECTOR (4 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carry : out STD_LOGIC);
end shifter;

architecture Behavioral of shifter is 
signal output1, output2, output3: std_logic_vector(31 downto 0);
signal carryout1, carryout2, carryout3: std_logic;
begin
lsls:entity work.lsl port map (opr, shift_amount, '0', output1, carryout1);
rss: entity work.rs  port map (opr, shift_amount, opcode, output2, carryout2);

output <= output1 when opcode = "00" else 
          output2;
carry <= carryout1 when opcode = "00" else
         carryout2;

end Behavioral;
