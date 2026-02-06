module interpolate_tb();
    
    reg clk;
    reg rst_n;
    reg [11:0] data;
    reg valid;
    wire [11:0] out;

    localparam ROW_LENGTH = 4;
    localparam ROWS = 4;
    localparam COLS = ROW_LENGTH;
    
    reg [11:0] img [0:ROWS-1][0:COLS-1];
    reg [11:0] golden_reference [0:ROWS-1][0:COLS-1];

    integer r, c;
    reg [11:0] expected_prev;
    reg expected_prev_valid;

    task automatic construct_golden;
        integer i, j;
        logic [13:0] sum;
        begin
            for (i = 0; i < ROWS; i = i + 1) begin
                for (j = 0; j < COLS; j = j + 1) begin
                    if (i == 0 || j == 0) begin
                        golden_reference[i][j] = 12'd0;
                    end else begin
                        sum = img[i][j] + img[i-1][j] + img[i][j-1] + img[i-1][j-1];
                        golden_reference[i][j] = sum[13:2];
                    end
                end
            end
        end
    endtask
    
    interpolate #(.ROW_LENGTH(ROW_LENGTH)) dut(
        .i_clk(clk),
        .i_rst_n(rst_n),
        .i_data(data),
        .i_valid(valid),
        .o_data(out)
    );

    initial begin
        clk = 0;
        rst_n = 0;
        data = 0;
        valid = 0;

        for (r = 0; r < ROWS; r = r + 1) begin
            for (c = 0; c < COLS; c = c + 1) begin
                img[r][c] = r * COLS + c;
            end
        end

        construct_golden();

        repeat (2) @(posedge clk);
        rst_n = 1;
        repeat (2) @(posedge clk);

        expected_prev = 12'd0;
        expected_prev_valid = 1'b0;

        for (r = 0; r < ROWS; r = r + 1) begin
            for (c = 0; c < COLS; c = c + 1) begin
                @(posedge clk);
                valid <= 1'b1;
                data <= img[r][c];

                if (expected_prev_valid) begin
                    if (out !== expected_prev) begin
                        $error("Mismatch r=%0d c=%0d exp=%0d got=%0d",
                               r, c, expected_prev, out);
                    end
                end

                if (r >= 1 && c >= 1) begin
                    expected_prev = golden_reference[r][c];
                    expected_prev_valid = 1'b1;
                end else begin
                    expected_prev = 12'd0;
                    expected_prev_valid = 1'b0;
                end
            end
        end

        @(posedge clk);
        if (expected_prev_valid) begin
            if (out !== expected_prev) begin
                $error("Mismatch r=%0d c=%0d exp=%0d got=%0d",
                       r, c, expected_prev, out);
            end
        end
        valid <= 1'b0;

        $stop;

    end

    always #5 clk = ~clk;
endmodule