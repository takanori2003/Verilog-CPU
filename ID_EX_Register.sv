`timescale 1ns/10ps

module ID_EX_Register(Rd_ALU_mux_EX, Rd1_Reg_out_EX, Rn_EX, Rm_EX, Rd_EX, Rd2_Reg_out_EX, Add_4_EX, Reg2Loc_EX,
							 MemtoReg_EX, MemWrite_EX, Reg2PC_EX, enable_EX, RegWrite_EX, ALUOp_EX, Add2Reg_EX, SignExtend_EX, ALUSrc_EX,
							 Write_Data_EX, Add_offset_EX, Uncondbranch_EX, Branch_EX, MemRead_EX, BranchDFF_EX, 
							 Rd_ALU_mux_ID, Rd1_Reg_out_ID, Rn_ID, Rm_ID, Rd_ID, Rd2_Reg_out_ID, Reg2Loc,
							 Write_Data_ID, Add_offset_ID,  Uncondbranch_ID, Branch_ID, MemRead_ID, Add_4_ID,
							 MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, RegWrite_ID, ALUOp_ID, BranchDFF,
							 Add2Reg_ID, SignExtend_ID, ALUSrc_ID, reset, clk);
	//controls needs to be added
	//Rd2_Reg_out_EX
	//Rd1_Reg_out_EX
	
	output logic [4:0] Rn_EX, Rm_EX, Rd_EX; 
	output logic [63:0] Rd_ALU_mux_EX, Rd1_Reg_out_EX, Rd2_Reg_out_EX, SignExtend_EX, 
								Write_Data_EX, Add_offset_EX, Add_4_EX;//Rd_ALU_mux_EX
	output logic Uncondbranch_EX, Branch_EX, MemRead_EX, BranchDFF_EX, Reg2Loc_EX,
			MemtoReg_EX, MemWrite_EX, Reg2PC_EX, enable_EX, RegWrite_EX, Add2Reg_EX, ALUSrc_EX;
	output logic [2:0] ALUOp_EX;
	
	input logic [4:0] Rn_ID, Rm_ID, Rd_ID; 
	input logic [63:0] Rd_ALU_mux_ID, Rd1_Reg_out_ID, Rd2_Reg_out_ID, SignExtend_ID, 
								Add_4_ID, Write_Data_ID, Add_offset_ID;
	input logic Uncondbranch_ID, Branch_ID, MemRead_ID, BranchDFF, Reg2Loc,
			MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, RegWrite_ID, Add2Reg_ID, ALUSrc_ID;
	input logic [2:0] ALUOp_ID;
	input logic reset, clk;
	
	
	adjustRegister #(5) adjReg0 (.out(Rn_EX), .in(Rn_ID), .reset, .clk);
	adjustRegister #(5) adjReg1 (.out(Rm_EX), .in(Rm_ID), .reset, .clk);
	adjustRegister #(5) adjReg2 (.out(Rd_EX), .in(Rd_ID), .reset, .clk);
	adjustRegister #(64) adjReg3(.out(Rd_ALU_mux_EX), .in(Rd_ALU_mux_ID), .reset, .clk);
	adjustRegister #(64) adjReg4(.out(Rd1_Reg_out_EX), .in(Rd1_Reg_out_ID), .reset, .clk);
	adjustRegister #(64) adjReg5(.out(Rd2_Reg_out_EX), .in(Rd2_Reg_out_ID), .reset, .clk);
	adjustRegister #(64) adjReg6(.out(SignExtend_EX), .in(SignExtend_ID), .reset, .clk);
	adjustRegister #(64) adjReg7(.out(Write_Data_EX), .in(Write_Data_ID), .reset, .clk);
	adjustRegister #(64) adjReg8(.out(Add_offset_EX), .in(Add_offset_ID), .reset, .clk);
	adjustRegister #(64) adjReg10(.out(Add_4_EX), .in(Add_4_ID), .reset, .clk);
	
	//controls
	oneRegister Reg0 (.out(Uncondbranch_EX), .in(Uncondbranch_ID), .reset, .clk);
	oneRegister Reg1  (.out(Branch_EX), .in(Branch_ID), .reset, .clk);
	oneRegister Reg2 (.out(MemRead_EX), .in(MemRead_ID), .reset, .clk);
	oneRegister Reg3 (.out(MemtoReg_EX), .in(MemtoReg_ID), .reset, .clk);
	oneRegister Reg4 (.out(MemWrite_EX), .in(MemWrite_ID), .reset, .clk);
	oneRegister Reg5 (.out(Reg2PC_EX), .in(Reg2PC_ID), .reset, .clk);
	oneRegister Reg6 (.out(enable_EX), .in(enable_ID), .reset, .clk);
	oneRegister Reg7 (.out(RegWrite_EX), .in(RegWrite_ID), .reset, .clk);
	oneRegister Reg8 (.out(Add2Reg_EX), .in(Add2Reg_ID), .reset, .clk);
	oneRegister Reg9 (.out(ALUSrc_EX), .in(ALUSrc_ID), .reset, .clk);
	oneRegister Reg10 (.out(BranchDFF_EX), .in(BranchDFF), .reset, .clk);
	oneRegister Reg11 (.out(Reg2Loc_EX), .in(Reg2Loc), .reset, .clk);


	adjustRegister #(3) adjReg9 (.out(ALUOp_EX), .in(ALUOp_ID), .reset, .clk);
	
	
endmodule

