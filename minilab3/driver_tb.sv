`timescale 1ns/1ps

module driver_tb();
  // ------------------------------------------------------------
  // Clock / Reset
  // ------------------------------------------------------------
  logic clk;
  logic rst;

  initial clk = 1'b0;
  always #5 clk = ~clk; // 100 MHz

  localparam logic [15:0] BAUD_DIV = 16'h0005;

  // ------------------------------------------------------------
  // DUT SPART + Driver (loopback hardware)
  // ------------------------------------------------------------
  logic dut_iocs;
  logic dut_iorw;
  logic dut_rda;
  logic dut_tbr;
  logic [1:0] dut_ioaddr;
  tri   [7:0] dut_databus;
  logic dut_txd;
  logic dut_rxd;

  spart dut_spart(
    .clk(clk),
    .rst(rst),
    .iocs(dut_iocs),
    .iorw(dut_iorw),
    .rda(dut_rda),
    .tbr(dut_tbr),
    .ioaddr(dut_ioaddr),
    .databus(dut_databus),
    .txd(dut_txd),
    .rxd(dut_rxd)
  );

  driver dut_driver(
    .clk(clk),
    .rst(rst),
    .br_cfg(2'b00),
    .iocs(dut_iocs),
    .iorw(dut_iorw),
    .rda(dut_rda),
    .tbr(dut_tbr),
    .ioaddr(dut_ioaddr),
    .databus(dut_databus)
  );

  // ------------------------------------------------------------
  // TB-side SPART (acts as the testbench host)
  // ------------------------------------------------------------
  logic tb_iocs;
  logic tb_iorw;
  logic tb_rda;
  logic tb_tbr;
  logic [1:0] tb_ioaddr;
  tri   [7:0] tb_databus;
  logic tb_txd;
  logic tb_rxd;

  logic       tb_db_drive_en;
  logic [7:0] tb_db_drive_val;
  assign tb_databus = tb_db_drive_en ? tb_db_drive_val : 8'hZZ;

  spart tb_spart(
    .clk(clk),
    .rst(rst),
    .iocs(tb_iocs),
    .iorw(tb_iorw),
    .rda(tb_rda),
    .tbr(tb_tbr),
    .ioaddr(tb_ioaddr),
    .databus(tb_databus),
    .txd(tb_txd),
    .rxd(tb_rxd)
  );

  // Cross-connect UART lines
  assign dut_rxd = tb_txd;
  assign tb_rxd  = dut_txd;

  // ------------------------------------------------------------
  // Address map
  // ------------------------------------------------------------
  localparam logic [1:0] ADDR_DATA   = 2'b00;
  localparam logic [1:0] ADDR_DB_LOW = 2'b10;
  localparam logic [1:0] ADDR_DB_HIGH= 2'b11;

  // ------------------------------------------------------------
  // Helpers
  // ------------------------------------------------------------
  task automatic bus_idle();
    tb_iocs        <= 1'b0;
    tb_iorw        <= 1'b1;
    tb_ioaddr      <= 2'b00;
    tb_db_drive_en <= 1'b0;
    tb_db_drive_val<= 8'h00;
  endtask

  task automatic bus_write(input logic [1:0] addr, input logic [7:0] data);
    @(negedge clk);
    tb_ioaddr      <= addr;
    tb_iorw        <= 1'b0;
    tb_iocs        <= 1'b1;
    tb_db_drive_en <= 1'b1;
    tb_db_drive_val<= data;
    @(posedge clk);
    @(negedge clk);
    bus_idle();
  endtask

  task automatic bus_read(input logic [1:0] addr, output logic [7:0] data);
    @(negedge clk);
    tb_ioaddr      <= addr;
    tb_iorw        <= 1'b1;
    tb_iocs        <= 1'b1;
    tb_db_drive_en <= 1'b0;
    @(posedge clk);
    data = tb_databus;
    @(negedge clk);
    bus_idle();
  endtask

  task automatic wait_with_timeout(input string what,
                                   input int unsigned max_cycles,
                                   ref logic cond);
    int unsigned k;
    for (k = 0; k < max_cycles; k++) begin
      @(posedge clk);
      if (cond) return;
    end
    $fatal(1, "[TIMEOUT] %s after %0d cycles", what, max_cycles);
  endtask

  task automatic program_tb_divisor();
    bus_write(ADDR_DB_LOW,  BAUD_DIV[7:0]);
    bus_write(ADDR_DB_HIGH, BAUD_DIV[15:8]);
  endtask

  task automatic send_and_check(input logic [7:0] tx_byte);
    logic [7:0] rx_byte;

    wait_with_timeout("Waiting for TB TBR=1", 100000, tb_tbr);
    bus_write(ADDR_DATA, tx_byte);
    wait_with_timeout("Waiting for TB RDA=1", 2_000_000, tb_rda);
    bus_read(ADDR_DATA, rx_byte);

    if (rx_byte !== tx_byte) begin
      $fatal(1, "[FAIL] Loopback got 0x%02h, expected 0x%02h", rx_byte, tx_byte);
    end
  endtask

  // ------------------------------------------------------------
  // Stimulus
  // ------------------------------------------------------------
  initial begin
    bus_idle();

    rst = 1'b1;
    repeat (5) @(posedge clk);
    rst = 1'b0;
    repeat (5) @(posedge clk);

    program_tb_divisor();
    repeat (10) @(posedge clk);

    send_and_check(8'hA5);
    send_and_check(8'h3C);
    send_and_check(8'h00);
    send_and_check(8'hFF);

    $display("YAHOO! DRIVER LOOPBACK TEST PASSED!");
    $stop();
  end
endmodule
