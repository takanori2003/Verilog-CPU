`timescale 1ns/10ps

module match(ImdRegData, Rd_IMD, Rm_EX, RegWrite_IMD);
	input logic [4:0]Rd_IMD, Rm_EX;
	input logic RegWrite_IMD;
	output logic ImdRegData;
	logic [4:0] comp0;
	logic andR;
	
	genvar i;
	generate
	for (i = 0; i < 5; i++) begin : loop0
		xnor #50 xnor0(comp0[i], Rd_IMD[i], Rm_EX[i]);
		end
	endgenerate 
	and #50 and6(andR, comp0[0], comp0[1], comp0[2]);
	and #50 and7(ImdRegData, andR, comp0[4], RegWrite_IMD);
endmodule