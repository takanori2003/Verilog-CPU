module EX_MEM_Register(address_MEM, Rd_ALU_mux_MEM, RegWrite_MEM, MemtoReg_MEM, MemRead_MEM,
		Rd_MEM, MemWrite_MEM, address_EX,Rd_ALU_mux_EX, RegWrite_EX, MemtoReg_EX, MemRead_EX, Rd_EX, MemWrite_EX, clk, reset);
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
	
	output logic [63:0] address_MEM, Rd_ALU_mux_MEM;
	output logic RegWrite_MEM, MemtoReg_MEM, MemRead_MEM, MemWrite_MEM;
	output logic [4:0] Rd_MEM;
	input logic  [63:0] address_EX,Rd_ALU_mux_EX;
	input logic RegWrite_EX, MemtoReg_EX, MemRead_EX, MemWrite_EX;
	input logic [4:0] Rd_EX;
	input logic clk, reset;
	
	adjustRegister  #(64) adjReg0 (.out(Address_MEM), .in(Address_EX), .reset, .clk);
	adjustRegister  #(64) adjReg1 (.out(Rd_ALU_mux_MEM), .in(Rd_ALU_mux_EX), .reset, .clk);
	
	//controls
	oneRegister Reg0(.out(RegWrite_MEM), .in(RegWrite_EX), .reset, .clk);
	oneRegister Reg1(.out(MemtoReg_MEM), .in(MemtoReg_EX), .reset, .clk);
	oneRegister Reg2(.out(MemRead_MEM), .in(MemRead_EX), .reset, .clk);
	oneRegister Reg3(.out(MemWrite_MEM), .in(MemWrite_EX), .reset, .clk);

	
	adjustRegister #(5) adjReg2 (.out(Rd_MEM), .in(Rd_EX), .reset, .clk);
endmodule
	
