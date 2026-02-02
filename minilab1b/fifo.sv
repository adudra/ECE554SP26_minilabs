module FIFO
#(
  parameter DEPTH=8,
  parameter DATA_WIDTH=8
)
(
  input  clk,
  input  rst_n, //asynchronous active low reset
  input  rden,
  input  wren,
  input  [DATA_WIDTH-1:0] i_data,
  output reg [DATA_WIDTH-1:0] o_data,
  output full,
  output empty
);

reg [2:0] w_ptr;
reg [2:0] r_ptr;
reg [3:0] count;
reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];

// CONDITIONAL FLAGS //
assign full = count == 4'd8; 
  // full when the write flag wraps around and equals the read pointer 
  // not easily detectable in HW, so always keep one space empty
assign empty = count == 4'd0;
  // empty when the two pointers are equal

// FIFO MEMORY UPDATE //
always @(posedge clk, negedge rst_n) begin 
  if (!rst_n) begin
    fifo_mem[0] <= {DATA_WIDTH{1'b0}};
    fifo_mem[1] <= {DATA_WIDTH{1'b0}};
    fifo_mem[2] <= {DATA_WIDTH{1'b0}};
    fifo_mem[3] <= {DATA_WIDTH{1'b0}};
    fifo_mem[4] <= {DATA_WIDTH{1'b0}};
    fifo_mem[5] <= {DATA_WIDTH{1'b0}};
    fifo_mem[6] <= {DATA_WIDTH{1'b0}};
    fifo_mem[7] <= {DATA_WIDTH{1'b0}};
  end else if (wren & !full)
    fifo_mem[w_ptr] <= i_data;
end

// OUTPUT UPDATE //
always @(posedge clk, negedge rst_n) begin 
    if (!rst_n)
	    o_data <= 8'h00;
    else if (rden & !empty)
    	o_data <= fifo_mem[r_ptr];
end

// FIFO WRITE POINTER UPDATE //
always @(posedge clk, negedge rst_n) begin 
  if (!rst_n) 
    w_ptr <= 1'b0;
  else if  (wren & !full)
    w_ptr <= w_ptr + 1;
end 

// FIFO READ POINTER UPDATE //
always @(posedge clk, negedge rst_n) begin 
  if (!rst_n) 
    r_ptr <= 1'b0;
  else if (rden & !empty)
    r_ptr <= r_ptr + 1;
end 

always @(posedge clk, negedge rst_n ) begin
  if (!rst_n) 
    count <= 1'b0;
  else
    count <= count + (wren & !full) - (rden & !empty);
end


endmodule