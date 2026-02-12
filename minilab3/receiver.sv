module receiver (
    input  wire       clk,
    input  wire       rst,
    input  wire       i_rx_baud,
    input  wire       i_rxd,
    input  wire       i_reset_valid,
    output reg [7:0] o_data,
    output reg       o_valid
);
    typedef enum logic {
        IDLE,
        RECV
    } state_t;

    state_t state, next_state;
    always_ff @(posedge clk) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Start transition from IDLE to RECV.
    wire start = (state == IDLE) && (next_state == RECV);

    // RX data available flag.
    //logic valid;
    logic set_valid;
    always_ff @(posedge clk) begin
        if (rst)
            o_valid <= 1'b0;
        else if (i_reset_valid)
            o_valid <= 1'b0;
        else if (set_valid)
            o_valid <= 1'b1;
    end

    // Shift enable latch, based on data available.
    logic shift_en;
    always_ff @(posedge clk) begin
        if (rst)
            shift_en <= 1'b0;
        else if (start)
            shift_en <= !o_valid;
    end

    // Triple flop the rxd signal to avoid metastability.
    logic [2:0] rxd_sync;
    wire        rxd = rxd_sync[2];
    always_ff @(posedge clk) begin
        rxd_sync <= {rxd_sync[1:0], i_rxd};
    end

    // Shift in the received bit (UART is little endian)
    // each time we want to sample.
    //logic [7:0] data;
    logic       rx_en;
    always_ff @(posedge clk) begin
        if (rx_en && shift_en)
            o_data <= {i_rxd, o_data[7:1]};
    end

    // Sample counter resets to align with the start bit,
    // then counts up to 16 to sample the data line.
    logic [3:0] sample_counter;
    always_comb rx_en = (state == RECV) && (sample_counter == 4'd7) && i_rx_baud;
    always_ff @(posedge clk) begin
        if (start)
            sample_counter <= 4'd0;
        else if (i_rx_baud)
            sample_counter <= sample_counter + 1;
    end

    // Bit counter counts up to 9 bits (start, 8 data). We don't count the
    // stop bit since its treated as a transition back to IDLE.
    logic [3:0] bit_counter;
    always_ff @(posedge clk) begin
        if (start)
            bit_counter <= 4'd0;
        else if (rx_en)
            bit_counter <= bit_counter + 1;
    end

    always_comb begin
        next_state = state;
        set_valid = 1'b0;

        case (state)
            IDLE: begin
                // RXD is pulled up. Low means a start bit is detected,
                // initiating the receiver.
                if (rxd == 1'b0)
                    next_state = RECV;
            end
            RECV: begin
                if (bit_counter == 4'd9) begin
                    next_state = IDLE;
                    set_valid = 1'b1;
                end
            end
            default: next_state = IDLE;
        endcase
    end
endmodule
