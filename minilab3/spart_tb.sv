`timescale 1ns/1ps

module spart_tb();

  // ------------------------------------------------------------
  // Receiver Signals
  // ------------------------------------------------------------
  logic clk;
  logic rst;
  logic rx_baud;
  logic spart_receiver;     // SPART txd -> external receiver rxd
  logic transmitter_spart;  // external transmitter txd -> SPART rxd
  logic reset_valid;        // clears the valid flag (receiver)
  logic [7:0] o_data;
  logic o_valid;

  // ------------------------------------------------------------
  // Transmit Signals (external transmitter)
  // ------------------------------------------------------------
  logic start;
  logic [7:0] i_data;
  logic tx_en;
  logic busy;

  // ------------------------------------------------------------
  // SPART Processor-side Signals
  // ------------------------------------------------------------
  logic iocs;               // chip select
  logic iorw;               // 1=read, 0=write
  logic rda;                // receive data available
  logic tbr;                // transmit buffer ready
  logic [1:0] ioaddr;
  tri   [7:0] databus;      // true tri-state bus

  // Testbench drive for databus (only when writing)
  logic       db_drive_en;
  logic [7:0] db_drive_val;
  assign databus = db_drive_en ? db_drive_val : 8'hZZ;

  // Sampled read value (when SPART drives databus on reads)
  logic [7:0] db_read_val;

  // ------------------------------------------------------------
  // Address map (UPDATE IF YOUR SPART DIFFERS)
  // ------------------------------------------------------------
  localparam logic [1:0] ADDR_DATA   = 2'b00;
  localparam logic [1:0] ADDR_STATUS = 2'b01;
  localparam logic [1:0] ADDR_DB_LOW = 2'b10;
  localparam logic [1:0] ADDR_DB_HIGH= 2'b11;

  // ------------------------------------------------------------
  // Module Instantiation
  // ------------------------------------------------------------
  spart iSP(
    .clk(clk),
    .rst(rst),
    .iocs(iocs),
    .iorw(iorw),
    .rda(rda),
    .tbr(tbr),
    .ioaddr(ioaddr),
    .databus(databus),
    .txd(spart_receiver),
    .rxd(transmitter_spart)
  );

  receiver iREC(
    .clk(clk),
    .rst(rst),
    .i_rx_baud(rx_baud),
    .i_rxd(spart_receiver),
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
    .o_txd(transmitter_spart),
    .o_busy(busy)
  );

  // External BRG for the standalone transmitter/receiver modules.
  // (SPART has its own BRG internally; we still need timing for iREC/iTRANS.)
  baud_rate_generator iBAUD_GEN(
    .clk(clk),
    .rst(rst),
    .db_high(8'h00),
    .db_low(8'h05),
    .tx_en(tx_en),
    .rx_baud(rx_baud)
  );

  // ------------------------------------------------------------
  // Clock generation
  // ------------------------------------------------------------
  initial clk = 1'b0;
  always #5 clk = ~clk; // 100 MHz

  // ------------------------------------------------------------
  // Bus helper tasks (single-cycle command, capture next edge)
  // Per spec: apply IOCS/IORW/IOADDR/(DATABUS for writes) for one
  // cycle; transferred data is captured on the next posedge. :contentReference[oaicite:2]{index=2}
  // ------------------------------------------------------------

  task automatic bus_idle();
    iocs        <= 1'b0;
    iorw        <= 1'b1;
    ioaddr      <= 2'b00;
    db_drive_en <= 1'b0;
    db_drive_val<= 8'h00;
  endtask

  task automatic bus_write(input logic [1:0] addr, input logic [7:0] data);
    // Drive bus for 1 cycle
    @(negedge clk);
    ioaddr      <= addr;
    iorw        <= 1'b0;     // write
    iocs        <= 1'b1;
    db_drive_en <= 1'b1;
    db_drive_val<= data;

    // SPART captures on next posedge
    @(posedge clk);

    // Release bus
    @(negedge clk);
    bus_idle();
  endtask

  task automatic bus_read(input logic [1:0] addr, output logic [7:0] data);
    // Request read for 1 cycle (TB must NOT drive databus)
    @(negedge clk);
    ioaddr      <= addr;
    iorw        <= 1'b1;     // read
    iocs        <= 1'b1;
    db_drive_en <= 1'b0;

    // Capture on next posedge
    @(posedge clk);
    data = databus;

    // Deassert
    @(negedge clk);
    bus_idle();
  endtask

  // Wait for a condition with a timeout (prevents infinite hangs)
  task automatic wait_with_timeout(input string what,
                                   input int unsigned max_cycles,
                                   ref logic cond);
    int unsigned k;
    for (k = 0; k < max_cycles; k++) begin
      @(posedge clk);
      if (cond) return;
    end
    $display(1, "[TIMEOUT] %s after %0d cycles", what, max_cycles);
    $stop();
  endtask

  // Convenience: wait for posedge of a signal with timeout in clk cycles
  task automatic wait_posedge_timeout(input string what,
                                      input int unsigned max_cycles,
                                      ref logic sig);
    int unsigned k;
    logic prev;
    prev = sig;
    for (k = 0; k < max_cycles; k++) begin
      @(posedge clk);
      if (!prev && sig) return;
      prev = sig;
    end
    $fatal(1, "[TIMEOUT] %s (posedge not seen) after %0d cycles", what, max_cycles);
  endtask

  // ------------------------------------------------------------
  // TESTS
  // ------------------------------------------------------------

  // (Optional) Program SPART divisor if your SPART requires SW load
  // immediately after reset. The spec notes the divisor buffer should
  // be initialized on reset to a default suitable for 50MHz/9600. :contentReference[oaicite:3]{index=3}
  task automatic program_spart_divisor(input logic [15:0] div);
    bus_write(ADDR_DB_LOW,  div[7:0]);
    bus_write(ADDR_DB_HIGH, div[15:8]);
  endtask

  // Test 1: SPART -> external receiver
  // Write a byte into SPART TX buffer, confirm external receiver gets it.
  task automatic test_spart_to_receiver(input logic [7:0] tx_byte);
    logic [7:0] status;

    $display("\n[Test 1] SPART -> Receiver, byte=0x%02h", tx_byte);

    // Ensure receiver valid is clear
    reset_valid <= 1'b1;
    @(posedge clk);
    reset_valid <= 1'b0;

    // Wait until SPART transmit buffer is ready
    wait_with_timeout("Waiting for TBR=1", 100000, tbr);

    // Write data to SPART DATA register (TX buffer)
    bus_write(ADDR_DATA, tx_byte);

    // Wait for receiver to assert o_valid and compare data
    wait_posedge_timeout("Waiting for receiver o_valid", 2000000, o_valid);

    if (o_data !== tx_byte) begin
      $display(1, "[FAIL Test 1] Receiver got 0x%02h, expected 0x%02h", o_data, tx_byte);
      $stop();
    end
    else begin
      $display("[PASS Test 1] Receiver got matching byte 0x%02h", o_data);
    end

    // Confirm TBR went high again
    wait_with_timeout("Waiting for TBR=1 after transmit", 100000, tbr);

    // Clear valid again for cleanliness
    reset_valid <= 1'b1;
    @(posedge clk);
    reset_valid <= 1'b0;

  endtask

  // Test 2: external transmitter -> SPART
  // Send a byte into SPART RXD via external transmitter, then read SPART RX buffer.
  task automatic test_transmitter_to_spart(input logic [7:0] tx_byte);
    logic [7:0] rx_byte;
    logic [7:0] status;

    $display("\n[Test 2] Transmitter -> SPART, byte=0x%02h", tx_byte);

    // Start external transmitter for 1 cycle
    @(negedge clk);
    i_data <= tx_byte;
    start  <= 1'b1;
    @(posedge clk);
    start  <= 1'b0;

    // Wait for SPART to indicate receive data available
    wait_with_timeout("Waiting for SPART RDA=1", 2000000, rda);

    // Read from SPART DATA register (RX buffer)
    bus_read(ADDR_DATA, rx_byte);

    if (rx_byte !== tx_byte) begin
      $display(1, "[FAIL Test 2] SPART read 0x%02h, expected 0x%02h", rx_byte, tx_byte);
      $stop();
    end
    else begin
      $display("[PASS Test 2] SPART read matching byte 0x%02h", rx_byte);
    end

  endtask

  // ------------------------------------------------------------
  // Main stimulus
  // ------------------------------------------------------------
  initial begin
    // Defaults
    bus_idle();
    reset_valid = 1'b0;
    start       = 1'b0;
    i_data      = 8'h00;

    // Reset
    rst = 1'b1;
    repeat (5) @(posedge clk);
    rst = 1'b0;
    repeat (5) @(posedge clk);

    // programming divisor to match baud
    program_spart_divisor(16'h0005);

    @(posedge iSP.brg.load_div);

    // Run both directed tests
    test_spart_to_receiver(8'hA5);
    test_transmitter_to_spart(8'h3C);

    // You can add more random trials if you want
    test_spart_to_receiver(8'h01);
    test_transmitter_to_spart(8'hFF);

    $display("YAHOO! ALL TESTS PASSED!");
    $stop();
  end

endmodule
