`timescale 1ns/10ps
module mux64_32(out,in, sel);
	input logic [63:0]in [31:0];
	input logic [4:0] sel;
	output logic [63:0]out;
	
	genvar i,j;
	generate 
		//do nested for loop since in[31:0][i] is not allowed
		for(i=0; i<64; i++) begin : muxgen
			logic [31:0] bits32;
			for(j=0; j<32; j++) begin :bits
				assign bits32[j] = in[j][i];
			end
			mux32_1 m0(.out(out[i]), .in(bits32), .sel);
		end
	endgenerate
	
endmodule 

module mux64_32_testbench();
		logic [63:0]in[31:0]; 
		logic [4:0]sel;
		logic [63:0]out;
		
		mux64_32 dut (.out, .in, .sel);
		
		integer i;
		initial begin
		sel <= 0;
		out <=0;
		in[0] <= 64'b1; #10;
		in[1] <= 64'b11; #10;
		in[2] <= 64'b111; #10;
		in[3] <= 64'b1111; #10;
					
		in[4] <= 64'b11111; #10;
		in[5] <= 64'b111111; #10;
		in[6] <= 64'b1111111; #10;
		in[7] <= 64'b11111111; #10;
		
		in[8] <= 64'b111111111; #10;
		in[9] <= 64'b1111111111; #10;
		in[10] <= 64'b11111111111; #10;
		in[11] <= 64'b111111111111; #10;
					
		in[12] <= 64'b1111111111111; #10;
		in[13] <= 64'b11111111111111; #10;
		in[14] <= 64'b111111111111111; #10;
		in[15] <= 64'b1111111111111111; #10;
		
		in[16] <= 64'b11111111111111111; #10;
		in[17] <= 64'b111111111111111111; #10;
		in[18] <= 64'b1111111111111111111; #10;
		in[19] <= 64'b11111111111111111111; #10;
					
		in[20] <= 64'b1111111111111111111111; #10;
		in[21] <= 64'b11111111111111111111111; #10;
		in[22] <= 64'b111111111111111111111111; #10;
		in[23] <= 64'b1111111111111111111111111; #10;
		
		in[24] <= 64'b11111111111111111111111111; 
		in[25] <= 64'b111111111111111111111111111;
		in[26] <= 64'b1111111111111111111111111111;
		in[27] <= 64'b11111111111111111111111111111;
		
		in[28] <= 64'b111111111111111111111111111111; 
		in[29] <= 64'b1111111111111111111111111111111; 
		in[30] <= 64'b11111111111111111111111111111111; 
		in[31] <= 64'b111111111111111111111111111111111; #10;
		
		
			
			for(i=0; i<32; i++) begin
					{sel[4:0]} = i; #10;
			end
		end
endmodule