library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std;

entity datapath is
    port (
        -- figure defined inputs from controller
--        PW: in std_logic;   -- write to pc when 1
        IorD: in std_logic_vector(0 downto 0); -- Instruction (1) or PC inc. (0)
        IRW: in std_logic; -- Instruction write/save enable
        DRW: in std_logic; -- data register write enable
        M2R: in std_logic_vector(1 downto 0); -- pick data or result to write to register file
        Rsrc: in std_logic_vector(1 downto 0); -- pick rd or rm for rad2
        RW: in std_logic; -- write enable for register file
        AW: in std_logic;  -- rf out1 store reg write enable
        BW: in std_logic;  -- rf out2 store B reg write enable
        XW: in std_logic;  -- rf out2 store X reg write enable
        Asrc1: in std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
        Asrc2: in std_logic_vector(1 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
        op: in std_logic_vector(3 downto 0);  -- op code for alu
        Fset: in std_logic; -- set flags along command
        ReW: in std_logic;  -- reg store write enable
        
        -- self defined
        clock: in std_logic;
        pc_reset: in std_logic; -- for reg_file pc <= 0
        
        shiftSrc: in std_logic_vector(1 downto 0);
        amtSrc: in std_logic_vector(1 downto 0);
        wadsrc: in std_logic_vector(1 downto 0);
        rad1src: in std_logic_vector(0 downto 0);
        
        typ_dt: in std_logic_vector(3 downto 0);
        byte_off: in std_logic_vector(1 downto 0);
        memw: in std_logic_vector(3 downto 0);
        
        CW: in std_logic;
        DW: in std_logic;
        
        pc_out: out std_logic_vector(31 downto 0);
        instruction: out std_logic_vector(31 downto 0);
        Flags: out std_logic_vector(3 downto 0);
        
        -- tests
        test1_outer: out std_logic_vector(31 downto 0);
        test2_outer: out std_logic_vector(31 downto 0);
        
        -- register output
        r0_out: out std_logic_vector(31 downto 0);
        r1_out: out std_logic_vector(31 downto 0);
        r2_out: out std_logic_vector(31 downto 0);
        r3_out: out std_logic_vector(31 downto 0);
        r4_out: out std_logic_vector(31 downto 0);
        r5_out: out std_logic_vector(31 downto 0);
        r6_out: out std_logic_vector(31 downto 0);
        r7_out: out std_logic_vector(31 downto 0);
        r8_out: out std_logic_vector(31 downto 0);
        r9_out: out std_logic_vector(31 downto 0);
        r10_out: out std_logic_vector(31 downto 0);
        r11_out: out std_logic_vector(31 downto 0);
        r12_out: out std_logic_vector(31 downto 0);
        r13_out: out std_logic_vector(31 downto 0);
        r14_out: out std_logic_vector(31 downto 0);
        r15_out: out std_logic_vector(31 downto 0)
    );
end entity;

architecture beh of datapath is
-- registers
signal IR: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal DR: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal RES: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal A: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal B: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal C: std_logic:='0';
signal D: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal X: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
signal F: std_logic_vector(3 downto 0):="1000";
 
-- connections
signal mem_out: std_logic_vector(31 downto 0);
signal M2R_out: std_logic_vector(31 downto 0);
signal Rsrc_out: std_logic_vector(3 downto 0);
signal rd1_out: std_logic_vector(31 downto 0);
signal rd2_out: std_logic_vector(31 downto 0);
signal Asrc1_out: std_logic_vector(31 downto 0);
signal Asrc2_out: std_logic_vector(31 downto 0);
signal c_from_shifter: std_logic;
signal alu_out: std_logic_vector(31 downto 0);
signal alu_f_out: std_logic_vector(3 downto 0);
signal shiftSrc_out: std_logic_vector(31 downto 0);
signal amtSrc_out: std_logic_vector(4 downto 0);
signal shifter_out: std_logic_vector(31 downto 0);
signal b_off_out: std_logic_vector(31 downto 0);
signal four: std_logic_vector(31 downto 0):= "00000000000000000000000000000100";
signal res_out: std_logic_vector(31 downto 0);
signal IorD_out: std_logic_vector(31 downto 0);
signal r15_out_int: std_logic_vector(31 downto 0);
signal mul_out: std_logic_vector(31 downto 0);

signal wadsrc_out: std_logic_vector(3 downto 0);
signal rad1src_out: std_logic_vector(3 downto 0);

signal MW: std_logic_vector(3 downto 0);
signal MW_int: std_logic_vector(3 downto 0);
signal data_to_mem_int: std_logic_vector(31 downto 0);
signal data_to_reg_int: std_logic_vector(31 downto 0);

begin
-- components
ALU: entity work.alu port map (
    a => Asrc1_out,
    b => Asrc2_out,
    operation => op,
    carryIn => F(0),
    c_in_from_shifter => c_from_shifter,
    result => alu_out,
    flags => alu_f_out
);

RF: entity work.reg_file port map (
    raddr1 => rad1src_out,
    raddr2 => Rsrc_out,
    winp => m2r_out,
    waddr => wadsrc_out,
    we => RW,
    clock => clock,
    reset => pc_reset,
    
--    pc_we => PW,
--    pc_write => alu_out,
    rout1 => rd1_out,
    rout2 => rd2_out,
    r0 => r0_out,
    r1 => r1_out,
    r2 => r2_out,
    r3 => r3_out,
    r4 => r4_out,
    r5 => r5_out,
    r6 => r6_out,
    r7 => r7_out,
    r8 => r8_out,
    r9 => r9_out,
    r10 => r10_out,
    r11 => r11_out,
    r12 => r12_out,
    r13 => r13_out,
    r14 => r14_out,
    r15 => r15_out_int
);
r15_out <= r15_out_int;

MEM: entity work.memory_block_wrapper port map (
    BRAM_PORTA_0_addr => IorD_out,
    BRAM_PORTA_0_clk => clock,
    BRAM_PORTA_0_din => data_to_mem_int,
    BRAM_PORTA_0_dout => mem_out,
    BRAM_PORTA_0_en => '1',
    BRAM_PORTA_0_we => MW
);
MW <= memw and MW_int;

SHIFTER: entity work.shifter port map (
    a => shiftSrc_out,
    result => shifter_out,
    typ => IR(6 downto 5),
    amt => amtSrc_out,
    carry => c_from_shifter
);

MUL: entity work.multiplier port map (
    a => B,
    b => X,
    s => mul_out
);

P2M: entity work.pmpath port map (
    type_of_dt => typ_dt,
    byte_offset => byte_off,
    data_from_reg => B,
    data_from_mem => DR,
    
    
    data_to_mem => data_to_mem_int,
    data_to_reg => data_to_reg_int,
    mem_write_en => MW_int
);

-- all muxes
-- shift mux
shiftSrc_out <= B when shiftSrc = "00" else
                "000000000000000000000000" & IR(7 downto 0) when shiftSrc = "01" else
                "00000000" & IR(23 downto 0) when IR(23) = '0' else
                "11111111" & IR(23 downto 0);
                
-- amt mux
amtSrc_out <= X(4 downto 0) when amtSrc = "00" else
                "00010" when amtSrc = "01" else
                IR(11 downto 7) when amtSrc = "11" else
                IR(11 downto 8) & "0" when amtSrc = "11";

-- Asrc2 mux
Asrc2_out <= D when Asrc2 = "00" else
                four when Asrc2 = "01" else
                mul_out;

-- Asrc1 mux
Asrc1_out <= r15_out_int when Asrc1 = "0" else
                A;
                
-- IorD mux
IorD_out <= r15_out_int when IorD = "0" else
            RES;
            
-- Rsrc mux
Rsrc_out <= IR(11 downto 8) when Rsrc = "00" else
            IR(3 downto 0) when Rsrc = "01" else
            IR(15 downto 12) when Rsrc = "10";
            
-- m2r mux
m2r_out <= data_to_reg_int when m2r = "00" else
            RES when m2r = "01" else
            r15_out_int;
            
-- wadsrc mux
wadsrc_out <= IR(15 downto 12) when wadsrc = "00" else
                IR(19 downto 16) when wadsrc = "01" else
                "1111" when wadsrc = "10" else
                "1110";

-- rad1src 
rad1src_out <= IR(19 downto 16) when rad1src = "0" else 
                IR(15 downto 12);

-- datapath internal registers
-- flags registers
F <= alu_f_out when Fset = '1';
Flags <= F;

-- RES reg set
RES <= alu_out when ReW = '1';

--  A and B and X reg
A <= rd1_out when rising_edge(AW);
B <= rd2_out when rising_edge(BW);
X <= rd2_out when rising_edge(XW);

C <= c_from_shifter when rising_edge(CW);
D <= shifter_out when rising_edge(DW);

-- IR and DR reg
IR <= mem_out when IRW = '1';
DR <= mem_out when DRW = '1';

instruction <= IR;
-- tests
test1_outer <= RES;
test2_outer <= mul_out;
end architecture;