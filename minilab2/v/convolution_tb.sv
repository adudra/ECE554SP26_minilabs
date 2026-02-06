module convolution_tb();
    
    reg clk;
    reg rst_n;
    reg [11:0] data;
    reg valid;
    wire [11:0] out;

    localparam ROW_LENGTH = 4;
    localparam ROWS = 4;
    localparam COLS = ROW_LENGTH;
    
    logic signed [11:0] img [0:ROWS-1][0:COLS-1];
    logic [11:0] golden_reference [0:ROWS-1][0:COLS-1];

    integer r, c;
    reg [11:0] expected_prev;
    reg expected_prev_valid;
    integer expected_prev_r;
    integer expected_prev_c;

    task automatic construct_golden;
        integer i, j, r0, c0;
        logic signed [13:0] conv;
        logic signed [13:0] conv_abs;
        logic signed [11:0] filter [0:2][0:2];
        begin
            filter[0][0] = -12'sd1; filter[0][1] = -12'sd2; filter[0][2] = -12'sd1;
            filter[1][0] =  12'sd0; filter[1][1] =  12'sd0; filter[1][2] =  12'sd0;
            filter[2][0] =  12'sd1; filter[2][1] =  12'sd2; filter[2][2] =  12'sd1;

            for (i = 0; i < ROWS; i = i + 1) begin
                for (j = 0; j < COLS; j = j + 1) begin
                    if (i < 2 || j < 2) begin
                        golden_reference[i][j] = 12'd0;
                    end else begin
                        conv = '0;
                        for (r0 = 0; r0 < 3; r0 = r0 + 1) begin
                            for (c0 = 0; c0 < 3; c0 = c0 + 1) begin
                                conv = conv + $signed(img[i-2+r0][j-2+c0]) * $signed(filter[r0][c0]);
                            end
                        end
                        conv_abs = (conv < 0) ? -conv : conv;
                        golden_reference[i][j] = conv_abs[11:0];
                    end
                end
            end
        end
    endtask
    
    convolution #(.ROW_LENGTH(ROW_LENGTH)) dut(
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
        expected_prev_r = 0;
        expected_prev_c = 0;

        for (r = 0; r < ROWS; r = r + 1) begin
            for (c = 0; c < COLS; c = c + 1) begin
                @(posedge clk);
                valid <= 1'b1;
                data <= img[r][c];

                if (expected_prev_valid) begin
                    if (out !== expected_prev) begin
                        $error("Mismatch r=%0d c=%0d exp=%0d got=%0d",
                               expected_prev_r, expected_prev_c, expected_prev, out);
                    end
                end

                if (r >= 2 && c >= 2) begin
                    expected_prev = golden_reference[r][c];
                    expected_prev_valid = 1'b1;
                    expected_prev_r = r;
                    expected_prev_c = c;
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
                       expected_prev_r, expected_prev_c, expected_prev, out);
            end
        end
        valid <= 1'b0;

        $stop;

    end

    always #5 clk = ~clk;
endmodule