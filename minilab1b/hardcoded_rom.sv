module rom (
    input  wire [4:0]  address,   // enough bits for 0–8
    input  wire        clock,
    output reg  [63:0] q
);

    always @(posedge clock) begin
        case (address)
            5'd0: q <= 64'h0102030405060708;
            5'd1: q <= 64'h1112131415161718;
            5'd2: q <= 64'h2122232425262728;
            5'd3: q <= 64'h3132333435363738;
            5'd4: q <= 64'h4142434445464748;
            5'd5: q <= 64'h5152535455565758;
            5'd6: q <= 64'h6162636465666768;
            5'd7: q <= 64'h7172737475767778;
            5'd8: q <= 64'h8182838485868788;
            default: q <= 64'h0000000000000000; // safe default
        endcase
    end

endmodule
