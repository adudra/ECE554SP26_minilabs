// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
// Date        : Thu Jan 22 17:46:15 2026
// Host        : Avery running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/Users/avery/ece554/minilabs/minilab0/minlab0.gen/sources_1/bd/minlab0/ip/minlab0_rom_ctrl_0_1/minlab0_rom_ctrl_0_1_sim_netlist.v
// Design      : minlab0_rom_ctrl_0_1
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu3eg-sfvc784-2-e
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "minlab0_rom_ctrl_0_1,rom_ctrl,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "package_project" *) 
(* X_CORE_INFO = "rom_ctrl,Vivado 2025.2" *) 
(* NotValidForBitStream *)
module minlab0_rom_ctrl_0_1
   (clk,
    enable,
    addr_oneshot,
    dout);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *) (* X_INTERFACE_MODE = "slave" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 96968727, FREQ_TOLERANCE_HZ 0, PHASE 0.0, CLK_DOMAIN minlab0_zynq_ultra_ps_e_0_0_pl_clk0, INSERT_VIP 0" *) input clk;
  input enable;
  input [7:0]addr_oneshot;
  output [7:0]dout;

  wire [7:0]addr_oneshot;
  wire clk;
  wire [3:0]\^dout ;
  wire enable;

  assign dout[7:4] = \^dout [3:0];
  assign dout[3:0] = \^dout [3:0];
  minlab0_rom_ctrl_0_1_rom_ctrl inst
       (.addr_oneshot(addr_oneshot),
        .clk(clk),
        .dout(\^dout ),
        .enable(enable));
endmodule

(* ORIG_REF_NAME = "rom_ctrl" *) 
module minlab0_rom_ctrl_0_1_rom_ctrl
   (dout,
    addr_oneshot,
    clk,
    enable);
  output [3:0]dout;
  input [7:0]addr_oneshot;
  input clk;
  input enable;

  wire [2:0]addr;
  wire [2:0]addr__0;
  wire [7:0]addr_oneshot;
  wire \addr_reg[2]_i_2_n_0 ;
  wire \addr_reg[2]_i_3_n_0 ;
  wire \addr_reg[2]_i_4_n_0 ;
  wire clk;
  wire [3:0]dout;
  wire enable;
  wire p_0_in;
  wire [7:0]rom;

  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \addr_reg[0] 
       (.CLR(1'b0),
        .D(addr__0[0]),
        .G(\addr_reg[2]_i_2_n_0 ),
        .GE(1'b1),
        .Q(addr[0]));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \addr_reg[0]_i_1 
       (.I0(addr_oneshot[7]),
        .I1(addr_oneshot[5]),
        .I2(addr_oneshot[1]),
        .I3(addr_oneshot[3]),
        .O(addr__0[0]));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \addr_reg[1] 
       (.CLR(1'b0),
        .D(addr__0[1]),
        .G(\addr_reg[2]_i_2_n_0 ),
        .GE(1'b1),
        .Q(addr[1]));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \addr_reg[1]_i_1 
       (.I0(addr_oneshot[7]),
        .I1(addr_oneshot[6]),
        .I2(addr_oneshot[2]),
        .I3(addr_oneshot[3]),
        .O(addr__0[1]));
  (* XILINX_LEGACY_PRIM = "LD" *) 
  (* XILINX_TRANSFORM_PINMAP = "VCC:GE GND:CLR" *) 
  LDCE #(
    .INIT(1'b0)) 
    \addr_reg[2] 
       (.CLR(1'b0),
        .D(addr__0[2]),
        .G(\addr_reg[2]_i_2_n_0 ),
        .GE(1'b1),
        .Q(addr[2]));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \addr_reg[2]_i_1 
       (.I0(addr_oneshot[7]),
        .I1(addr_oneshot[6]),
        .I2(addr_oneshot[4]),
        .I3(addr_oneshot[5]),
        .O(addr__0[2]));
  LUT5 #(
    .INIT(32'h000A0AAC)) 
    \addr_reg[2]_i_2 
       (.I0(\addr_reg[2]_i_3_n_0 ),
        .I1(\addr_reg[2]_i_4_n_0 ),
        .I2(addr_oneshot[2]),
        .I3(addr_oneshot[0]),
        .I4(addr_oneshot[1]),
        .O(\addr_reg[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \addr_reg[2]_i_3 
       (.I0(addr_oneshot[4]),
        .I1(addr_oneshot[5]),
        .I2(addr_oneshot[7]),
        .I3(addr_oneshot[6]),
        .I4(addr_oneshot[3]),
        .O(\addr_reg[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h00010116)) 
    \addr_reg[2]_i_4 
       (.I0(addr_oneshot[3]),
        .I1(addr_oneshot[4]),
        .I2(addr_oneshot[5]),
        .I3(addr_oneshot[6]),
        .I4(addr_oneshot[7]),
        .O(\addr_reg[2]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT1 #(
    .INIT(2'h1)) 
    \dout[4]_i_1 
       (.I0(addr[0]),
        .O(rom[0]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \dout[5]_i_1 
       (.I0(addr[0]),
        .I1(addr[1]),
        .O(rom[5]));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h6C)) 
    \dout[6]_i_1 
       (.I0(addr[1]),
        .I1(addr[2]),
        .I2(addr[0]),
        .O(rom[6]));
  LUT1 #(
    .INIT(2'h1)) 
    \dout[7]_i_1 
       (.I0(enable),
        .O(p_0_in));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \dout[7]_i_2 
       (.I0(addr[1]),
        .I1(addr[2]),
        .I2(addr[0]),
        .O(rom[7]));
  FDRE \dout_reg[4] 
       (.C(clk),
        .CE(1'b1),
        .D(rom[0]),
        .Q(dout[0]),
        .R(p_0_in));
  FDRE \dout_reg[5] 
       (.C(clk),
        .CE(1'b1),
        .D(rom[5]),
        .Q(dout[1]),
        .R(p_0_in));
  FDRE \dout_reg[6] 
       (.C(clk),
        .CE(1'b1),
        .D(rom[6]),
        .Q(dout[2]),
        .R(p_0_in));
  FDRE \dout_reg[7] 
       (.C(clk),
        .CE(1'b1),
        .D(rom[7]),
        .Q(dout[3]),
        .R(p_0_in));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
