//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Thu Jan 22 17:45:23 2026
//Host        : Avery running 64-bit major release  (build 9200)
//Command     : generate_target minlab0.bd
//Design      : minlab0
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "minlab0,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=minlab0,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=2,numReposBlks=2,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=0,numPkgbdBlks=0,bdsource=USER,synth_mode=Hierarchical}" *) (* HW_HANDOFF = "minlab0.hwdef" *) 
module minlab0
   (addr_oneshot_0,
    dout_0,
    enable_0);
  input [7:0]addr_oneshot_0;
  output [7:0]dout_0;
  input enable_0;

  wire [7:0]addr_oneshot_0;
  wire [7:0]dout_0;
  wire enable_0;
  wire zynq_ultra_ps_e_0_pl_clk0;

  minlab0_rom_ctrl_0_1 rom_ctrl_0
       (.addr_oneshot(addr_oneshot_0),
        .clk(zynq_ultra_ps_e_0_pl_clk0),
        .dout(dout_0),
        .enable(enable_0));
  minlab0_zynq_ultra_ps_e_0_0 zynq_ultra_ps_e_0
       (.pl_clk0(zynq_ultra_ps_e_0_pl_clk0));
endmodule
