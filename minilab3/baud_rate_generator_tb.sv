// module baud_rate_generator_tb ();

// // SIGNAL DECLARATION 
// logic clk;
// logic rst;
// logic [7:0] db_high;
// logic [7:0] db_low;
// logic tx_en;
// logic rx_baud;

// // INSTANTIATE THE DUT
// baud_rate_generator iBG(
//     .clk(clk),
//     .rst(rst),
//     .db_high(db_high),
//     .db_low(db_low),
//     .tx_en(tx_en),
//     .rx_baud(rx_baud)
// );


// // APPLY STIMULUS 
// initial begin
//     clk = 0;
//     rst = 1;
//     db_high = 8'h00;
//     db_low = 8'h00;

//     @(negedge clk) begin 
//         rst = 0;
//         db_high = 8'h00;
//         db_low = 8'h05;
//     end 

//     @(posedge iBG.tx_en); // indicates

//     //expecting to see 2 tx_en 

//     $stop();

// end

// // CLK GENERATION
// always begin
//     #5 clk = ~clk;
// end

// endmodule

`timescale 1ns/1ps

module tb_baud_rate_generator;

  // DUT interface
  logic        clk;
  logic        rst;
  logic [7:0]  db_high;
  logic [7:0]  db_low;
  wire         tx_en;
  wire         rx_baud;

  // 50 MHz clock
  localparam time CLK_PERIOD = 20ns;

  // Reset divisor from your RTL comment:
  // (50MHz / (2^4 * 9600)) - 1 = 324 = 16'h0144
  localparam logic [15:0] RESET_DIVISOR = 16'h0144;

  // Clock gen
  initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
  end

  // Instantiate DUT
  baud_rate_generator dut (
    .clk     (clk),
    .rst     (rst),
    .db_high (db_high),
    .db_low  (db_low),
    .tx_en   (tx_en),
    .rx_baud (rx_baud)
  );

  // -----------------------------------------
  // Tasks
  // -----------------------------------------

  task automatic wait_tx_pulse();
    @(posedge clk);
    while (!tx_en) @(posedge clk);
  endtask

  task automatic wait_rx_pulse();
    @(posedge clk);
    while (!rx_baud) @(posedge clk);
  endtask

  // Measures cycles between two consecutive tx_en pulses.
  // Returns interval in cycles in 'interval_cycles'.
  task automatic measure_tx_interval(output int unsigned interval_cycles);
    int unsigned cycles;

    // sync to a pulse
    wait_tx_pulse();

    // count cycles to next pulse
    cycles = 0;
    forever begin
      @(posedge clk);
      if (rx_baud)
        cycles++;
      if (tx_en) begin
        interval_cycles = cycles; // expected = divisor + 1
        return;
      end
    end;
  endtask

  // Measures cycles between two consecutive rx_baud pulses.
  // Returns interval in cycles in 'interval_cycles'.
  task automatic measure_rx_interval(output int unsigned interval_cycles);
    int unsigned cycles;

    // sync to a pulse
    wait_rx_pulse();

    // count cycles to next pulse
    cycles = 0;
    forever begin
      @(posedge clk);
      cycles++;
      if (rx_baud) begin
        interval_cycles = cycles; // expected = divisor + 1
        return;
      end
    end
  endtask


  // After reset, BRG runs using RESET_DIVISOR first.
  task automatic check_reset_interval();
    int unsigned cycles;

    // count cycles to next pulse
    cycles = 0;
    forever begin
        @(posedge clk);
        cycles++;
        if (dut.load_div) begin
            return;
        end
    end
    if (cycles !== (RESET_DIVISOR + 1)) begin    
        $error("Reset interval mismatch: got %0d, expected %0d (RESET_DIVISOR=%0d)",
               cycles, (RESET_DIVISOR + 1), RESET_DIVISOR);
        $stop();
    end
  endtask


  // -----------------------------------------
  // Test sequence
  // -----------------------------------------
  initial begin
    int unsigned interval;

    rst     = 1'b1;
    db_high = 8'h00;
    db_low  = 8'h04;

    repeat (5) @(posedge clk);
    rst = 1'b0;

    // Verify default divisor behavior immediately after reset
    check_reset_interval();
    $display("[OK] Reset divisor interval verified");

    // Update divisor tests (small divisors keep sim quick)
    $display("TEST: divisor -> 4 (expect rx_baud every 5 clocks AFTER reload)");
    measure_rx_interval(interval);
    if (interval !== 5) begin 
        $error("rx_baud interval mismatch: got %0d, expected %0d",interval, 5);
        $stop();
    end

    $display("TEST: expect tx_en once every 16 pulses of rx_baud");
    measure_tx_interval(interval);
    if (interval !== 16) begin 
        $error("tx_en interval mismatch: got 1 tx_en for %0d rx_baud pulses, expected %0d rx_baud pulses",interval, 16);
        $stop();
    end

    db_high = 8'h00;
    db_low = 8'h09;
    @(posedge dut.load_div); // signals the new divisor was taken
    $display("TEST: divisor -> 9 (expect rx_baud every 10 clocks AFTER reload)");
     measure_rx_interval(interval);
    if (interval !== 10) begin 
        $error("rx_baud interval mismatch: got %0d, expected %0d",interval, 10);
        $stop();
    end

    $display("TEST: expect tx_en once every 16 pulses of rx_baud");
    measure_tx_interval(interval);
    if (interval !== 16) begin 
        $error("tx_en interval mismatch: got 1 tx_en for %0d rx_baud pulses, expected %0d rx_baud pulses",interval, 16);
        $stop();
    end

    $display("YAHOO! ALL TESTS PASSED");
    $stop();
  end

endmodule


