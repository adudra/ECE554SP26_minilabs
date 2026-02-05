module MAC #
(
parameter DATA_WIDTH = 8
)
(
input clk,
input rst_n,
input En,
input Clr,
input [DATA_WIDTH-1:0] Ain,
input [DATA_WIDTH-1:0] Bin,
output reg [DATA_WIDTH*3-1:0] Cout
);

// wire [23:0] mult_result;
// reg [23:0] add_result;

reg[23:0] mult_pipeline;
reg En_delay;

//Accumulate unit 
always @(posedge clk, negedge rst_n) begin 
	if (!rst_n) begin 
	    mult_pipeline <= {DATA_WIDTH*3{1'b0}};
		En_delay <= 1'b0;
		Cout <= {DATA_WIDTH*3{1'b0}};
	end
	else if (Clr) begin
	    mult_pipeline <= {DATA_WIDTH*3{1'b0}};
		En_delay <= 1'b0;
		Cout <= {DATA_WIDTH*3{1'b0}};
	end
	else begin
		if (En_delay) 
			Cout <= Cout + mult_pipeline; // the insertion of the pipelining causes us to enable which updates Cout
		En_delay <= En;
		if (En)
			mult_pipeline <=  Ain * Bin; 
	end	
end

// lpm_mult_ip imult(
// 	.dataa(Ain),
// 	.datab(Bin),
// 	.result(mult_result),
// );

// lpm_add_sub_ip iadd(
// 	.dataa(mult_result),
// 	.datab(Cout),
// 	.result(add_result)
// );

endmodule