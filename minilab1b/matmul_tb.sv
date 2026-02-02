module matmul_tb ();
    logic clk, rst_n;
    logic [23:0] sum;

    wire [23:0] c_vector [7:0];
    matmul matmul (.clk(clk), .rst_n(rst_n), .c_vector(c_vector), .sum(sum));

    integer j;
    initial begin
        clk = 0;
        rst_n = 0;
        repeat (2) @(negedge clk) rst_n = 1;



        @(matmul.state == 3'd4);
        @(posedge clk);
        @(posedge clk);

        for (j = 0; j < 8; j = j + 1)
            $display("%d", c_vector[j]);

        $display("%d", sum);
        $stop(); 

    end

    always
        #5 clk = ~clk;
endmodule