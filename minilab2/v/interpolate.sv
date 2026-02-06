module interpolate #(
    parameter int ROW_LENGTH = 1280
) (
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [11:0] i_data,
    input  logic        i_valid,
    output logic [11:0] o_data
);
    logic [11:0] row_delay;
    logic        shift_en;
    always_comb shift_en = i_valid;
    shift_register #(.WIDTH(12), .DEPTH(ROW_LENGTH)) sr (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_wdata(i_data),
        .i_shift(shift_en),
        .o_rdata(row_delay)
    );

    logic [11:0] data00, data01, data10, data11;

    always_comb begin
        data00 = i_data;
        data10 = row_delay;
    end

    always_ff @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n) begin
            data01 <= '0;
            data11 <= '0;
        end else begin
            data01 <= data00;
            data11 <= data10;
        end
    end

    // Arithmetic mean of the 4 element (2x2) sliding window.
    logic [13:0] sum;
    always_comb sum = data00 + data01 + data10 + data11;
    assign o_data = sum[13:2];

endmodule