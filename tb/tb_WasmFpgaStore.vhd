library IEEE;
use IEEE.STD_LOGIC_1164.all;

use IEEE.NUMERIC_STD.all;

library work;
use work.tb_types.all;

entity tb_WasmFpgaStore is
    generic (
        stimulus_path : string := "../../../../../simstm/";
        stimulus_file : string := "WasmFpgaStore.stm"
    );
end;

architecture behavioural of tb_WasmFpgaStore is

    signal Clk100M : std_logic := '0';
    signal Rst : std_logic := '1';
    signal nRst : std_logic := '0';

    signal WasmFpgaStore_FileIo : T_WasmFpgaStore_FileIo;
    signal FileIo_WasmFpgaStore : T_FileIo_WasmFpgaStore;

    signal StoreArea_Adr : std_logic_vector(23 downto 0);
    signal StoreArea_Sel : std_logic_vector(3 downto 0);
    signal StoreArea_We : std_logic;
    signal StoreArea_Stb : std_logic;
    signal StoreArea_DatOut : std_logic_vector(31 downto 0);
    signal StoreArea_DatIn: std_logic_vector(31 downto 0);
    signal StoreArea_Ack : std_logic;
    signal StoreArea_Cyc : std_logic_vector(0 downto 0);

    constant CLK100M_PERIOD : time := 10 ns;

    component WbRam is
        port ( 
            Clk : in std_logic;
            nRst : in std_logic;
            Adr : in std_logic_vector(23 downto 0);
            Sel : in std_logic_vector(3 downto 0);
            DatIn : in std_logic_vector(31 downto 0); 
            We : in std_logic;
            Stb : in std_logic; 
            Cyc : in std_logic_vector(0 downto 0);
            DatOut : out std_logic_vector(31 downto 0);
            Ack : out std_logic
        );
    end component;

    component tb_FileIo is
      generic (
        stimulus_path: in string;
        stimulus_file: in string
      );
      port (
        Clk : in std_logic;
        Rst : in std_logic;
        WasmFpgaStore_FileIo : in T_WasmFpgaStore_FileIo;
        FileIo_WasmFpgaStore : out T_FileIo_WasmFpgaStore
      );
    end component;

    component WasmFpgaStore
      port (
        Clk : in std_logic;
        nRst : in std_logic;
        Adr : in std_logic_vector(23 downto 0);
        Sel : in std_logic_vector(3 downto 0);
        DatIn : in std_logic_vector(31 downto 0);
        We : in std_logic;
        Stb : in std_logic;
        Cyc : in std_logic_vector(0 downto 0);
        DatOut : out std_logic_vector(31 downto 0);
        Ack : out std_logic;
        Memory_Adr : out std_logic_vector(23 downto 0);
        Memory_Sel : out std_logic_vector(3 downto 0);
        Memory_We : out std_logic;
        Memory_Stb : out std_logic;
        Memory_DatOut : out std_logic_vector(31 downto 0);
        Memory_DatIn: in std_logic_vector(31 downto 0);
        Memory_Ack : in std_logic;
        Memory_Cyc : out std_logic_vector(0 downto 0)
      );
    end component;

begin

    nRst <= not Rst;

    Clk100MGen : process is
    begin
      Clk100M <= not Clk100M;
      wait for CLK100M_PERIOD / 2;
    end process;

    RstGen : process is
    begin
      Rst <= '1';
      wait for 100ns;
      Rst <= '0';
      wait;
    end process;

    tb_FileIo_i : tb_FileIo
      generic map (
        stimulus_path => stimulus_path,
        stimulus_file => stimulus_file
      )
      port map (
        Clk => Clk100M,
        Rst => Rst,
        WasmFpgaStore_FileIo => WasmFpgaStore_FileIo,
        FileIo_WasmFpgaStore => FileIo_WasmFpgaStore
      );

    WbRam_i : WbRam
        port map ( 
            Clk => Clk100M,
            nRst => nRst,
            Adr => StoreArea_Adr,
            Sel => StoreArea_Sel,
            DatIn => StoreArea_DatIn,
            We => StoreArea_We,
            Stb => StoreArea_Stb,
            Cyc => StoreArea_Cyc,
            DatOut => StoreArea_DatOut,
            Ack => StoreArea_Ack
        );

    WasmFpgaStore_i : WasmFpgaStore
      port map (
        Clk => Clk100M,
        nRst => nRst,
        Adr => FileIo_WasmFpgaStore.Adr,
        Sel => FileIo_WasmFpgaStore.Sel,
        DatIn => FileIo_WasmFpgaStore.DatIn,
        We => FileIo_WasmFpgaStore.We,
        Stb => FileIo_WasmFpgaStore.Stb,
        Cyc => FileIo_WasmFpgaStore.Cyc,
        DatOut => WasmFpgaStore_FileIo.DatOut,
        Ack => WasmFpgaStore_FileIo.Ack,
        Memory_Adr => StoreArea_Adr,
        Memory_Sel => StoreArea_Sel,
        Memory_We => StoreArea_We,
        Memory_Stb => StoreArea_Stb,
        Memory_DatOut => StoreArea_DatIn,
        Memory_DatIn => StoreArea_DatOut,
        Memory_Ack => StoreArea_Ack,
        Memory_Cyc => StoreArea_Cyc
      );

end;
