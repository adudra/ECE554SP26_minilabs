-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
-- Date        : Thu Jan 22 17:46:15 2026
-- Host        : Avery running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim
--               c:/Users/avery/ece554/minilabs/minilab0/minlab0.gen/sources_1/bd/minlab0/ip/minlab0_rom_ctrl_0_1/minlab0_rom_ctrl_0_1_sim_netlist.vhdl
-- Design      : minlab0_rom_ctrl_0_1
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xczu3eg-sfvc784-2-e
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity minlab0_rom_ctrl_0_1_rom_ctrl is
  port (
    dout : out STD_LOGIC_VECTOR ( 3 downto 0 );
    addr_oneshot : in STD_LOGIC_VECTOR ( 7 downto 0 );
    clk : in STD_LOGIC;
    enable : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of minlab0_rom_ctrl_0_1_rom_ctrl : entity is "rom_ctrl";
end minlab0_rom_ctrl_0_1_rom_ctrl;

architecture STRUCTURE of minlab0_rom_ctrl_0_1_rom_ctrl is
  signal addr : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \addr__0\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \addr_reg[2]_i_2_n_0\ : STD_LOGIC;
  signal \addr_reg[2]_i_3_n_0\ : STD_LOGIC;
  signal \addr_reg[2]_i_4_n_0\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal rom : STD_LOGIC_VECTOR ( 7 downto 0 );
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \addr_reg[0]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of \addr_reg[0]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \addr_reg[1]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \addr_reg[1]\ : label is "VCC:GE GND:CLR";
  attribute XILINX_LEGACY_PRIM of \addr_reg[2]\ : label is "LD";
  attribute XILINX_TRANSFORM_PINMAP of \addr_reg[2]\ : label is "VCC:GE GND:CLR";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \addr_reg[2]_i_3\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \addr_reg[2]_i_4\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \dout[4]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \dout[5]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \dout[6]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \dout[7]_i_2\ : label is "soft_lutpair1";
begin
\addr_reg[0]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \addr__0\(0),
      G => \addr_reg[2]_i_2_n_0\,
      GE => '1',
      Q => addr(0)
    );
\addr_reg[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => addr_oneshot(7),
      I1 => addr_oneshot(5),
      I2 => addr_oneshot(1),
      I3 => addr_oneshot(3),
      O => \addr__0\(0)
    );
\addr_reg[1]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \addr__0\(1),
      G => \addr_reg[2]_i_2_n_0\,
      GE => '1',
      Q => addr(1)
    );
\addr_reg[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => addr_oneshot(7),
      I1 => addr_oneshot(6),
      I2 => addr_oneshot(2),
      I3 => addr_oneshot(3),
      O => \addr__0\(1)
    );
\addr_reg[2]\: unisim.vcomponents.LDCE
    generic map(
      INIT => '0'
    )
        port map (
      CLR => '0',
      D => \addr__0\(2),
      G => \addr_reg[2]_i_2_n_0\,
      GE => '1',
      Q => addr(2)
    );
\addr_reg[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => addr_oneshot(7),
      I1 => addr_oneshot(6),
      I2 => addr_oneshot(4),
      I3 => addr_oneshot(5),
      O => \addr__0\(2)
    );
\addr_reg[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"000A0AAC"
    )
        port map (
      I0 => \addr_reg[2]_i_3_n_0\,
      I1 => \addr_reg[2]_i_4_n_0\,
      I2 => addr_oneshot(2),
      I3 => addr_oneshot(0),
      I4 => addr_oneshot(1),
      O => \addr_reg[2]_i_2_n_0\
    );
\addr_reg[2]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => addr_oneshot(4),
      I1 => addr_oneshot(5),
      I2 => addr_oneshot(7),
      I3 => addr_oneshot(6),
      I4 => addr_oneshot(3),
      O => \addr_reg[2]_i_3_n_0\
    );
\addr_reg[2]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00010116"
    )
        port map (
      I0 => addr_oneshot(3),
      I1 => addr_oneshot(4),
      I2 => addr_oneshot(5),
      I3 => addr_oneshot(6),
      I4 => addr_oneshot(7),
      O => \addr_reg[2]_i_4_n_0\
    );
\dout[4]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => addr(0),
      O => rom(0)
    );
\dout[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => addr(0),
      I1 => addr(1),
      O => rom(5)
    );
\dout[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6C"
    )
        port map (
      I0 => addr(1),
      I1 => addr(2),
      I2 => addr(0),
      O => rom(6)
    );
\dout[7]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => enable,
      O => p_0_in
    );
\dout[7]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => addr(1),
      I1 => addr(2),
      I2 => addr(0),
      O => rom(7)
    );
\dout_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => rom(0),
      Q => dout(0),
      R => p_0_in
    );
\dout_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => rom(5),
      Q => dout(1),
      R => p_0_in
    );
\dout_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => rom(6),
      Q => dout(2),
      R => p_0_in
    );
\dout_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => clk,
      CE => '1',
      D => rom(7),
      Q => dout(3),
      R => p_0_in
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity minlab0_rom_ctrl_0_1 is
  port (
    clk : in STD_LOGIC;
    enable : in STD_LOGIC;
    addr_oneshot : in STD_LOGIC_VECTOR ( 7 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of minlab0_rom_ctrl_0_1 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of minlab0_rom_ctrl_0_1 : entity is "minlab0_rom_ctrl_0_1,rom_ctrl,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of minlab0_rom_ctrl_0_1 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of minlab0_rom_ctrl_0_1 : entity is "package_project";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of minlab0_rom_ctrl_0_1 : entity is "rom_ctrl,Vivado 2025.2";
end minlab0_rom_ctrl_0_1;

architecture STRUCTURE of minlab0_rom_ctrl_0_1 is
  signal \^dout\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk : signal is "xilinx.com:signal:clock:1.0 clk CLK";
  attribute X_INTERFACE_MODE : string;
  attribute X_INTERFACE_MODE of clk : signal is "slave";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk : signal is "XIL_INTERFACENAME clk, FREQ_HZ 96968727, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN minlab0_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0";
begin
  dout(7 downto 4) <= \^dout\(3 downto 0);
  dout(3 downto 0) <= \^dout\(3 downto 0);
inst: entity work.minlab0_rom_ctrl_0_1_rom_ctrl
     port map (
      addr_oneshot(7 downto 0) => addr_oneshot(7 downto 0),
      clk => clk,
      dout(3 downto 0) => \^dout\(3 downto 0),
      enable => enable
    );
end STRUCTURE;
