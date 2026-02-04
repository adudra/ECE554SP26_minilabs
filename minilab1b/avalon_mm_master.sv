module avalon_mm_master 
#(
    parameter DEPTH = 8,
    parameter DATA_WIDTH = 8
)
(
    input clk,
    input rst_n,

    // Avalon Slave I/O
    input reg [63:0] readdata,  // 64-bit read data (1-row)
    input readdatavalid,    // data valid signal 
    input waitrequest,      // busy signal to indicate logic is processing
    output reg [31:0] address,  // 32-bit address for 8 rows
    output reg read,            // read request

    // Matrix Mult I/O
    output reg mult_valid,
    output reg [DATA_WIDTH-1:0] a_matrix [0:DEPTH-1][0:DEPTH-1],
    output reg [DATA_WIDTH-1:0] b_vector [0:DEPTH-1]

);

    // Module Signals
    logic cap; // capture control signal for a_matrix, b_vector, and cnt

    // Counter for address 
    // I think this is less HW than incrementing address itself
    reg [3:0] cnt;
    always @(posedge clk, negedge rst_n) begin 
        if (!rst_n)
            cnt <= 4'h0;
        else if (cap)
            cnt <= cnt + 1;
    end

    // Vector Capture
    integer i;
    always @(posedge clk, negedge rst_n) begin 
        if (!rst_n)
            for (i = 0; i < DEPTH; i = i + 1) begin 
                b_vector[i] <= '0; 
            end
        else if (cap & cnt[3])
            for (i = 0; i < DEPTH; i = i + 1) begin 
                b_vector[i] <= readdata[DATA_WIDTH *i +: DATA_WIDTH];
            end
    end

    // Matrix Capture 
    integer k;
    always @(posedge clk, negedge rst_n) begin 
        if (!rst_n)
            for (i = 0; i < DEPTH; i = i + 1) begin 
                for (k = 0; k < DEPTH; k = k + 1) begin 
                    a_matrix[i][k] <= '0;
                end
            end
        else if (cap & ~cnt[3])
            for (k = 0; k < DEPTH; k = k + 1) begin 
                a_matrix[cnt][k] <= readdata[DATA_WIDTH *k +: DATA_WIDTH];

            end
    end

    // State Machine
    typedef enum logic [1:0] { IDLE, REQ, STALL, DONE } state_t;
    //typedef enum logic [1:0] { IDLE, REQ, DONE } state_t;
    state_t state, next_state;

    always @(posedge clk, negedge rst_n) begin 
        if (!rst_n)
            state <= IDLE;
        else 
            state <= next_state;
    end 

    always_comb begin 
        // default signals
        next_state = state;
        read = 1'b0;
        cap = 1'b0;
        address = 32'd0;
        mult_valid = 1'b0;
    
        // state outputs and transitions
        case(state)    
            IDLE: begin 
                //TODO: do we need some sort of logic/wait period to
                next_state = REQ;
            end 
            REQ: begin 
                read = 1'b1;
                address = {{28{1'b0}},cnt};
                if (readdatavalid) begin
                    read = 1'b0;
                    cap = 1'b1;
                    next_state = STALL;
                end
                // if (cnt == 4'd8)
                //     next_state = DONE; 
            end
            STALL: begin 
                address = {{28{1'b0}},cnt};
                if (cnt == 4'd9)
                    next_state = DONE; 
                else 
                    next_state = REQ;
            end
            DONE: begin 
                mult_valid = 1'b1;
            end
            default: begin end
        endcase
    end

endmodule