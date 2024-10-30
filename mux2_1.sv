`timescale 1ns/10ps
module mux2_1(out, in, sel);
		output logic out;
		input logic [1:0]in;
		input logic sel;
		logic nsel;
		logic andOut0, andOut1;
		
		not #50 not0(nsel, sel); 
		and #50 and0(andOut0, in[0], nsel);
		and #50 and1(andOut1, in[1], sel);
		or #50 or0(out, andOut0, andOut1);
endmodule

module mux2_1_testbench();
		logic [1:0]in;
		logic sel;
		logic out;
		
		mux2_1 dut (.out, .in, .sel);
		
		initial begin 
				sel=0; in[0]=0; in[1]=0; #1000;
				sel=0; in[0]=0; in[1]=1; #1000;
				sel=0; in[0]=1; in[1]=0; #1000;
				sel=0; in[0]=1; in[1]=1; #1000;
				sel=1; in[0]=0; in[1]=0; #1000;
				sel=1; in[0]=0; in[1]=1; #1000;
				sel=1; in[0]=1; in[1]=0; #1000;
				sel=1; in[0]=1; in[1]=1; #1000;
		end 
endmodule