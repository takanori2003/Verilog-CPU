module pc_add(in,out);
	input logic [31:0]in;
	output logic [31:0]out;
	
	assign out = in + 32'd4;
endmodule
	