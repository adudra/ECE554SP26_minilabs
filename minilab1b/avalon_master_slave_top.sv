module avalon_master_slave
#(
    parameter DEPTH = 8,
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input rst_n,

    output reg  [DATA_WIDTH-1:0] a_matrix [0:DEPTH-1][0:DEPTH-1],
    output reg  [DATA_WIDTH-1:0] b_vector [0:DEPTH-1],
    output mult_valid
);

// SIGNALS
logic  [63:0] readdata;  // 64-bit read data (1-row)
logic  readdatavalid;    // data valid signal 
logic  waitrequest;      // busy signal to indicate logic is processing
logic  [31:0] address;  // 32-bit address for 8 rows
logic  read;            // read request

avalon_mm_master top_master(
    .clk(clk),
    .rst_n(rst_n),
    .readdata(readdata),
    .readdatavalid(readdatavalid),
    .waitrequest(waitrequest),
    .address(address),
    .read(read),
    .mult_valid(mult_valid),
    .a_matrix(a_matrix),
    .b_vector(b_vector)
);

mem_wrapper top_slave(
    .clk(clk),
    .reset_n(rst_n),
    .address(address),
    .read(read),
    .readdata(readdata),
    .readdatavalid(readdatavalid),
    .waitrequest(waitrequest)
);

endmodule