`timescale 1ns/10ps
module oneRegister(out, in, reset, clk);
	input logic in;
	input logic clk, reset;
	output logic out;
	
	D_FF flipflop(.q(out), .d(in), .reset(1'b0), .clk(clk));
	
endmodule