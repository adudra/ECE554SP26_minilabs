//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module spart(
    input clk,
    input rst,
    input iocs, // 1 = chip select
    input iorw, // 1 = read, 0 = write
    output rda, // receive data available
    output tbr, // transmit buffer ready
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
);

wire tx_en, tx_busy;
wire rx_en, rx_ready;
wire [7:0] tx_data, rx_data;
wire [15:0] baud_divisor;

wire [7:0] status_register = {6'b0, tbr, rda};

assign tbr = ~tx_busy;
assign rda = rx_ready;

assign databus = (iorw  && (ioaddr == 2'b00)) ? rx_data : 
                 (iorw && (ioaddr == 2'b00)) ? tx_data :
                 (ioaddr == 2'b01) ? status_register :
                 (ioaddr == 2'b10) ? baud_divisor[7:0] :
                 (ioaddr == 2'b11) ? baud_divisor[15:8] :
                 8'bz;

baud_rate_generator brg(
    .clk        (clk),
    .rst        (rst),
    .tx_en      (tx_en),
    .rx_en      (rx_en),
    .baud_divisor (baud_divisor)
);

transmitter tx(
    .clk        (clk),
    .rst        (rst),
    .tx_en      (tx_en),
    .tx_data    (tx_data),
    .txd        (txd),
    .tx_busy    (tx_busy)
);

receiver rx(
    .clk        (clk),
    .rst        (rst),
    .rx_en      (rx_en),
    .rx_data    (rx_data),
    .rxd        (rxd),
    .rx_ready   (rx_ready)
);

endmodule
