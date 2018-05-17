library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity reg_file is
    port (
        raddr1: in std_logic_vector(3 downto 0);
        raddr2: in std_logic_vector(3 downto 0);
        winp: in std_logic_vector(31 downto 0);
        waddr: in std_logic_vector(3 downto 0); 
        we: in std_logic;
        clock: in std_logic;
        reset: in std_logic;
        rout1: out std_logic_vector(31 downto 0);
        rout2: out std_logic_vector(31 downto 0);
        r0: out std_logic_vector(31 downto 0);
        r1: out std_logic_vector(31 downto 0);
        r2: out std_logic_vector(31 downto 0);
        r3: out std_logic_vector(31 downto 0);
        r4: out std_logic_vector(31 downto 0);
        r5: out std_logic_vector(31 downto 0);
        r6: out std_logic_vector(31 downto 0);
        r7: out std_logic_vector(31 downto 0);
        r8: out std_logic_vector(31 downto 0);
        r9: out std_logic_vector(31 downto 0);
        r10: out std_logic_vector(31 downto 0);
        r11: out std_logic_vector(31 downto 0);
        r12: out std_logic_vector(31 downto 0);
        r13: out std_logic_vector(31 downto 0);
        r14: out std_logic_vector(31 downto 0);
        r15: out std_logic_vector(31 downto 0)   
    );
end entity;

architecture beh of reg_file is
type reg_arr is array (0 to 15) of std_logic_vector(31 downto 0);
signal r: reg_arr:=(others=> (others=>'0'));
begin
    process(clock)
    variable raddr1_in: integer:= 0;
    variable raddr2_in: integer:= 0;
    variable waddr_in: integer:= 0;

    begin
        raddr1_in := conv_integer(unsigned(raddr1));
        raddr2_in := conv_integer(unsigned(raddr2));
        waddr_in := conv_integer(unsigned(waddr));

        if (rising_edge(clock)) then
            if (we = '1') then
                r(waddr_in) <= winp;
            end if;
            if (reset = '1') then
                r(15) <= "00000000000000000000000000000000";
            end if;
            rout1 <= r(raddr1_in);
            rout2 <= r(raddr2_in);
        end if;
        
    end process;
    
    
    r0 <= r(0);
    r1 <= r(1);
    r2 <= r(2);
    r3 <= r(3);
    r4 <= r(4);
    r5 <= r(5);
    r6 <= r(6);
    r7 <= r(7);
    r8 <= r(8);
    r9 <= r(9);
    r10 <= r(10);
    r11 <= r(11);
    r12 <= r(12);
    r13 <= r(13);
    r14 <= r(14);
    r15 <= r(15);
end architecture;
