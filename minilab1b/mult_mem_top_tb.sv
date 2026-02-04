module mult_mem_top_tb ();

// SIGNALS 
logic  clk;
logic  rst_n;
logic [23:0] sum;
wire [23:0] c_vector [7:0];

// DUT INSTANTIATION
mult_mem_top iTOP(
    .clk(clk),
    .rst_n(rst_n),
    .c_vector(c_vector),
    .sum(sum)
);

integer j;
initial begin
    clk = 0;
    rst_n = 0;
    repeat (2) @(negedge clk) rst_n = 1;



    @(iTOP.iMATMUL.state == 3'd3);
    @(posedge clk);
    @(posedge clk);

    $display("PRINTING C VECTOR:");
    for (j = 0; j < 8; j = j + 1)
        $display("%h", c_vector[j]);

    $display("PRINTING SUM REDUCTION:");
    $display("%h", sum);
    $stop();
end

always
    #5 clk = ~clk; 

endmodule