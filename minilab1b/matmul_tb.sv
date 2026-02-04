module matmul_tb ();
    logic clk, rst_n;
    logic [23:0] sum;

    logic [7:0] a_matrix [0:7] [0:7];
    logic [7:0] b_vector [0:7];
    logic [23:0] c_vector [7:0];
    logic mult_valid;
    matmul matmul (.clk(clk), .rst_n(rst_n), .a_matrix(a_matrix), .b_vector(b_vector), .c_vector(c_vector), .sum(sum), .mult_valid(mult_valid));

    integer j;
    initial begin
        clk = 0;
        rst_n = 0;
        a_matrix = '{
            '{8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07, 8'h08},
            '{8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17, 8'h18},
            '{8'h21, 8'h22, 8'h23, 8'h24, 8'h25, 8'h26, 8'h27, 8'h28},
            '{8'h31, 8'h32, 8'h33, 8'h34, 8'h35, 8'h36, 8'h37, 8'h38},
            '{8'h41, 8'h42, 8'h43, 8'h44, 8'h45, 8'h46, 8'h47, 8'h48},
            '{8'h51, 8'h52, 8'h53, 8'h54, 8'h55, 8'h56, 8'h57, 8'h58},
            '{8'h61, 8'h62, 8'h63, 8'h64, 8'h65, 8'h66, 8'h67, 8'h68},
            '{8'h71, 8'h72, 8'h73, 8'h74, 8'h75, 8'h76, 8'h77, 8'h78}
        };
        b_vector = '{
            8'h81, 8'h82, 8'h83, 8'h84,
            8'h85, 8'h86, 8'h87, 8'h88
        };
        repeat (2) @(negedge clk) rst_n = 1;

        @(negedge clk) mult_valid = 1'b1;
        

        @(matmul.state == 3'd3);
        @(posedge clk);
        @(posedge clk);

        for (j = 0; j < 8; j = j + 1)
            $display("%h", c_vector[j]);

        $display("%h", sum);
        $stop(); 

    end

    always
        #5 clk = ~clk;
endmodule