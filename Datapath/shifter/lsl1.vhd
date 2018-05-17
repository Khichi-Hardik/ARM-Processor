

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity lsl1 is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
           shifter : in std_logic;
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end lsl1;

architecture Behavioral of lsl1 is
begin

output <= opr(30 downto 0) & '0' when shifter = '1' else
          opr;
carryout <= opr(31) when shifter = '1' else
            carryin;

end Behavioral;
