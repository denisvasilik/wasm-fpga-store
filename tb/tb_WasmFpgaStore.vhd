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

    constant CLK100M_PERIOD : time := 10 ns;

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
        Ack : out std_logic
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
        Ack => WasmFpgaStore_FileIo.Ack
      );

end;
