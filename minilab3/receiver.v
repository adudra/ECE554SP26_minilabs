module receiver(
    input clk,
    input rst,
    input rx_en,
    input rxd,
    output [7:0] rx_data,
    output rx_ready
);

parameter IDLE = 2'b00;
parameter RECEIVING = 2'b01;
parameter DONE = 2'b10;

reg rx_ready_reg;
reg [1:0] state, next_state;
reg [3:0] bit_index;
reg [7:0] shift_register, receive_buffer;

assign rx_ready = rx_ready_reg;
assign rx_data = receive_buffer;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        bit_index <= 4'd0;
        shift_register <= 8'd0;
        receive_buffer <= 8'd0;
        rx_ready_reg <= 1'b0;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state;
    rx_ready_reg = 1'b0;

    case (state)
        IDLE: begin
            if (rx_en && ~rxd) begin // start bit detected
                next_state = RECEIVING;
                bit_index = 4'd0;
            end else begin
                next_state = IDLE;
            end
        end
        RECEIVING: begin
            shift_register = {rxd, shift_register[7:1]}; // shift in data bit
            bit_index = bit_index + 1;
            if (bit_index == 4'd7) begin // all bits received
                next_state = DONE;
            end else begin
                next_state = RECEIVING;
            end
        end
        DONE: begin
            rx_ready_reg = 1'b1; // indicate data is ready
            receive_buffer = shift_register;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule