`timescale 1ns/10ps
module decoder3_8(out, in, enable);
	input logic [2:0]in;
	input logic enable;
	output logic [7:0]out;
	logic [2:0]Nin;
	
	not #50 not0(Nin[0], in[0]);
	not #50 not1(Nin[1], in[1]);
	not #50 not2(Nin[2], in[2]);
	and #50 and0(out[0], Nin[0], Nin[1], Nin[2], enable);
	and #50 and1(out[1],  in[0], Nin[1], Nin[2], enable);
	and #50 and2(out[2], Nin[0],  in[1], Nin[2], enable);
	and #50 and3(out[3],  in[0],  in[1], Nin[2], enable);
	and #50 and4(out[4], Nin[0], Nin[1],  in[2], enable);
	and #50 and5(out[5],  in[0], Nin[1],  in[2], enable);
	and #50 and6(out[6], Nin[0],  in[1],  in[2], enable);
	and #50 and7(out[7],  in[0],  in[1],  in[2], enable);
	
endmodule