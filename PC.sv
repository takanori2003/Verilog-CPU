`timescale 1ns/10ps
module pc(in, out, clk, reset);
	input logic [63:0]in;
	input logic clk, reset;
	output logic [63:0]out;
	
	genvar i;
	generate 
	for (i=0; i<64; i++) begin : loop
		D_FF DFF(.q(out[i]), .d(in[i]), .reset, .clk);
		end 
	endgenerate
endmodule
