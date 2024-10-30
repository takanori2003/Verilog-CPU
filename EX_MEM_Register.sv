`timescale 1ns/10ps

module EX_MEM_Register(address_MEM, Rd2_Reg_out_MEM, RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, Add_offset_MEM, Add_4_MEM,
		Rd_MEM, MemWrite_MEM, BranchDFF_MEM, Add2Reg_MEM, Add_offset_EX, BranchDFF_EX, Add_4_EX,
		address_EX, Rd2_Reg_out_EX, RegWrite_EX, MemtoReg_EX, MemRead_EX, Rd_EX, MemWrite_EX, 
		Add2Reg_EX, Add_offset_EX, clk, reset);
	//output 
	//RegWrite
	//Rd
	
	//control required only at this stage
	// MemRead
	//MemWrite
	//control to be passed
	//RegWrite
	//input data
	//address from ALU
	//Value of B into ALU 
	//Rd
	
	output logic [63:0] address_MEM, Rd2_Reg_out_MEM, Add_offset_MEM, Add_4_MEM;
	output logic RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM, Add2Reg_MEM, BranchDFF_MEM;
	output logic [4:0] Rd_MEM;
	input logic  [63:0] address_EX, Rd2_Reg_out_EX, Add_offset_EX, Add_4_EX;
	input logic RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX, Add2Reg_EX, BranchDFF_EX;
	input logic [4:0] Rd_EX;
	input logic clk, reset;
	
	adjustRegister  #(64) adjReg0 (.out(address_MEM), .in(address_EX), .reset, .clk);
	adjustRegister  #(64) adjReg1 (.out(Add_offset_MEM), .in(Add_offset_EX), .reset, .clk);
	adjustRegister  #(64) adjReg2 (.out(Rd2_Reg_out_MEM), .in(Rd2_Reg_out_EX), .reset, .clk);
	adjustRegister  #(64) adjReg3 (.out(Add_4_MEM), .in(Add_4_EX), .reset, .clk);
	
	//controls
	oneRegister Reg0(.out(RegWrite_MEM), .in(RegWrite_EX), .reset, .clk);
	oneRegister Reg1(.out(MemtoReg_MEM), .in(MemtoReg_EX), .reset, .clk);
	oneRegister Reg2(.out(MemRead_MEM), .in(MemRead_EX), .reset, .clk);
	oneRegister Reg3(.out(MemWrite_MEM), .in(MemWrite_EX), .reset, .clk);
	oneRegister Reg4(.out(Add2Reg_MEM), .in(Add2Reg_EX), .reset, .clk);
	oneRegister Reg5(.out(BranchDFF_MEM), .in(BranchDFF_EX), .reset, .clk);


	
	adjustRegister #(5) adjReg4 (.out(Rd_MEM), .in(Rd_EX), .reset, .clk);
endmodule
	
