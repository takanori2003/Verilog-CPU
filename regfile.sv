`timescale 1ns/10ps
module regfile(ReadRegister1, ReadRegister2, WriteRegister, WriteData, RegWrite, ReadData1, ReadData2, clk);
	input logic clk;
	input logic [4:0] ReadRegister1, ReadRegister2, WriteRegister;
	input logic [63:0] WriteData;
	input logic RegWrite;
	output logic [63:0] ReadData1, ReadData2;
	
//	assgin register 31 to be 0 here by usign assgin register[31] = 0;
	
	logic [30:0] enregisters;
	logic [63:0] resreg[31:0];
	
	
	decoder dec(.Register(enregisters), .RegWrite, .WriteReg(WriteRegister));
	assign resreg[31] = 0;
	genvar j;
	generate
		for (j = 0; j < 31; j++) begin : regis
        	register regs(.out(resreg[j]), .in(WriteData), .enable(enregisters[j]), .clock(clk));

		end
	endgenerate
	
	genvar i,z;
	generate
		for (i = 0; i < 64; i++) begin : mux64_32
			logic [31:0] resregOut;
			for (z = 0; z < 32 ; z++) begin : loop
				assign resregOut[z] = (resreg[z][i]);
			end 
        mux32_1 mux_1_64_32 (.out(ReadData1[i]), .in(resregOut), .sel(ReadRegister1));
		  mux32_1 mux_2_64_32 (.out(ReadData2[i]), .in(resregOut), .sel(ReadRegister2));
		end
	endgenerate
	
endmodule 