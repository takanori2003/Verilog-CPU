`timescale 1ns/10ps
module adjustRegister #(parameter size = 64)(out, in, reset, clk);
	input logic [size-1:0]in;
	input logic clk, reset;
	output logic [size-1:0]out;
	
	genvar i;
	generate 
		for(i=0; i<size; i++) begin : regi
			D_FF flipflop(.q(out[i]), .d(in[i]), .reset, .clk(clk));
		end
	endgenerate
endmodule

//module adjustRegister_testbench();
//		logic [63:0]in; 
//		logic enable;
//		logic [63:0]out;
//		logic clock;
//		
//		// Set up a simulated clock.
//	parameter CLOCK_PERIOD=1000;
//	initial begin
//		clock <= 0;
//		forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
//	end
//		
//		adjustRegister dut (.out, .in, .reset, .clk);
//		
//		integer i;
//		initial begin
//			in <= 0;
//			enable <= 0;
//			out <= 0;
//			for(i=0; i<64; i++) begin
//					{in[63:0]} = i; #2000;
//			end
//			in <= 0;
//			enable <= 1;
//			for(i=0; i<64; i++) begin
//					{in[63:0]} = i; #2000;
//			end
//			$stop;
//		end
//endmodule
//	