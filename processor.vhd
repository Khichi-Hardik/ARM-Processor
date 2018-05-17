library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library UNISIM;

entity processor is 
    port (
        cl: in std_logic;
        pc_res: in std_logic;
        
        -- register output
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
        r15: out std_logic_vector(31 downto 0);
        
        -- test
        test1_out: out std_logic_vector(31 downto 0);
        test2_out: out std_logic_vector(31 downto 0);
        
        state: out integer
    );
end entity;


architecture beh of processor is
--signal PW_int: std_logic;   -- w
signal IorD_int: std_logic_vector(0 downto 0); -- Instruction (1) or PC inc. (0)
signal IRW_int: std_logic; -- Instruction write/save enable
signal DRW_int: std_logic; -- data register write enable
signal M2R_int: std_logic_vector(1 downto 0); -- pick data or result to write to register file
signal Rsrc_int: std_logic_vector(1 downto 0); -- pick rd or rm for rad2
signal RW_int: std_logic; -- write enable for register file
signal AW_int: std_logic;  -- rf out1 store reg write enable
signal BW_int: std_logic;  -- rf out2 store B reg write enable
signal XW_int: std_logic;  -- rf out2 store X reg write enable
signal Asrc1_int: std_logic_vector(0 downto 0); -- pick pc for inc. or rf out1 for calc
signal Asrc2_int: std_logic_vector(1 downto 0); -- choose from rf out 2 or 4 (for pc+4 step) or Imm or offset for branch
signal op_int: std_logic_vector(3 downto 0);  -- op code for alu
signal Fset_int: std_logic; -- set flags along command
signal ReW_int: std_logic;  -- reg store write enable

-- self defined
signal memw_int: std_logic_vector(3 downto 0); 
signal shiftSrc_int: std_logic_vector(1 downto 0);
signal amtSrc_int: std_logic_vector(1 downto 0);
signal wadsrc_int: std_logic_vector(1 downto 0);
signal rad1src_int: std_logic_vector(0 downto 0);

signal typ_dt_int: std_logic_vector(3 downto 0);
signal byte_off_int: std_logic_vector(1 downto 0);

signal CW_int: std_logic;
signal DW_int: std_logic;

signal ins_int: std_logic_vector(31 downto 0);
signal Flags_int: std_logic_vector(3 downto 0);


-- Bctrl related
signal pred_int: std_logic;
begin
DP: entity work.datapath port map (
    IorD => IorD_int,
    IRW => IRW_int,
    DRW => DRW_int,
    M2R => M2R_int,
    Rsrc => Rsrc_int,
    RW => RW_int,
    AW => AW_int,
    BW => BW_int,
    XW => XW_int,
    Asrc1 => Asrc1_int,
    Asrc2 => Asrc2_int,
    op => op_int,
    Fset => Fset_int,
    ReW => ReW_int,
    
    -- self defined
    clock => cl,
    pc_reset => pc_res,
    memw => memw_int,
    
    shiftSrc => shiftSrc_int,
    amtSrc => amtSrc_int,
    wadsrc => wadsrc_int,
    rad1src => rad1src_int,
    
    typ_dt => typ_dt_int,
    byte_off => byte_off_int,
    
    CW => CW_int,
    DW => DW_int,
    
    instruction => ins_int,
    Flags => Flags_int,
    
    -- test
    test1_outer => test1_out,
    test2_outer => test2_out,
    
    r0_out => r0,
    r1_out => r1,
    r2_out => r2,
    r3_out => r3,
    r4_out => r4,
    r5_out => r5,
    r6_out => r6,
    r7_out => r7,
    r8_out => r8,
    r9_out => r9,
    r10_out => r10,
    r11_out => r11,
    r12_out => r12,
    r13_out => r13,
    r14_out => r14,
    r15_out => r15
);
MC: entity work.main_control port map (
    clock => cl,
    ins => ins_int,
    pred => pred_int,

    IorD => IorD_int,
    IRW => IRW_int,
    DRW => DRW_int,
    M2R => M2R_int,
    Rsrc => Rsrc_int,
    RW => RW_int,
    AW => AW_int,
    BW => BW_int,
    XW => XW_int,
    Asrc1 => Asrc1_int,
    Asrc2 => Asrc2_int,
    op => op_int,
    Fset => Fset_int,
    ReW => ReW_int,
    
    --self defined
    memw => memw_int,
    shiftSrc => shiftSrc_int,
    amtSrc => amtSrc_int,
    wadsrc => wadsrc_int,
    rad1src => rad1src_int,
    
    typ_dt => typ_dt_int,
    byte_off => byte_off_int,
    
    CW => CW_int,
    DW => DW_int,
    state_out => state
);
BC: entity work.Bctrl port map (
    ins31_28 => ins_int(31 downto 28),
    znvc => Flags_int,
    p => pred_int
);
end architecture;
