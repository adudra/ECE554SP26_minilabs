module interpolate_tb();
    
    reg clk;
    reg rst_n;
    reg [11:0] data;
    reg valid;
    wire [11:0] out;

    // parameters
    localparam ROW_LENGTH = 4;
    localparam ROWS = 4;
    localparam COLS = ROW_LENGTH;
    
    // test data and golden reference storage
    reg [11:0] img [0:ROWS-1][0:COLS-1];
    reg [11:0] golden_reference [0:ROWS-1][0:COLS-1];

    // variables for tracking expected output
    integer r, c;
    reg [11:0] expected_prev;
    reg expected_prev_valid;

    // task to construct the golden reference output based on the interpolation operation
    task automatic construct_golden;
        integer i, j;
        logic [13:0] sum;
        begin
            for (i = 0; i < ROWS; i = i + 1) begin
                for (j = 0; j < COLS; j = j + 1) begin
                    if (i == 0 || j == 0) begin
                        golden_reference[i][j] = 12'd0; // zero padding for borders
                    end else begin
                        // Compute the average of the 2x2 neighborhood of the pixel
                        sum = img[i][j] + img[i-1][j] + img[i][j-1] + img[i-1][j-1];
                        golden_reference[i][j] = sum[13:2];
                    end
                end
            end
        end
    endtask
    
    // dut instantiation
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
                img[r][c] = r * COLS + c; // Initialize the input image with a simple pattern
            end
        end

        construct_golden();

        repeat (2) @(posedge clk);
        rst_n = 1; // reset sequence
        repeat (2) @(posedge clk);

        expected_prev = 12'd0;
        expected_prev_valid = 1'b0;

        for (r = 0; r < ROWS; r = r + 1) begin
            for (c = 0; c < COLS; c = c + 1) begin
                @(posedge clk);
                valid <= 1'b1;
                data <= img[r][c];

                if (expected_prev_valid) begin // Check the output against the expected value from the golden reference
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

        @(posedge clk); // last one
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