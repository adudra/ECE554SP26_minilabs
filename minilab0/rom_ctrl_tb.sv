module rom_ctrl_tb ();

// Signal Declaration
logic clk;
logic enable;
logic [7:0] addr_oneshot;
logic [7:0] dout;

// DUT instantiation
rom_ctrl irom_ctrl(.clk(clk), .enable(enable), .addr_oneshot(addr_oneshot), .dout(dout) );

// Stimulus application
initial begin 
    //
    clk = 0;
    enable = 0;
    addr_oneshot = 8'h01;

    @(posedge clk);
    // Test 1 : Reading when enable is low
    @(posedge clk) if (dout !== 8'h00) begin
		$display("ERROR TEST 1: ROM output a non-zero values when enable is low.");	
		$stop();
	end

    @(posedge clk) begin 
        enable = 1;
    end 
    // Test 2 : Reading when enable is high 
    @(posedge clk) if (dout === 8'h00) begin
		$display("ERROR TEST 2: ROM output a zero value when enable is high.");	
		$stop();
	end

    $display("YAHOO! ALL TESTS PASSED");
    $stop();
end 

// Clock Generation (100Mhz -> 10ns Period)
always 
    #5 clk = ~clk;


endmodule