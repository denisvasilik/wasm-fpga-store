library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.WasmFpgaStoreWshBn_Package.all;

entity WasmFpgaStore is
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
end entity;

architecture WasmFpgaStoreArchitecture of WasmFpgaStore is

  component StoreBlk_WasmFpgaStore is
    port (
      Clk : in std_logic;
      Rst : in std_logic;
      Adr : in std_logic_vector(23 downto 0);
      Sel : in std_logic_vector(3 downto 0);
      DatIn : in std_logic_vector(31 downto 0);
      We : in std_logic;
      Stb : in std_logic;
      Cyc : in  std_logic_vector(0 downto 0);
      StoreBlk_DatOut : out std_logic_vector(31 downto 0);
      StoreBlk_Ack : out std_logic;
      StoreBlk_Unoccupied_Ack : out std_logic;
      Run : out std_logic;
      Busy : in std_logic;
      ModuleInstanceUID : out std_logic_vector(31 downto 0);
      SectionUID : out std_logic_vector(31 downto 0);
      Idx : out std_logic_vector(31 downto 0);
      Address : in std_logic_vector(31 downto 0)
    );
  end component;

  signal Rst : std_logic;

  signal StoreBlk_DatOut : std_logic_vector(31 downto 0);
  signal StoreBlk_Ack : std_logic;
  signal StoreBlk_Unoccupied_Ack : std_logic;

  signal Run : std_logic;
  signal Busy : std_logic;
  signal ModuleInstanceUID : std_logic_vector(31 downto 0);
  signal SectionUID : std_logic_vector(31 downto 0);
  signal Idx : std_logic_vector(31 downto 0);
  signal Address : std_logic_vector(31 downto 0);
 
  signal StoreState : std_logic_vector(7 downto 0);

  constant StoreStateIdle0 : std_logic_vector(7 downto 0) := x"00";
  constant StoreStateAddress0 : std_logic_vector(7 downto 0) := x"00";

 begin

  Rst <= not nRst;

  Ack <= StoreBlk_Ack;
  DatOut <= StoreBlk_DatOut;

  process (Clk, Rst) is
  begin
    if(Rst = '1') then
      StoreState <= (others => '0');
    elsif rising_edge(Clk) then
      if(StoreState = StoreStateIdle0) then

      --
      -- Get address
      --
      elsif(StoreState = StoreStateAddress0) then

      end if;
    end if;
  end process;

  StoreBlk_WasmFpgaStore_i : StoreBlk_WasmFpgaStore
    port map (
      Clk => Clk,
      Rst => Rst,
      Adr => Adr,
      Sel => Sel,
      DatIn => DatIn,
      We => We,
      Stb => Stb,
      Cyc => Cyc,
      StoreBlk_DatOut => StoreBlk_DatOut,
      StoreBlk_Ack => StoreBlk_Ack,
      StoreBlk_Unoccupied_Ack => StoreBlk_Unoccupied_Ack,
      Run => Run,
      Busy => Busy,
      ModuleInstanceUID => ModuleInstanceUID,
      SectionUID => SectionUID,
      Idx => Idx,
      Address => Address
    );

end;