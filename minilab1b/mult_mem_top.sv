module mult_mem_top 
#(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)
(
    input clk,
    input rst_n,
    output wire [23:0] c_vector [0:DEPTH-1],
    output [23:0] sum,
    output done
);

wire [DATA_WIDTH-1:0] a_matrix [0:DEPTH-1] [0:DEPTH-1];
wire [DATA_WIDTH-1:0] b_vector [0:DEPTH-1];
wire mult_valid;

avalon_master_slave iMM(
    .clk(clk),
    .rst_n(rst_n),
    .a_matrix(a_matrix),
    .b_vector(b_vector),
    .mult_valid(mult_valid)
);

matmul iMATMUL(
    .clk(clk),
    .rst_n(rst_n),
    .mult_valid(mult_valid),
    .a_matrix(a_matrix),
    .b_vector(b_vector),
    .c_vector(c_vector),
    .sum(sum),
    .done(done)
);

endmodule