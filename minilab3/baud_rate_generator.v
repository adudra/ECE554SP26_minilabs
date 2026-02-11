module baud_rate_generator(
    input clk,
    input rst,
    input [7:0] db_high,
    input [7:0] db_low,
    output reg tx_en,   // when we shift data onto the tx line
    output reg rx_baud   // when we sample data from the rx line
);

// Divisor Buffer //
reg [15:0] db_eff;
always @(posedge clk) begin 
    if (rst)
        //reset to freq 50Mhz and 9600 baud (50Mhz / (2^4 * 9600)) - 1
        db_eff <= 16'h0144;
    else 
        db_eff <= {db_high, db_low};

end

// Control signals //
reg load_div;
reg load_en_cnt;
reg [4:0] en_cnt;
reg [15:0] cnt_div;

assign load_en_cnt = ~(|en_cnt);
assign load_div = ~(|cnt_div);

// Down counter for Divisor and enable count  //
always @(posedge clk) begin 
    if (rst)
        //reset to freq 50Mhz and 9600 baud (50Mhz / (2^4 * 9600)) - 1
        cnt_div <= 16'h0144;
    else if (load_div)
        cnt_div <= db_eff;
    else 
        cnt_div <= cnt_div - 1;
end

always @(posedge clk) begin 
    if (rst)
        //reset to freq 50Mhz and 9600 baud (50Mhz / (2^4 * 9600)) - 1
        en_cnt <= 5'h10;
    else if (load_en_cnt)
        en_cnt <= 5'h10; // TODO: see if this should be F or 10 in hex 
    else if (rx_baud)
        en_cnt <= en_cnt - 1;
end


// Enable flop //
always @(posedge clk) begin 
    if (rst)  
        rx_baud <= 1'b0;
    else if (load_div)  
        rx_baud <= 1'b1;
    else 
        rx_baud <= 1'b0; // This enable is toggled 16 times per baud
end 

// TX and RX Sample enable //
always @(posedge clk) begin 
    if (rst) 
        tx_en <= 1'b0;
    else if (load_en_cnt)  
        tx_en <= 1'b1;
    else 
        tx_en <= 1'b0;
end


endmodule