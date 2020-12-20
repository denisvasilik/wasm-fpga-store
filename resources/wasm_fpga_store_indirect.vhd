

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.WasmFpgaStoreWshBn_Package.all;

entity tb_WasmFpgaStoreWshBn is
end tb_WasmFpgaStoreWshBn;

architecture arch_for_test of tb_WasmFpgaStoreWshBn is

    component tbs_WshFileIo is              
    generic (                               
         inp_file  : string;                
         outp_file : string                 
        );                                  
    port(                                   
        clock        : in    std_logic;     
        reset        : in    std_logic;     
        WshDn        : out   T_WshDn;       
        WshUp        : in    T_WshUp        
        );                                  
    end component;                          



    component WasmFpgaStoreWshBn is
        port (
            Clk : in std_logic;
            Rst : in std_logic;
            WasmFpgaStoreWshBnDn : in T_WasmFpgaStoreWshBnDn;
            WasmFpgaStoreWshBnUp : out T_WasmFpgaStoreWshBnUp;
            WasmFpgaStoreWshBn_UnOccpdRcrd : out T_WasmFpgaStoreWshBn_UnOccpdRcrd;
            WasmFpgaStoreWshBn_StoreBlk : out T_WasmFpgaStoreWshBn_StoreBlk;
            StoreBlk_WasmFpgaStoreWshBn : in T_StoreBlk_WasmFpgaStoreWshBn
         );
    end component; 


    signal Clk : std_logic := '0';                                         
    signal Rst : std_logic := '1';                                         



    signal WshDn : T_WshDn;
    signal WshUp : T_WshUp;
    signal Wsh_UnOccpdRcrd : T_Wsh_UnOccpdRcrd;
    signal Wsh_StoreBlk : T_Wsh_StoreBlk;
    signal StoreBlk_Wsh : T_StoreBlk_Wsh;



begin 


    i_tbs_WshFileIo : tbs_WshFileIo            
    generic map (                              
        inp_file  => "tb_mC_stimuli.txt",      
        outp_file => "src/tb_mC_trace.txt")    
    port map (                                 
        clock   => Clk,                        
        reset   => Rst,                        
        WshDn   => WshDn,                      
        WshUp   => WshUp                       
    );                                         



    -- ---------- map wishbone component ---------- 

    i_WasmFpgaStoreWshBn :  WasmFpgaStoreWshBn
     port map (
        WshDn => WshDn,
        WshUp => WshUp,
        Wsh_UnOccpdRcrd => Wsh_UnOccpdRcrd,
        Wsh_StoreBlk => Wsh_StoreBlk,
        StoreBlk_Wsh => StoreBlk_Wsh
        );

    -- ---------- assign defaults to all wishbone inputs ---------- 

    -- ------------------- general additional signals ------------------- 

    -- ------------------- StoreBlk ------------------- 
    -- ControlReg  
    -- StatusReg  
    StoreBlk_Wsh.Busy <= '0';
    -- ModuleInstanceUidReg  
    -- SectionUidReg  
    -- IdxReg  
    -- AddressReg  
    StoreBlk_Wsh.Address_ToBeRead <= (others => '0');



    WshDn.Clk <= Clk;                                                  
    WshDn.Rst <= Rst;                                                  
    -- ---------- drive testbench time --------------------                       
    Clk   <= TRANSPORT NOT Clk AFTER 12500 ps;  -- 40Mhz                       
    Rst   <= TRANSPORT '0' AFTER 100 ns;                                       


end architecture;

