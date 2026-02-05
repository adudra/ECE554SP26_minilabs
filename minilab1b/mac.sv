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

//Accumulate unit 
always @(posedge clk, negedge rst_n) begin 
	if (!rst_n) begin 
	    mult_pipeline <= {DATA_WIDTH*3{1'b0}};
		Cout <= {DATA_WIDTH*3{1'b0}};
	end
	else if (Clr) begin
	    mult_pipeline <= {DATA_WIDTH*3{1'b0}};
		Cout <= {DATA_WIDTH*3{1'b0}};
	end
	else if (En) begin
		mult_pipeline <=  Ain * Bin; 
		Cout <= Cout + mult_pipeline;
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