module transmitter(
    input wire clk,
    input wire rst,
    input wire tx_en,
    input wire [7:0] tx_data,
    output wire txd,
    output wire tx_busy
);

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter DATA = 2'b10;
parameter STOP = 2'b11;

reg [1:0] state, next_state;
reg [3:0] bit_index;
reg [7:0] shift_register, transmit_buffer;
reg txd_reg;
reg tx_busy_reg;

assign txd = txd_reg;
assign tx_busy = tx_busy_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        bit_index <= 4'd0;
        shift_register <= 8'd0;
        transmit_buffer <= 8'd0;
        txd_reg <= 1'b1;
        tx_busy_reg <= 1'b0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    txd_reg = 1'b1;
    tx_busy_reg = 1'b0;
    next_state = state;

    case (state)
        IDLE: begin
            txd_reg = 1'b1;
            tx_busy_reg = 1'b0;
            if (tx_en) begin
                shift_register = tx_data;
                transmit_buffer = tx_data;
                next_state = START;
                bit_index = 4'd0;
            end else begin
                next_state = IDLE;
            end
        end
        START: begin
            txd_reg = 1'b0; // start bit
            tx_busy_reg = 1'b1;
            next_state = DATA;
        end
        DATA: begin
            txd_reg = shift_register[0]; // data bit
            tx_busy_reg = 1'b1;
            shift_register = shift_register >> 1; // get next
            bit_index = bit_index + 1; // update index
            if (bit_index == 4'd7) begin // transmission complete
                next_state = STOP;
            end else begin
                next_state = DATA;
            end
        end
        STOP: begin
            txd_reg = 1'b1; // stop bit
            tx_busy_reg = 1'b1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule