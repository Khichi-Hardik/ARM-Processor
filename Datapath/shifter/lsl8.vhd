
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lsl8 is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           shifter : in std_logic;
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end lsl8;

architecture Behavioral of lsl8 is
begin

output <= opr(23 downto 0) & "00000000" when shifter = '1' else
          opr;
carryout <= opr(24) when shifter = '1' else
            carryin;

end Behavioral;
