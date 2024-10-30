`timescale 1ns/10ps

module MEM (ReadData_MEM, address_MEM, Rd2_Reg_out_MEM, MemRead_MEM, MemWrite_MEM, clk);
	output logic [63:0] ReadData_MEM;
	//input logic [4:0]Rd;
	input logic [63:0] address_MEM, Rd2_Reg_out_MEM;
	input logic MemRead_MEM, MemWrite_MEM, clk;

	//add to MEM
	datamem Data(.address(address_MEM), .write_enable(MemWrite_MEM), .read_enable(MemRead_MEM), 
						.write_data(Rd2_Reg_out_MEM), .clk, .xfer_size(4'b1000), .read_data(ReadData_MEM));

endmodule
