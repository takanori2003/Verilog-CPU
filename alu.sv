`timescale 1ns/10ps
module alu(A, B, cntrl, result, negative, zero, overflow, carry_out);
	input logic [63:0] A, B;
	input logic [2:0] cntrl;
	output logic negative, zero, overflow, carry_out;
	output logic [63:0] result;
	
	
	operation opr(.A, .B, .cntrl, .result, .overflow, .carry_out);
	
	zeroIden iden(.result, .zero);
	
	assign negative = result[63];
endmodule
