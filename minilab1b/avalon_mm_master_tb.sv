module avalon_mm_master_tb ();

// SIGNALS
logic  clk;
logic  rst_n;

// Matrix Mult I/O
logic  mult_valid;
logic  [7:0] a_matrix [0:7][0:7];
logic  [7:0] b_vector [0:7];

// DUT INSTANTIATION
avalon_master_slave iTB(
    .clk(clk),
    .rst_n(rst_n),
    .a_matrix(a_matrix),
    .b_vector(b_vector),
    .mult_valid(mult_valid)
);


integer i, j;
initial begin
    // initial conditions 
    clk = 0;
    rst_n = 0;
    repeat (2) @(negedge clk) rst_n = 1;

    @(posedge mult_valid);
    $display("PRINTING A MATRIX");
    for (i = 0; i < 8; i +=1) begin 
        $display("%h  %h  %h  %h  %h  %h  %h  %h", a_matrix[i][0], a_matrix[i][1], a_matrix[i][2], a_matrix[i][3], a_matrix[i][4], a_matrix[i][5], a_matrix[i][6], a_matrix[i][7]);  // use %h for hex
    end 

    $display("PRINTING B VECTOR");
    for (i = 0; i < 8; i = i + 1) begin
            $display("%h", b_vector[i]);
    end

    $stop();

end

always 
    #5 clk = ~clk;

endmodule