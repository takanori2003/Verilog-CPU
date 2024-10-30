
`timescale 1ns/10ps
module mux4_1x64(out, in, sel);
	input logic [63:0]in[3:0];
	input logic [1:0]sel;
	output logic [63:0]out;
	
	genvar i,j;
	generate 
		//do nested for loop since in[31:0][i] is not allowed
		for(i=0; i<64; i++) begin : loop1
			logic [3:0] bits4;
			for(j=0; j<4; j++) begin :loop2
				assign bits4[j] = in[j][i];
			end
			mux4_1 m0(.out(out[i]), .in(bits4), .sel);
		end
	endgenerate
endmodule