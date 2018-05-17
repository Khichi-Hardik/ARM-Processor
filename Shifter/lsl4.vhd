
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lsl4 is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           shifter : in std_logic;
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end lsl4;

architecture Behavioral of lsl4 is

begin
output <= opr(27 downto 0) & "0000" when shifter = '1' else
          opr;
carryout <= opr(28) when shifter = '1' else
            carryin;

end Behavioral;
