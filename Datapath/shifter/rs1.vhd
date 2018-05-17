
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rs1 is
    Port ( opr : in STD_LOGIC_VECTOR (31 downto 0);
            
           active : in std_logic;
           opcode : in STD_LOGIC_VECTOR (1 downto 0);
           carryin : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (31 downto 0);
           carryout : out STD_LOGIC);
end rs1;

architecture Behavioral of rs1 is
signal msb : std_logic:= opr(31);
signal mode : std_logic;
begin

mode <= '0' when opcode = "01" else
        opr(31) when opcode = "10" else
        opr(0) when opcode = "11";

output <= mode & opr(31 downto 1) when active = '1' else
          opr;
carryout <= opr(0) when active = '1' else
           carryin;
           
end Behavioral;
