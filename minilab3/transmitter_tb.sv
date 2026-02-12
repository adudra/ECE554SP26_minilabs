module transmitter_tb();
    logic clk;
    logic rst;
    logic i_start;
    logic [7:0] i_data;
    logic i_tx_en;
    logic [7:0] db_high;
    logic [7:0] db_low;
    wire o_txd;
    wire o_busy;
    int counter = 0;

    transmitter dut (
        .clk(clk),
        .rst(rst),
        .i_start(i_start),
        .i_data(i_data),
        .i_tx_en(i_tx_en),
        .o_txd(o_txd),
        .o_busy(o_busy)
    );

    assign i_tx_en = counter == 3;

    always @(posedge clk) begin
        counter = counter + 1;
        if (counter > 3) counter = 0; 
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        rst = 1;
        i_start = 0;
        i_data = 8'h00;

        repeat (2) @(posedge clk);
        rst = 0; // Release reset after some time
        repeat (2) @(posedge clk);

        // Test case: Transmit a byte
        repeat (2) @(posedge clk);
        i_data = 8'hA5; // Data to transmit
            i_start = 1;      // Start transmission
        repeat (2) @(posedge clk);
        i_start = 0;      // Clear start signal

        // Wait for transmission to complete
        repeat (40) @(posedge clk);

        $stop; // End simulation
    end

endmodule