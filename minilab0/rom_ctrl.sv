`timescale 1ns/1ps
`default_nettype wire

module rom_ctrl (
    input logic clk,
    input logic enable,
    input logic [7:0] addr_oneshot,
    output logic [7:0] dout
);

// 8 addresses of 8 bit memory
logic [7:0] rom [0:7];

// effective address
logic [2:0] addr;

// NOTE: THIS IS NON-SYNTHESIZABLE CONSTRUCT

assign rom[0] = 8'h11;
assign rom[1] = 8'h22;
assign rom[2] = 8'h33;
assign rom[3] = 8'h44;
assign rom[4] = 8'h55;
assign rom[5] = 8'h66;
assign rom[6] = 8'h77;
assign rom[7] = 8'h88;

always @(*) begin 
    case (addr_oneshot)
        8'h01: addr = 3'd0;
        8'h02: addr = 3'd1;
        8'h04: addr = 3'd2;
        8'h08: addr = 3'd3;
        8'h10: addr = 3'd4;
        8'h20: addr = 3'd5;
        8'h40: addr = 3'd6;
        8'h80: addr = 3'd7;
    endcase
end

always @(posedge clk) begin
    if (enable)  
        dout <= rom[addr];
    else 
        dout <= 8'h00;
end

endmodule