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
wire rx_baud, rx_ready;
wire rx_reset_valid;
wire [7:0] tx_data, rx_data;
wire [15:0] baud_divisor;

wire [7:0] status_register = {6'b0, tbr, rda};

assign tbr = ~tx_busy;
assign rda = rx_ready;

assign rx_reset_valid = iocs && iorw && (ioaddr == 2'b00);

assign databus = (iorw  && (ioaddr == 2'b00)) ? rx_data : 
                 (iorw && (ioaddr == 2'b00)) ? tx_data :
                 (ioaddr == 2'b01) ? status_register :
                 (ioaddr == 2'b10) ? baud_divisor[7:0] :
                 (ioaddr == 2'b11) ? baud_divisor[15:8] :
                 8'bz;

baud_rate_generator brg(
    .clk        (clk),
    .rst        (rst),
    .db_high    (baud_divisor[15:8]),
    .db_low     (baud_divisor[7:0]),
    .tx_en      (tx_en),
    .rx_baud    (rx_baud)
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
    .clk            (clk),
    .rst            (rst),
    .i_rx_baud      (rx_baud),
    .i_rxd          (rxd),
    .i_reset_valid  (rx_reset_valid),
    .o_data         (rx_data),
    .o_valid        (rx_ready)
);

endmodule
