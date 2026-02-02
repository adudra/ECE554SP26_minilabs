module mac_tb ();

// SIGNAL DECLARATIONS //
logic clk;
logic rst_n;
logic en;
logic clr;
logic [7:0] Ain;
logic [7:0] Bin;
logic [23:0] Cout;

// DUT INSTANTIATION //
MAC #(.DATA_WIDTH(8)) imac (
	.clk(clk),
	.rst_n(rst_n),
	.En(en),
	.Clr(clr),
	.Ain(Ain),
	.Bin(Bin),
	.Cout(Cout)
);

// STIMULUS APPLICATION //
initial begin 
	// INITIAL CONDITIONS //
	clk = 1'b0;
	rst_n = 1'b0;
	en = 1'b0;
	clr = 1'b0;
	Ain = 8'h00;
	Bin = 8'h00;

	// TEST BEGIN BELOW //
	@(negedge clk) begin 
		rst_n = 1'b1;
		Ain = 8'h02;
		Bin = 8'h02;
	end

	// Case 1: Nothing outputted when enable is low 
	@(posedge clk);
	#1
	if (Cout !== 24'd0) begin 
		$display("ERROR CASE1: output was non-zero upon reset");
		$stop();
	end

	// Case 2: standard multiply (1 cycle)
	@(negedge clk) begin 
		en = 1'b1;
	end

	@(posedge clk);
 	#1
	if (Cout !== 24'd4) begin 
		$display("ERROR CASE2: output was not 4 after single multiply");
		$stop();
	end
	// Case 3: standard multiply and accumulate 

	repeat (3) @(posedge clk);
	#1
	if (Cout !== 24'd16) begin 
		$display("ERROR CASE3: output did not accumulate correctly after 3 cycles of enable");
		$stop();
	end

	// Case 4: hold when en low 
	@(negedge clk) begin 
		en = 1'b0;
	end

	@(posedge clk);
 	#1
	if (Cout !== 24'd16) begin 
		$display("ERROR CASE4: output did not hold when enable deasserted");
		$stop();
	end
	
	// Case 5: clear functionality 
	@(negedge clk) begin 
		clr = 1'b1;
	end

	@(posedge clk);
 	#1
	if (Cout !== 24'd0) begin 
		$display("ERROR CASE5: output did not clear when control signal asserted");
		$stop();
	end

	// Case 6: accumulated again after clear
	@(negedge clk) begin 
		clr = 1'b0;
		en = 1'b1;
	end

	@(posedge clk);
 	#1
	if (Cout !== 24'd4) begin 
		$display("ERROR CASE6: output incorrectly accumulated after clear");
		$stop();
	end

	$display("YAHOO! ALL TESTS PASSED");
	$stop();
end

// CLOCK GENERATION //
always begin
	#5 clk = ~clk;
end

endmodule
