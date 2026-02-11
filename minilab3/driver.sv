module driver (
    input wire clk,
    input wire rst,
    input wire [1:0] br_cfg,
    output logic iocs,
    output logic iorw,
    input wire rda,
    input wire tbr,
    output logic [1:0] ioaddr,
    inout wire [7:0] databus
);
    // Instantiate a receive buffer (FIFO).
    logic rxb_rden, rxb_wren;
    logic [7:0] rxb_idata, rxb_odata;
    logic rxb_full, rxb_empty;
    // FIFO #(.DEPTH(8), .DATA_WIDTH(8)) rxb (
    //     .clk(clk),
    //     .rst_n(~rst),
    //     .rden(rxb_rden),
    //     .wren(rxb_wren),
    //     .i_data(rxb_idata),
    //     .o_data(rxb_odata),
    //     .full(rxb_full),
    //     .empty(rxb_empty)
    // );

    // Instantiate a transmit buffer (FIFO).
    logic txb_rden, txb_wren;
    logic [7:0] txb_idata, txb_odata;
    logic txb_full, txb_empty;
    // FIFO #(.DEPTH(8), .DATA_WIDTH(8)) txb (
    //     .clk(clk),
    //     .rst_n(~rst),
    //     .rden(txb_rden),
    //     .wren(txb_wren),
    //     .i_data(txb_idata),
    //     .o_data(txb_odata),
    //     .full(txb_full),
    //     .empty(txb_empty)
    // );

    typedef enum logic [1:0] { LOAD_LO, LOAD_HI, RECV, SEND } state_t;
    state_t state, next_state;
    always_ff @(posedge clk, posedge rst) begin
        if (rst)
            state <= LOAD_LO;
        else
            state <= next_state;
    end

    logic [7:0] fifo;
    logic write_fifo;
    always_ff @(posedge clk) begin
        if (write_fifo)
            fifo <= databus;
    end

    logic read_fifo;
    always_comb databus = read_fifo ? odata : 8'hxx;

    always_comb begin
        iocs = 1'b0;
        iorw = 1'bx;
        ioaddr = 2'hx;
        write_fifo = 1'b0;
        read_fifo = 1'b0;

        case (state)
            LOAD_LO: begin
                iocs = 1'b1;
                iorw = 1'b0;
                ioaddr = 2'h2;
                odata = LOW; // TODO:

                next_state = LOAD_HI;
            end
            LOAD_HI: begin
                iocs = 1'b1;
                iorw = 1'b0;
                ioaddr = 2'h2;
                odata = HI; // TODO:

                next_state = RECV;
            end
            RECV: begin
                if (rda) begin
                    iocs = 1'b1;
                    iorw = 1'b1;
                    ioaddr = 2'h0;
                    write_fifo = 1'b1;
                    next_state = SEND;
                end
            end
            SEND: begin
                if (tbr) begin
                    iocs = 1'b1;
                    iorw = 1'b0;
                    ioaddr = 2'h0;
                    read_fifo = 1'b1;
                    next_state = RECV;
                end
            end
        endcase
    end
endmodule
