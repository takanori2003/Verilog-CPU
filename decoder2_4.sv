`timescale 1ns/10ps
module decoder2_4(out, in, enable);
	input logic [1:0]in;
	input logic enable;
	output logic [3:0]out;
	logic [1:0]Nin;
	//logic Nen;
	
	not #50 not0(Nin[0], in[0]);
	not #50 not1(Nin[1], in[1]);
	//not #50 not2(Nen, enable);
	and #50 nand0(out[0], Nin[0], Nin[1], enable);
	and #50 nand1(out[1], Nin[0], in[1], enable);
	and #50 nand2(out[2], in[0], Nin[1], enable);
	and #50 nand3(out[3], in[0], in[1], enable);
	
endmodule