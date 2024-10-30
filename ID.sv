`timescale 1ns/10ps
module ID(Add_offset, Rd1_Reg_out_ID, Rd_ALU_mux_ID, Rd2_Reg_out_ID, orR0, 
			Uncondbranch_ID, Branch_ID, MemRead_ID, Rn_ID, Rm_ID, Rd_ID, 
			MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, RegWrite_ID, ALUOp_ID,
			PC_out_ID, Inst_ID, Mux_Reg, Add_4_ID, negativeFlag,
			overflowFlag, clk, reset);
	//make sure to add more control signal here Rd2_Reg_out_ID
	output logic [4:0] Rn_ID, Rm_ID, Rd_ID; 
	output logic [63:0] Add_offset, Rd1_Reg_out_ID, Rd_ALU_mux_ID, Rd2_Reg_out_ID;
	output logic [2:0] ALUOp_ID;
	output logic orR0;//control to the gate
	output logic Uncondbranch_ID, Branch_ID, MemRead_ID, 
			MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, RegWrite_ID;
	
	input logic clk, reset;
	input logic [31:0] Inst_ID;
	input logic [63:0] Mux_Reg, Add_4_ID, PC_out_ID;
	input logic negativeFlag, overflowFlag; 
	logic zero;
	logic [63:0] Write_Data;
	
	logic andR0, xorR0, andR1;
	logic [2:0] signEx;
	
	logic  Add2Reg, ALUSrc, Reg2Loc;//controls only used in ID stage
	logic [31:0] sign_mux_out;
	logic [63:0] SignExtend, shifted, c_out2;
	logic [63:0] ALUSrc_mux [1:0];
	logic [4:0] Rd2_in;
	logic [4:0] WriteReg_in;

	
	logic contCBZ, contBLT; //not used
	
	assign Rn_ID = Inst_ID[9:5];
	assign Rm_ID = Inst_ID[20:16];
	assign Rd_ID = Inst_ID[4:0];
	//ID stage
	control cntl(.Opcode(Inst_ID[31:21]), .Reg2Loc, 
			.Uncondbranch(Uncondbranch_ID), .Branch(Branch_ID), .MemRead(MemRead_ID), 
			.MemtoReg(MemtoReg_ID), .ALUOp(ALUOp_ID), .MemWrite(MemWrite_ID), .ALUSrc, .RegWrite(RegWrite_ID), .contCBZ, 
			.contBLT, .Reg2PC(Reg2PC_ID), .Add2Reg, .enable(enable_ID), .signEx);
	//(Opcode, Reg2Loc, Uncondbranch, Branch, MemRead, 
//MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, contCBZ, contBLT, Reg2PC, Add2Reg, enable, signEx);
/*(.Opcode(Inst[31:21]), .Reg2Loc, .Uncondbranch, .Branch, .MemRead, 
			.MemtoReg, .ALUOp, .MemWrite, .ALUSrc, .RegWrite, .contCBZ, 
			.contBLT, .Reg2PC, .Add2Reg, .enable, .signEx);*/
			
	//ID stage
	//000 - nothing, 001-I, 010-B, 011-CB, 100-D , 101-R
	logic [31:0] Sign_mux [7:0];
	assign Sign_mux[0] = 32'b0;
	assign Sign_mux[1] = {{20'b0}, Inst_ID[21:10]};//I
	assign Sign_mux[2] = {{6{Inst_ID[25]}}, Inst_ID[25:0]};//B
	assign Sign_mux[3] = {{13{Inst_ID[23]}}, Inst_ID[23:5]};//CB
	assign Sign_mux[4] = {{23{Inst_ID[20]}}, Inst_ID[20:12]};//D
	assign Sign_mux[5] = {{26{Inst_ID[15]}}, Inst_ID[15:10]};//R can this be just 32'b0?
	assign Sign_mux[6] = 32'b0;
	assign Sign_mux[7] = 32'b0;
	mux8_1x32 mux6(.out(sign_mux_out), .in(Sign_mux), .sel(signEx));
	signExtension signE(.in(sign_mux_out), .out(SignExtend));
	shiftLeft shift(.in(SignExtend), .out(shifted));
	add_64 add_Offset(.s(Add_offset), .A(shifted), .B(PC_out_ID), .cntl(1'b0), .c_out(c_out2));//output sent back to IF stage
	
	zeroIden zeros(.result(Rd2_Reg_out_ID), .zero);
	//not sure if this goes into ID or EX
	// create a logic gate for Alu_mux here
	and #50 and0(andR0, xorR0, Branch_ID, contBLT);
	or  #50 or0(orR0, andR0, Uncondbranch_ID, andR1);
	//xort gate for the Br
	and #50 and1(andR1, zero, Branch_ID, contCBZ);
	xor #50 xor0(xorR0, negativeFlag, overflowFlag); 
	
	logic [4:0] Reg2Loc_mux [1:0];
	logic [4:0] WriteReg_mux [1:0];
	
	assign Reg2Loc_mux[1] = Rd_ID;//[4:0];
	assign Reg2Loc_mux[0] = Rm_ID;//Inst_ID[20:16];
	mux2_1x5 mux1(.out(Rd2_in), .in(Reg2Loc_mux), .sel(Reg2Loc));// mux from Inst_IDruction to reg
	
	assign WriteReg_mux[0] = Rd_ID;//Inst[4:0];
	assign WriteReg_mux[1] = 5'b11110;//for BL
	mux2_1x5 mux7(.out(WriteReg_in), .in(WriteReg_mux), .sel(Add2Reg));//mux before Write Reg
	
	regfile register(.ReadRegister1(Inst_ID[9:5]), .ReadRegister2(Rd2_in), 
							.WriteRegister(WriteReg_in), .WriteData(Write_Data), 
							.RegWrite(RegWrite_ID), .ReadData1(Rd1_Reg_out_ID), 
							.ReadData2(Rd2_Reg_out_ID), .clk);
	
	//mux from register and ID/EX register
	assign ALUSrc_mux[0] = Rd2_Reg_out_ID;
	assign ALUSrc_mux[1] = SignExtend;
	mux2_1x64 mux4(.out(Rd_ALU_mux_ID), .in(ALUSrc_mux), .sel(ALUSrc));//mux between register and alu
	
	//ID stage
	logic [63:0] RC2Reg_mux [1:0];
	assign RC2Reg_mux[0] = Mux_Reg;//from the MemToReg mux
	assign RC2Reg_mux[1] = Add_4_ID;
	mux2_1x64 mux2(.out(Write_Data), .in(RC2Reg_mux), .sel(Add2Reg));
	
	
	//add hazard detection unit
endmodule
	