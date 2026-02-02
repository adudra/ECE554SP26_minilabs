module matmul
#(
  parameter DEPTH=8,
  parameter DATA_WIDTH=8
)
(
    input rst_n,
    input clk,
    input reg [DATA_WIDTH-1:0] a_matrix [0:DEPTH-1] [0:DEPTH-1],
    input reg [DATA_WIDTH-1:0] b_vector [0:DEPTH-1],
    output wire [23:0] c_vector [0:DEPTH-1],
    output logic [23:0] sum 
);

logic run; //signal asserted during matmul computation
logic clear; //signal to clear mac and counter to initialize fifos

// MATRIX FIFOS INSTANTIATION //
wire [DATA_WIDTH-1:0] ia_odata [DEPTH-1:0];
logic [DATA_WIDTH-1:0] ia_rden, ia_wren;
wire [DATA_WIDTH-1:0] ia_full, ia_empty;
logic [DATA_WIDTH-1:0] ia_idata [DEPTH-1:0];
FIFO ia_vectors [DEPTH-1:0] (
    .clk(clk),
    .rst_n(rst_n),
    .rden(run),
    .wren(ia_wren),
    .i_data(ia_idata),
    .o_data(ia_odata),
    .full(ia_full),
    .empty(ia_empty)
);

integer x;
reg [3:0] count;
always_comb begin 
    for (x = 0; x < DEPTH-1; x = x + 1)
        ia_idata[x] = a_matrix[x][count];
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        count <= 5'd0;
    else if (clear)
        count <= 5'b0;
    else 
        count <= count + 1;
end

// VECTOR FIFO INSTANTIATION //
wire [DATA_WIDTH-1:0] ib_odata;
logic ib_rden, ib_wren;
wire ib_full, ib_empty;

FIFO ib_vector(
    .clk(clk),
    .rst_n(rst_n),
    .rden(run),
    .wren(ib_wren),
    .i_data(b_vector[count]),
    .o_data(ib_odata),
    .full(ib_full),
    .empty(ib_empty)
);


// MAC INSTANTIATION //
genvar i;
generate
    for (i = 0; i < DATA_WIDTH-1; ++i) begin 
        MAC imac(
            .clk(clk),
            .rst_n(rst_n),
            .En(run),
            .Clr(clear),
            .Ain(ia_odata[i]),
            .Bin(ib_odata),
            .Cout(c_vector[i])
        );
    end
endgenerate


// STATE MACHINE //
typedef enum logic [2:0] {CLEAR, INIT, BUSY, IDLE} state_t;
state_t state, next_state;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n)
        state <= CLEAR;
    else
        state <= next_state;
end

always_comb begin
    clear = 1'b0;
    run = 1'b0;
    ia_wren = 8'h00;
    ib_wren = 1'b0;
    next_state = state;

    case (state)
    CLEAR: begin
        clear = 1'b1;
        next_state = INIT;
    end
    INIT: begin
        ia_wren = 8'hff;
        ib_wren = 1'b1;
        if ((ia_full == 8'hff) & ib_full)
            //next_state = INITB;
            next_state = BUSY;
    end
    BUSY: begin
        run = 1'b1;
        if (ia_empty[7])
            next_state = IDLE;
    end
    IDLE: begin end
    default: begin end
    endcase
end

// SUM REDUCTION OUTPUT //
//TODO: see if this should be outputed or not
integer k;
always_comb begin
    sum = 0;
    for (k = 0; k < DATA_WIDTH-1; k = k + 1)
        sum = sum + c_vector[k];
end

endmodule