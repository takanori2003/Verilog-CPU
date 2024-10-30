`timescale 1ns/10ps
module mux4_1x32(out, in, sel);
	input logic [31:0]in[3:0];
	input logic [1:0]sel;
	output logic [31:0]out;
	
	genvar i,j;
	generate 
		//do nested for loop since in[31:0][i] is not allowed
		for(i=0; i<31; i++) begin : loop1
			logic [1:0] bits2;
			for(j=0; j<4; j++) begin :loop2
				assign bits2[j] = in[j][i];
			end
			mux4_1 m0(.out(out[i]), .in(bits2), .sel);
		end
	endgenerate
endmodule
		