library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

library work;
  use work.WasmFpgaStoreWshBn_Package.all;

entity WasmFpgaStore is
  generic (
    PinMaxAddress : boolean := false;
    MaxAddress : std_logic_vector(31 downto 0) := x"00000000"
  );
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
end;

architecture WasmFpgaStoreArchitecture of WasmFpgaStore is

  signal Rst : std_logic;

  signal MaskedAdr : std_logic_vector(23 downto 0);

  signal StoreBlk_DatOut : std_logic_vector(31 downto 0);
  signal StoreBlk_Ack : std_logic;
  signal StoreBlk_Unoccupied_Ack : std_logic;

  signal WRegPulse_ControlReg : std_logic;

  signal Run : std_logic;
  signal Operation : std_logic;
  signal Busy : std_logic;

  signal ModuleInstanceUID : std_logic_vector(31 downto 0);
  signal SectionUID : std_logic_vector(31 downto 0);
  signal Idx : std_logic_vector(31 downto 0);
  signal Address_ToBeRead : std_logic_vector(31 downto 0);
  signal Address_ToBeWritten : std_logic_vector(31 downto 0);

  signal ModuleInstanceUID_Internal : std_logic_vector(31 downto 0);
  signal SectionUID_Internal : std_logic_vector(31 downto 0);
  signal Idx_Internal : std_logic_vector(31 downto 0);
  signal Address_Internal : std_logic_vector(31 downto 0);

  signal StoreMaxAddress : std_logic_vector(31 downto 0);
  signal StoreReadAddress : std_logic_vector(31 downto 0);
  signal StoreWriteAddress : std_logic_vector(31 downto 0);

  signal StoreState : std_logic_vector(7 downto 0);

  constant StoreStateIdle0 : std_logic_vector(7 downto 0) := x"00";
  constant StoreStateRead0 : std_logic_vector(7 downto 0) := x"01";
  constant StoreStateRead1 : std_logic_vector(7 downto 0) := x"02";
  constant StoreStateRead2 : std_logic_vector(7 downto 0) := x"03";
  constant StoreStateRead3 : std_logic_vector(7 downto 0) := x"04";
  constant StoreStateRead4 : std_logic_vector(7 downto 0) := x"05";
  constant StoreStateRead5 : std_logic_vector(7 downto 0) := x"06";
  constant StoreStateRead6 : std_logic_vector(7 downto 0) := x"07";
  constant StoreStateRead7 : std_logic_vector(7 downto 0) := x"08";
  constant StoreStateWrite0 : std_logic_vector(7 downto 0) := x"09";
  constant StoreStateWrite1 : std_logic_vector(7 downto 0) := x"0A";
  constant StoreStateWrite2 : std_logic_vector(7 downto 0) := x"0B";
  constant StoreStateWrite3 : std_logic_vector(7 downto 0) := x"0C";
  constant StoreStateWrite4 : std_logic_vector(7 downto 0) := x"0D";
  constant StoreStateWrite5 : std_logic_vector(7 downto 0) := x"0E";
  constant StoreStateWrite6 : std_logic_vector(7 downto 0) := x"0F";
  constant StoreStateWrite7 : std_logic_vector(7 downto 0) := x"10";
  constant StoreStateCompare0 : std_logic_vector(7 downto 0) := x"11";

  constant WASMFPGASTORE_ADR_BLK_MASK_StoreBlk : std_logic_vector(23 downto 0) := x"00001F";

begin

  Rst <= not nRst;

  Ack <= StoreBlk_Ack;
  DatOut <= StoreBlk_DatOut;

  MaskedAdr <= Adr and WASMFPGASTORE_ADR_BLK_MASK_StoreBlk;

  process (Clk, Rst) is
  begin
    if(Rst = '1') then
      ModuleInstanceUID_Internal <= (others => '0');
      SectionUID_Internal <= (others => '0');
      Idx_Internal <= (others => '0');
      Address_Internal <= (others => '0');
      Address_ToBeRead <= (others => '0');
      Memory_Cyc <= (others => '0');
      Memory_Stb <= '0';
      Memory_Adr <= (others => '0');
      Memory_Sel <= (others => '1');
      Memory_We <= '0';
      Memory_DatOut <= (others => '0');
      StoreMaxAddress <= MaxAddress;
      StoreReadAddress <= (others => '0');
      StoreWriteAddress <= (others => '0');
      Busy <= '0';
      StoreState <= StoreStateIdle0;
    elsif rising_edge(Clk) then
      if(StoreState = StoreStateIdle0) then
        Busy <= '0';
        Memory_Cyc <= (others => '0');
        Memory_Stb <= '0';
        Memory_Adr <= (others => '0');
        Memory_We <= '0';
        if (WRegPulse_ControlReg = '1' and Run = '1' and Operation = WASMFPGASTORE_VAL_Write) then
          Busy <= '1';
          Address_ToBeRead <= (others => '0');
          StoreState <= StoreStateWrite0;
        elsif(WRegPulse_ControlReg = '1' and Run = '1' and Operation = WASMFPGASTORE_VAL_Read) then
          Busy <= '1';
          StoreReadAddress <= (others => '0');
          Address_ToBeRead <= (others => '0');
          StoreState <= StoreStateRead0;
        end if;
      --
      -- Write ModuleInstanceUID
      --
      elsif(StoreState = StoreStateWrite0) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '1';
        Memory_DatOut <= ModuleInstanceUID;
        Memory_Adr <= StoreWriteAddress(23 downto 0);
        StoreState <= StoreStateWrite1;
      elsif(StoreState = StoreStateWrite1) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          StoreWriteAddress <= std_logic_vector(unsigned(StoreWriteAddress) + 1);
          StoreState <= StoreStateWrite2;
        end if;
      --
      -- Write SectionUID
      --
      elsif(StoreState = StoreStateWrite2) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '1';
        Memory_DatOut <= SectionUID;
        Memory_Adr <= StoreWriteAddress(23 downto 0);
        StoreState <= StoreStateWrite3;
      elsif(StoreState = StoreStateWrite3) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          StoreWriteAddress <= std_logic_vector(unsigned(StoreWriteAddress) + 1);
          StoreState <= StoreStateWrite4;
        end if;
      --
      -- Write Idx
      --
      elsif(StoreState = StoreStateWrite4) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '1';
        Memory_DatOut <= Idx;
        Memory_Adr <= StoreWriteAddress(23 downto 0);
        StoreState <= StoreStateWrite5;
      elsif(StoreState = StoreStateWrite5) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          StoreWriteAddress <= std_logic_vector(unsigned(StoreWriteAddress) + 1);
          StoreState <= StoreStateWrite6;
        end if;
      --
      -- Write Address
      --
      elsif(StoreState = StoreStateWrite6) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '1';
        Memory_DatOut <= Address_ToBeWritten;
        Memory_Adr <= StoreWriteAddress(23 downto 0);
        StoreState <= StoreStateWrite7;
      elsif(StoreState = StoreStateWrite7) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          StoreWriteAddress <= std_logic_vector(unsigned(StoreWriteAddress) + 1);
          if (PinMaxAddress = false) then
            StoreMaxAddress <= std_logic_vector(unsigned(StoreWriteAddress) + 1);
          end if;
          StoreState <= StoreStateIdle0;
        end if;
      --
      -- Read ModuleInstanceUID
      --
      elsif(StoreState = StoreStateRead0) then
        if(StoreReadAddress = StoreMaxAddress) then
          StoreState <= StoreStateIdle0;
        else
          Memory_Cyc <= "1";
          Memory_Stb <= '1';
          Memory_We <= '0';
          Memory_Adr <= StoreReadAddress(23 downto 0);
          StoreState <= StoreStateRead1;
        end if;
      elsif(StoreState = StoreStateRead1) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          ModuleInstanceUID_Internal <= Memory_DatIn;
          StoreReadAddress <= std_logic_vector(unsigned(StoreReadAddress) + 1);
          StoreState <= StoreStateRead2;
        end if;
      --
      -- Read SectionUID
      --
      elsif(StoreState = StoreStateRead2) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '0';
        Memory_Adr <= StoreReadAddress(23 downto 0);
        StoreState <= StoreStateRead3;
      elsif(StoreState = StoreStateRead3) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          SectionUID_Internal <= Memory_DatIn;
          StoreReadAddress <= std_logic_vector(unsigned(StoreReadAddress) + 1);
          StoreState <= StoreStateRead4;
        end if;
      --
      -- Read Idx
      --
      elsif(StoreState = StoreStateRead4) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '0';
        Memory_Adr <= StoreReadAddress(23 downto 0);
        StoreState <= StoreStateRead5;
      elsif(StoreState = StoreStateRead5) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          Idx_Internal <= Memory_DatIn;
          StoreReadAddress <= std_logic_vector(unsigned(StoreReadAddress) + 1);
          StoreState <= StoreStateRead6;
        end if;
      --
      -- Read Address
      --
      elsif(StoreState = StoreStateRead6) then
        Memory_Cyc <= "1";
        Memory_Stb <= '1';
        Memory_We <= '0';
        Memory_Adr <= StoreReadAddress(23 downto 0);
        StoreState <= StoreStateRead7;
      elsif(StoreState = StoreStateRead7) then
        if ( Memory_Ack = '1' ) then
          Memory_Cyc <= (others => '0');
          Memory_Stb <= '0';
          Memory_We <= '0';
          Address_Internal <= Memory_DatIn;
          StoreReadAddress <= std_logic_vector(unsigned(StoreReadAddress) + 1);
          StoreState <= StoreStateCompare0;
        end if;
      --
      -- Compare ModuleInstanceUID, SectionUID and Idx
      --
      elsif(StoreState = StoreStateCompare0) then
        if(ModuleInstanceUID_Internal = ModuleInstanceUID and
          SectionUID_Internal = SectionUID and
          Idx_Internal = Idx) then
          Address_ToBeRead <= Address_Internal;
          StoreState <= StoreStateIdle0;
        else
          StoreState <= StoreStateRead0;
        end if;
      end if;
    end if;
  end process;

  StoreBlk_WasmFpgaStore_i : entity work.StoreBlk_WasmFpgaStore
    port map (
      Clk => Clk,
      Rst => Rst,
      Adr => MaskedAdr,
      Sel => Sel,
      DatIn => DatIn,
      We => We,
      Stb => Stb,
      Cyc => Cyc,
      StoreBlk_DatOut => StoreBlk_DatOut,
      StoreBlk_Ack => StoreBlk_Ack,
      StoreBlk_Unoccupied_Ack => StoreBlk_Unoccupied_Ack,
      Operation => Operation,
      Run => Run,
      WRegPulse_ControlReg => WRegPulse_ControlReg,
      Busy => Busy,
      ModuleInstanceUID => ModuleInstanceUID,
      SectionUID => SectionUID,
      Idx => Idx,
      Address_ToBeRead => Address_ToBeRead,
      Address_Written => Address_ToBeWritten
    );

end;