library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pmpath is
    port (
    type_of_dt: in std_logic_vector(3 downto 0); -- 0/1 3(str/ldr = l) 2(word/byte = b) 1(not/halfword = H) 0(unsigned/signed = S)
    byte_offset: in std_logic_vector(1 downto 0);
    data_from_reg: in std_logic_vector(31 downto 0);
    data_from_mem: in std_logic_vector(31 downto 0);
    
    
    data_to_mem: out std_logic_vector(31 downto 0);
    data_to_reg: out std_logic_vector(31 downto 0);
    mem_write_en: out std_logic_vector(3 downto 0)
    
    );
end entity;

 architecture beh of pmpath is
signal inp: std_logic_vector(31 downto 0);
signal outp: std_logic_vector(31 downto 0);
signal prefix_bus: std_logic_vector(23 downto 0);
signal prefix: std_logic;
signal halfword: std_logic_vector(15 downto 0);
signal byte: std_logic_vector(7 downto 0);
begin
    byte <= inp(31 downto 24) when byte_offset = "11" else
            inp(23 downto 16) when byte_offset = "10" else
            inp(15 downto 8) when byte_offset = "01" else
            inp(7 downto 0) when byte_offset = "00";
    
    halfword <= inp(15 downto 0) when byte_offset = "00" else
                inp(23 downto 8) when byte_offset = "01" else
                inp(31 downto 16); 
    
    -- ldr or str
    inp <= data_from_reg when type_of_dt(3) = '0' else
        data_from_mem when type_of_dt(3) = '1';
    data_to_mem <= outp when type_of_dt(3) = '0';
    data_to_reg <= outp when type_of_dt(3) = '1';
    
    mem_write_en <= "0011" when type_of_dt(3 downto 1) = "001" and byte_offset = "00" else
                        "0110" when type_of_dt(3 downto 1) = "001" and byte_offset = "01" else
                        "1100" when type_of_dt(3 downto 1) = "001" and (byte_offset = "10" or byte_offset = "11") else
                        "0001" when type_of_dt(3 downto 1) = "010" and byte_offset = "00" else
                        "0010" when type_of_dt(3 downto 1) = "010" and byte_offset = "01" else
                        "0100" when type_of_dt(3 downto 1) = "010" and byte_offset = "10" else
                        "1000" when type_of_dt(3 downto 1) = "010" and byte_offset = "11" else
                        "1111" when type_of_dt(3 downto 1) = "000" else
                        "0000";
                        
    prefix <= inp(15) when type_of_dt(3 downto 1) = "01" and byte_offset = "00" else
                inp(23) when type_of_dt(3 downto 1) = "01" and byte_offset = "01" else
                inp(31) when type_of_dt(3 downto 1) = "01" and (byte_offset = "10" or byte_offset = "11") else
                inp(7) when type_of_dt(3 downto 1) = "10" and byte_offset = "00" else
                inp(15) when type_of_dt(3 downto 1) = "10" and byte_offset = "01" else
                inp(23) when type_of_dt(3 downto 1) = "10" and byte_offset = "10" else
                inp(31) when type_of_dt(3 downto 1) = "10" and byte_offset = "11" else
                '0' when type_of_dt(3 downto 1) = "00" else
                '0';

    prefix_bus <= "111111111111111111111111" when prefix = '1' else
                    "000000000000000000000000";
    -- halfword or (word or byte)
    
    outp <= inp when type_of_dt(3) = '0' else
            prefix_bus and halfword when type_of_dt(3 downto 0) = "1011" and prefix = '1' else
            prefix_bus or halfword when type_of_dt(3 downto 0) = "1011" and prefix = '0' else
            "00000000000000000000000000000000" or halfword when type_of_dt(3 downto 0) = "1010" else
            prefix_bus and byte when type_of_dt(3 downto 0) = "1101" and prefix = '1' else
            prefix_bus or byte when type_of_dt(3 downto 0) = "1101" and prefix = '0' else
            "00000000000000000000000000000000" or byte when type_of_dt(3 downto 0) = "1100" else
            inp when type_of_dt(3 downto 1) = "100" else
            inp;
            
    

end architecture;