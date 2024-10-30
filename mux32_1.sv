`timescale 1ns/10ps
module mux32_1(out,in, sel);
	input logic [31:0]in;
	input logic [4:0] sel;
	output logic out;
	
	logic [3:0]v;
	
	mux8_1 m0(.out(v[0]), .in(in[7:0]), .sel(sel[2:0]));
	mux8_1 m1(.out(v[1]), .in(in[15:8]), .sel(sel[2:0]));
	mux8_1 m2(.out(v[2]), .in(in[23:16]), .sel(sel[2:0]));
	mux8_1 m3(.out(v[3]), .in(in[31:24]), .sel(sel[2:0]));
	mux4_1 m4(.out(out), .in(v[3:0]), .sel(sel[4:3]));

endmodule 

module mux32_1_testbench();
		logic [31:0]in; 
		logic [4:0]sel;
		logic out;
		
		mux32_1 dut (.out, .in, .sel);
		
		integer i;
		initial begin
			in <= 0;
			sel <= 0;
			out <=0;
			for(i=0; i<32; i++) begin
					{sel[4:0]} = i; #10;
					in <= 32'b00000000000000000000000000000000; #1000;
					in <= 32'b01010101010101010101010101010101; #1000;
					in <= 32'b10101010101010101010101010101010; #1000;
					in <= 32'b00000000000000001111111111111111; #1000;
					in <= 32'b11111111111111110000000000000000; #1000;	
			end
			$stop;
		end
endmodule