`default_nettype none

module shift_register #(
    parameter int WIDTH = 1,
    parameter int DEPTH = 1
) (
    input  logic               i_clk,
    input  logic               i_rst_n,
    input  logic [WIDTH - 1:0] i_wdata,
    input  logic               i_shift,
    output logic [WIDTH - 1:0] o_rdata
);
    logic [DEPTH - 1:0][WIDTH - 1:0] mem;

    // Index 0 is populated with the incoming data.
    always @(posedge i_clk, negedge i_rst_n) begin
        if (!i_rst_n)
            mem[0] <= '0;
        else if (i_shift)
            mem[0] <= i_wdata;

    end

    // Shift operation mem[i] <= mem[i - 1].
    genvar i;
    generate
    for (i = 1; i < DEPTH; i = i + 1) begin : shift
        always @(posedge i_clk, negedge i_rst_n) begin
            if (!i_rst_n)
                mem[i] <= '0;
            else if (i_shift)
                mem[i] <= mem[i - 1];
        end
    end
    endgenerate

    assign o_rdata = mem[DEPTH - 1];
endmodule

`default_nettype wire
