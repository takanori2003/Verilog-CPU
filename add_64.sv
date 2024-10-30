`timescale 1ns/10ps

module add_64(s, A, B, cntl, c_out);
	input logic cntl;
	input logic [63:0] A, B;
	output logic [63:0] s;
	output logic [63:0] c_out;
	logic [63:0] rxor;
	
	xor #50 xor0(rxor[0], B[0], cntl);
	fullAdder full(.s(s[0]), .A(A[0]), .B(rxor[0]), .c_in(cntl), .c_out(c_out[0])); 
	//module fullAdder (s, A, B, c_in, c_out);
	//input logic A, B, c_in;
	//output logic s, c_out;
	
	genvar i;
	generate 
		for(i=1; i<64; i++) begin : adder
			xor #50 xor0(rxor[i], B[i], cntl);
			fullAdder full(.s(s[i]), .A(A[i]), .B(rxor[i]), .c_in(c_out[i-1]), .c_out(c_out[i])); 
		end
//		assign carry_out = c_out[63];
//		xor #50 xor1(flow, c_out[62], c_out[63]);
//		assign overflow = flow;

	endgenerate
endmodule


module add_64_testbench();
	logic cntl;
	logic [63:0] A, B;
	logic overflow, carry_out;
	logic [63:0] s;
	logic [63:0] c_out;
	logic flow;
	logic [63:0] rxor;
		
	add_64 dut (.s, .A, .B, .cntl, .c_out);
		
	integer i;
	initial begin
	A <= 0;
	B <=0;
	
	cntl <= 0;
		$display("%t testing add_64 operation", $time);
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(10000);
			assert(A + B == s);
		end
		cntl = 1;
		for (i=0; i<10; i++) begin
			A = $random(); B = $random();
			#(10000);
			assert(A - B == s);
		end
	/*
		for(i=0; i<63; i++) begin
				A[i] <= 1; #100;
				cntl <= 0; #100;
				B[i] <= 1; #100;
				cntl <= 1; #100;
		end
		$stop;
	*/
	end
endmodule

