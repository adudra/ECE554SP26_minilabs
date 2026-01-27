//Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
//Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
//Date        : Thu Jan 22 17:45:23 2026
//Host        : Avery running 64-bit major release  (build 9200)
//Command     : generate_target minlab0_wrapper.bd
//Design      : minlab0_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module minlab0_wrapper
   (addr_oneshot_0,
    dout_0,
    enable_0);
  input [7:0]addr_oneshot_0;
  output [7:0]dout_0;
  input enable_0;

  wire [7:0]addr_oneshot_0;
  wire [7:0]dout_0;
  wire enable_0;

  minlab0 minlab0_i
       (.addr_oneshot_0(addr_oneshot_0),
        .dout_0(dout_0),
        .enable_0(enable_0));
endmodule
