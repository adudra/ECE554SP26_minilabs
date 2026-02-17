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
    inout reg [7:0] databus,
    output txd,
    input rxd
);

// -----------------------------------------
// Signal Declaration
// -----------------------------------------

wire tx_en, tx_busy;
wire rx_baud, rx_ready;
wire rx_reset_valid;
reg [7:0] tx_data;
wire [7:0] rx_data;
reg [15:0] baud_divisor;
reg [7:0] rx_data_buffer;
wire start;
reg iorw_flopped;
reg [1:0] ioaddr_flopped;
reg iocs_flopped;



// -----------------------------------------
// Combinational Logic
// -----------------------------------------

assign tbr = ~tx_busy;
assign rda = rx_ready;
assign start = ~tx_busy & iocs_flopped & ~iorw_flopped & (ioaddr_flopped == 2'b00);
assign rx_reset_valid = iocs & iorw & (ioaddr == 2'b00) & rx_ready; 
assign databus = rx_ready ? rx_data : 8'hZZ; 


// -----------------------------------------
// Register Buffers
// -----------------------------------------

// Baud Divisor Upper
always @(posedge clk) begin 
    if (rst)
        baud_divisor <= 8'h01;
    else if (ioaddr == 2'b11)
        baud_divisor[15:8] <= databus;
end

// Baud Divisor Low
always @(posedge clk) begin 
    if (rst)
        baud_divisor[7:0] <= 8'h44;
    else if (ioaddr == 2'b10)
        baud_divisor[7:0] <= databus;
end

// Receive Buffer (from Driver to SPART)
always @(posedge clk) begin 
    if (rst)
        tx_data <= 8'h00;
    else if (!iorw && (ioaddr == 2'b00))
        tx_data <= databus;
end

// Status Register
always @(posedge clk) begin 
    if (rst) begin 
        iorw_flopped <= 1'b1; //reset to read 
        ioaddr_flopped <= 2'b00;
        iocs_flopped <= 1'b0;
    end else begin 
        iorw_flopped <= iorw;
        ioaddr_flopped <= ioaddr;
        iocs_flopped <= iocs;
    end
end



// -----------------------------------------
// Module Instantiations
// -----------------------------------------
baud_rate_generator brg(
    .clk        (clk),
    .rst        (rst),
    .db_high    (baud_divisor[15:8]),
    .db_low     (baud_divisor[7:0]),
    .tx_en      (tx_en),
    .rx_baud    (rx_baud)
);

transmitter tx(
    .clk            (clk),
    .rst            (rst),
    .i_tx_en        (tx_en),
    .i_start        (start),
    .i_data         (tx_data),
    .o_txd          (txd),
    .o_busy         (tx_busy)
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
