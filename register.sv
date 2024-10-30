`timescale 1ns/10ps
module register (out, in, enable, clock);
	input logic [63:0]in;
	input logic clock, enable;
	output logic [63:0]out;
	
	//if the enable signal is on then the output should be same as input
	//if the enable signal is off then the output should not change
	logic nenable, andIn, andOut;
	not #50 not0(nenable, enable);
	genvar i;
	generate 
		for(i=0; i<64; i++) begin : regi
			logic [1:0]andre;
			logic orOut;
			and #50 and0(andre[0], enable, in[i]);
			and #50 and1(andre[1], nenable, out[i]);
			or #50 or0(orOut, andre[0], andre[1]);
			D_FF flipflop(.q(out[i]), .d(orOut), .reset(1'b0), .clk(clock));
		end
	endgenerate
endmodule

module register_testbench();
		logic [63:0]in; 
		logic enable;
		logic [63:0]out;
		logic clock;
		
		// Set up a simulated clock.
	parameter CLOCK_PERIOD=1000;
	initial begin
		clock <= 0;
		forever #(CLOCK_PERIOD/2) clock <= ~clock; // Forever toggle the clock
	end
		
		register dut (.out, .in, .enable, .clock);
		
		integer i;
		initial begin
			in <= 0;
			enable <= 0;
			out <= 0;
			for(i=0; i<64; i++) begin
					{in[63:0]} = i; #2000;
			end
			in <= 0;
			enable <= 1;
			for(i=0; i<64; i++) begin
					{in[63:0]} = i; #2000;
			end
			$stop;
		end
endmodule
	