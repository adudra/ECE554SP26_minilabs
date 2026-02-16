module loop_tb ();

// Receiver Signals
logic clk;
logic rst;
logic rx_baud;  
logic line;
logic reset_valid;   // clears the valid flag
logic [7:0] o_data;
logic o_valid;

// Transmit Signals 
logic start;         // initiates a transaction 
logic [7:0] i_data;
logic tx_en;
logic busy;

// -----------------------------
// Module Instantiation
// -----------------------------
receiver iREC(
    .clk(clk),
    .rst(rst),
    .i_rx_baud(rx_baud),
    .i_rxd(line),
    .i_reset_valid(reset_valid),
    .o_data(o_data),
    .o_valid(o_valid)
);

transmitter iTRANS(
    .clk(clk),
    .rst(rst),
    .i_start(start),
    .i_data(i_data),
    .i_tx_en(tx_en),
    .o_txd(line),
    .o_busy(busy)
);

baud_rate_generator iBAUD_GEN(
    .clk(clk),
    .rst(rst),
    .db_high(8'h00),
    .db_low(8'h05),
    .tx_en(tx_en),   // when we shift data onto the tx line
    .rx_baud(rx_baud)   // when we sample data from the rx line
);

  // -----------------------------
  // Clock generation
  // -----------------------------
  initial clk = 1'b0;
  always #5 clk = ~clk;      // 100 MHz if timescale is 1ns/1ps (adjust as needed)

  // -----------------------------
  // Task: send one byte
  // -----------------------------
  task automatic send_byte(input logic [7:0] b);
    begin
      // wait until transmitter is idle
      @(posedge clk);
      while (busy) @(posedge clk);

      i_data <= b;
      start  <= 1'b1;
      @(posedge clk);
      start  <= 1'b0;
    end
  endtask

  // -----------------------------
  // Task: wait for a received byte and check it
  // -----------------------------
  task automatic expect_byte(input logic [7:0] expected);
    logic [7:0] got;
    begin
      // Wait for receiver to assert valid
      @(posedge clk);
      while (!o_valid) @(posedge clk);

      got = o_data;

      if (got !== expected) begin
        $error("UART LOOPBACK FAIL: expected 0x%02h, got 0x%02h", expected, got);
      end else begin
        $display("UART LOOPBACK PASS: received 0x%02h", got);
      end

      // Clear valid flag (pulse reset_valid if your receiver uses it that way)
      reset_valid <= 1'b1;
      @(posedge clk);
      reset_valid <= 1'b0;
    end
  endtask


   // -----------------------------
  // Test sequence
  // -----------------------------
  initial begin
    // defaults
    start       = 1'b0;
    i_data      = 8'h00;
    reset_valid = 1'b0;

    // reset
    rst = 1'b1;
    repeat (10) @(posedge clk);
    rst = 1'b0;

    @(posedge iBAUD_GEN.load_div); // waits for new counter to load

    // Send one byte and verify loopback
    send_byte(8'h56);
    expect_byte(8'h56);

    repeat (6) @(posedge clk);
    send_byte(8'h06);
    expect_byte(8'h06);

    // done
    $stop();
  end

endmodule