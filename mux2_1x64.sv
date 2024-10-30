
`timescale 1ns/10ps
module mux2_1x64(out, in, sel);
	input logic [63:0]in[1:0];
	input logic sel;
	output logic [63:0]out;
	
	genvar i,j;
	generate 
		//do nested for loop since in[31:0][i] is not allowed
		for(i=0; i<64; i++) begin : loop1
			logic [1:0] bits2;
			for(j=0; j<2; j++) begin :loop2
				assign bits2[j] = in[j][i];
			end
			mux2_1 m0(.out(out[i]), .in(bits2), .sel);
		end
	endgenerate
endmodule
		