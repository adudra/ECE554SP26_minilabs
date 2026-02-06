module convolution #(
    parameter int ROW_LENGTH = 1280
) (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [11:0] i_data,
    input  logic        i_valid,
    output logic [11:0] o_data
);
    logic [11:0] row1_delay, row2_delay, col2_delay;
    logic        shift_en;
    always_comb shift_en = i_valid;

    shift_register #(.WIDTH(12), .DEPTH(ROW_LENGTH)) sr1 (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_wdata(i_data),
        .i_shift(shift_en),
        .o_rdata(row1_delay)
    );

    shift_register #(.WIDTH(12), .DEPTH(ROW_LENGTH)) sr2 (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_wdata(row1_delay),
        .i_shift(shift_en),
        .o_rdata(row2_delay)
    );

    logic signed [11:0] data [0:2][0:2];
    wire  signed [11:0] filter [0:2][0:2] = '{
        // vertical edge sobel
        // '{-12'd1, 12'd0, 12'd1},
        // '{-12'd2, 12'd0, 12'd2},
        // '{-12'd1, 12'd0, 12'd1}

        // horizontal edge sobel
        '{-12'd1, -12'd2, -12'd1},
        '{12'd0, 12'd0, 12'd0},
        '{12'd1, 12'd2, 12'd1}
    };

    always_comb begin
        data[0][2] = row2_delay;
        data[1][2] = row1_delay;
        data[2][2] = i_data;
    end

    always_ff @(posedge i_clk) begin
        data[0][0] <= data[0][1];
        data[0][1] <= data[0][2];
        data[1][0] <= data[1][1];
        data[1][1] <= data[1][2];
        data[2][0] <= data[2][1];
        data[2][1] <= data[2][2];
    end

    // genvar i, j;
    // generate
    int i, j;
    logic signed [13:0] conv;
    always_comb begin
        conv = '0;

        for (i = 0; i < 3; i = i + 1) begin : conv_row
            for (j = 0; j < 3; j = j + 1) begin : conv_col
                conv = conv + $signed(data[i][j]) * $signed(filter[i][j]);
            end
        end

        conv = ($signed(conv) < 0) ? -conv : conv;
    end
    // endgenerate

    assign o_data = conv;
endmodule