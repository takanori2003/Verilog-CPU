
`timescale 1ns/10ps
module fullAdder (s, A, B, c_in, c_out);
	input logic A, B, c_in;
	output logic s, c_out;
	
	logic sxor0, sand0, sand1;
	
	xor #50 xor0(sxor0, A, B);
	and #50 and0(sand0, A, B);
	xor #50 xor1(s, sxor0, c_in);
	and #50 and1(sand1, sxor0, c_in);
	or #50 or0(c_out, sand1, sand0);
	
endmodule
	