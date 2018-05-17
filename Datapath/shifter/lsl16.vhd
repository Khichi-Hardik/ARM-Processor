
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lsl16 is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           shifter : in std_logic;
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end lsl16;

architecture Behavioral of lsl16 is

begin

output <= opr(15 downto 0) & "0000000000000000" when shifter = '1' else
          opr;
carryout <= opr(16) when shifter = '1' else
            carryin;

end Behavioral;
