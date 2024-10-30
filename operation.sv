`timescale 1ns/10ps
module operation(A, B, cntrl, result, overflow, carry_out);
	input logic [63:0] A,B;
	input logic [2:0]cntrl;
	output logic overflow, carry_out;
	output logic [63:0] result;
	logic [63:0] temp[7:0];
	logic [63:0] tempand, tempor, tempxor, tempadd_sub, tempsub, c_out;
	logic flow;
	//0
	assign temp[0] = B;
	// control is 0 for addition and 1 for substration
	//2 and 3
	add_64 add_sub (.s(tempadd_sub), .A, .B, .cntl(cntrl[0]), .c_out);
	assign temp[2] = tempadd_sub;
	assign temp[3] = tempadd_sub;
	
	
	assign carry_out = c_out[63];
	xor #50 xor1(flow, c_out[62], c_out[63]);
	assign overflow = flow;

	//4
	genvar i,j;
	generate 
		for(i=0; i<64; i++) begin : tadd
			and #50 and0(tempand[i], A[i], B[i]);
		end
		assign temp[4] = tempand;
		
	//5
	 
		for(i=0; i<64; i++) begin : top
			or #50 or0(tempor[i], A[i], B[i]);
		end
		assign temp[5] = tempor;
	
	//6
		for(i=0; i<64; i++) begin : txor
			xor #50 xor0(tempxor[i], A[i], B[i]);
		end
		assign temp[6] = tempxor;
		
		for(i=0; i<64; i++) begin :mux8
			logic [7:0] bits8;
			for(j=0; j<8; j++) begin :bits
				assign bits8[j] = temp[j][i];
			end
			mux8_1 dec(.out(result[i]), .in(bits8), .sel(cntrl));
		end 
	endgenerate
	
endmodule
