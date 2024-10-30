module ID_EX_Register(Rd_ALU_mux_EX, Rd1_Reg_out_EX, Rn_EX, Rm_EX, Rd_EX,  
							 MemtoReg_EX, MemWrite_EX, Reg2PC_EX, enable_EX, RegWrite_EX, ALUOp_EX,
							 Uncondbranch_EX, Branch_EX, MemRead_EX, 
							 Rd_ALU_mux_ID, Rd1_Reg_out_ID, Rn_ID, Rm_ID, Rd_ID,
							 Uncondbranch_ID, Branch_ID, MemRead_ID, 
							 MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, RegWrite_ID, ALUOp_ID, reset, clk);
	//controls needs to be added
	
	output logic [4:0] Rn_EX, Rm_EX, Rd_EX; 
	output logic [63:0] Rd_ALU_mux_EX, Rd1_Reg_out_EX;
	output logic Uncondbranch_EX, Branch_EX, MemRead_EX, 
			MemtoReg_EX, MemWrite_EX, Reg2PC_EX, enable_EX, RegWrite_EX;
	output logic [2:0] ALUOp_EX;
	
	input logic [4:0] Rn_ID, Rm_ID, Rd_ID; 
	input logic [63:0] Rd_ALU_mux_ID, Rd1_Reg_out_ID;
	input logic Uncondbranch_ID, Branch_ID, MemRead_ID, 
			MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, RegWrite_ID;
	input logic [2:0] ALUOp_ID;
	input logic reset, clk;
	
	
	adjustRegister #(5) adjReg0 (.out(Rn_EX), .in(Rn_ID), .reset, .clk);
	adjustRegister #(5) adjReg1 (.out(Rm_EX), .in(Rm_ID), .reset, .clk);
	adjustRegister #(5) adjReg2 (.out(Rd_EX), .in(Rd_ID), .reset, .clk);
	adjustRegister #(64) adjReg3(.out(Rd_ALU_mux_EX), .in(Rd_ALU_mux_ID), .reset, .clk);
	adjustRegister #(64) adjReg4(.out(Rd1_Reg_out_EX), .in(Rd1_Reg_out_ID), .reset, .clk);
	
	//controls
	oneRegister Reg0 (.out(Uncondbranch_EX), .in(Uncondbranch_ID), .reset, .clk);
	oneRegister Reg1  (.out(Branch_EX), .in(Branch_ID), .reset, .clk);
	oneRegister Reg2 (.out(MemRead_EX), .in(MemRead_ID), .reset, .clk);
	oneRegister Reg3 (.out(MemtoReg_EX), .in(MemtoReg_ID), .reset, .clk);
	oneRegister Reg4 (.out(MemWrite_EX), .in(MemWrite_ID), .reset, .clk);
	oneRegister Reg5 (.out(Reg2PC_EX), .in(Reg2PC_ID), .reset, .clk);
	oneRegister Reg6 (.out(enable_EX), .in(enable_ID), .reset, .clk);
	oneRegister Reg7 (.out(RegWrite_EX), .in(RegWrite_ID), .reset, .clk);
	adjustRegister #(3) adjReg5 (.out(ALUOp_EX), .in(ALUOp_ID), .reset, .clk);
	
	
endmodule
