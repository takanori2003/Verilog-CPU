`timescale 1ns/10ps
module mux8_1(out, in, sel);
		output logic out;
		input logic [7:0] in;
		input logic [2:0] sel;

		logic [1:0]v;
		
		mux4_1 m0(.out(v[0]), .in(in[3:0]), .sel(sel[1:0]));
		mux4_1 m1(.out(v[1]), .in(in[7:4]), .sel(sel[1:0]));
		mux2_1 m (.out(out), .in(v[1:0]), .sel(sel[2]));
endmodule

module mux8_1_testbench();
		logic [7:0]in; 
		logic [2:0]sel;
		logic out;
		
		mux8_1 dut (.out, .in, .sel);
		
		integer i;
		initial begin
			in <= 0;
			sel <= 0;
			out <=0;
			for(i=0; i<2048; i++) begin
					{sel[2:0], in[7:0]} = i; #10;
			end
		end
endmodule
