`timescale 1ns/10ps
module CPU_pipeline(clk, reset, test_selector);
	input logic clk, reset;
	input logic [3:0] test_selector;
	logic [31:0] Inst_IF, Inst_ID;
	logic [63:0] Add_4_IF, Rd2_Reg_out, PC_out_ID, Add_4_ID, 
			PC_out_IF, Rd1_Reg_out_ID, Rd_ALU_mux_ID,
			Mux_Reg, Rd_ALU_mux_EX, Rd1_Reg_out_EX, address_EX,
			address_MEM, ReadData_MEM, ReadData_WB, address_WB, Add_4_EX,
			Rd2_Reg_out_ID, Rd2_Reg_out_MEM, Rd2_Reg_out_EX, Add_offset_ID,
			Add_offset_EX, Add_offset_MEM, Add_offset_WB, BLaddress;
	logic [63:0] Mux_Reg_IMD, ImdRegData_result, Add_4_MEM, Add_4_WB;

	
	logic [4:0] Rn_EX, Rm_EX, Rd_EX, Rd_MEM, Rd_WB;
	logic [4:0] Rn_ID, Rm_ID, Rd_ID; 
	///control
	logic Reg2PC, BranchSig, Uncondbranch_ID, Branch_ID, MemRead_ID, 
			MemtoReg_ID, MemWrite_ID, Reg2PC_ID, enable_ID, Uncondbranch_EX,
			Branch_EX, MemRead_EX, MemtoReg_EX, MemWrite_EX, Reg2PC_EX, enable_EX,
			RegWrite_ID, MemWrite_MEM, RegWrite_WB, MemtoReg_WB, RegWrite_EX, 
			MemtoReg_MEM, RegWrite_MEM, MemRead_MEM, Reg2Loc_EX; //1'b control
	logic negativeFlag, overflowFlag, BranchDFF_EX; //flags
	logic [2:0] ALUOp_ID, ALUOp_EX;
	logic [1:0] forward1, forward2;
	logic [4:0]Rd_IMD;
	
///////////Instruction Fetch stage//////////////////////////////////////////////////////////////////////////////////
	logic [63:0] PC_in, c_out1, Add_PC;
	
	logic [63:0] Add_mux [1:0];
	logic [63:0] Reg2PC_mux [1:0];
	
	logic [63:0] BL_mux [1:0];
	assign BL_mux[0] = Add_offset_ID;
	assign BL_mux[1] = Add_offset_WB;
	mux2_1x64 BLmux(.out(BLaddress), .in(BL_mux), .sel(BranchDFF_MEM));
	
	assign Add_mux[0] = Add_4_IF;
	assign Add_mux[1] = Add_offset_ID;
	mux2_1x64 mux3(.out(Add_PC), .in(Add_mux), .sel(BranchSig));//the mux between Adder and mux before PC
	
	assign Reg2PC_mux[0]= Add_PC;
	assign Reg2PC_mux[1]= Rd2_Reg_out_ID;
	mux2_1x64 mux0(.out(PC_in), .in(Reg2PC_mux), .sel(Reg2PC_EX));//mux between PC and another mux
	
	pc PC(.in(PC_in), .out(PC_out_IF), .clk, .reset);
	add_64 add_4(.s(Add_4_IF), .A(PC_out_IF), .B(64'd4), .cntl(1'b0), .c_out(c_out1));
	instructmem instr(.address(PC_out_IF), .instruction(Inst_IF), .clk, .test_selector);
	
/////////Istruction Fetch to Instruction Decoder register stage//////////////////////////////////////////////////////
	IF_ID_Register Reg0(.Inst_ID, .PC_out_ID, .Add_4_ID, .Inst_IF, .PC_out_IF, .Add_4_IF, .clk, .reset);
///////////////////Instruction Decoder stage ///////////////////////////////////////////////////////////////
	logic zero;
	logic [63:0] Write_Data_ID, Write_Data_EX;
	logic andR0, xBranchDFF, andR1, BranchDFF,  andR2, xorR1, andR3, orR1;//xBranchDFF replaced xorR0
	logic [2:0] signEx;
	logic  Add2Reg, ALUSrc, Reg2Loc, Add2Reg_ID;//controls only used in ID stage
	logic [31:0] sign_mux_out;
	logic [63:0] SignExtend_ID, shifted, c_out2;
	logic [63:0] ALUSrc_mux [1:0];
	logic [4:0] Rd2_in;
	logic [4:0] WriteReg_in;
	logic contCBZ, contBLT, Add2Reg_EX; //not used
	logic negative, overflow, carry_out;
	assign Rn_ID = Inst_ID[9:5];
	assign Rm_ID = Rd2_in;
	assign Rd_ID = Inst_ID[4:0];																																		
																																/*	_________________
																																	| control signal|
																																	|_______________|*/ 
	control cntl(.Opcode(Inst_ID[31:21]), .Reg2Loc, 
			.Uncondbranch(Uncondbranch_ID), .Branch(Branch_ID), .MemRead(MemRead_ID), 
			.MemtoReg(MemtoReg_ID), .ALUOp(ALUOp_ID), .MemWrite(MemWrite_ID), .ALUSrc(ALUSrc_ID), .RegWrite(RegWrite_ID), .contCBZ, 
			.contBLT, .Reg2PC(Reg2PC_ID), .Add2Reg(Add2Reg_ID), .enable(enable_ID), .signEx);
	// need to check if the enable flag is true 

			
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
	signExtension signE(.in(sign_mux_out), .out(SignExtend_ID));
	shiftLeft shift(.in(SignExtend_ID), .out(shifted));
	add_64 addOff(.s(Add_offset_ID), .A(shifted), .B(PC_out_ID), .cntl(1'b0), .c_out(c_out2));//output sent back to IF stage
	
	logic [1:0]Branch_Sig_mux;
	zeroIden zeros(.result(Rd2_Reg_out_ID), .zero);
	and #50 and0(andR0, xBranchDFF, Branch_ID, contBLT);
	or  #50 or0(BranchDFF, andR0, Uncondbranch_ID, andR1);
	//xort gate for the Br
	and #50 and1(andR1, zero, Branch_ID, contCBZ);
	xor #50 xor0(xBranchDFF, negativeFlag, overflowFlag); //negative and Overflow
	
	// for the secnd 
	and #50 and2(andR2, xorR1, Branch_ID, contBLT);
	or  #50 or1(orR1, andR0, Uncondbranch_ID, andR1);
	//xort gate for the Br
	and #50 and3(andR3, zero, Branch_ID, contCBZ);
	xor #50 xor1(xorR1, negative, overflow);
	
	assign Branch_Sig_mux[0] = BranchDFF;
	assign Branch_Sig_mux[1] = orR1;
	mux2_1 mux_Branch(.out(BranchSig), .in(Branch_Sig_mux), .sel(enable_EX));
	
	logic [4:0] Reg2Loc_mux [1:0];
	logic [4:0] WriteReg_mux [1:0];
	
	assign Reg2Loc_mux[1] = Rd_ID;//[4:0];
	assign Reg2Loc_mux[0] = Inst_ID[20:16];
	mux2_1x5 mux1(.out(Rd2_in), .in(Reg2Loc_mux), .sel(Reg2Loc));// mux from Inst_IDruction to reg
	
	assign WriteReg_mux[0] = Rd_WB;//Inst[4:0];
	assign WriteReg_mux[1] = 5'b11110;//for BL
	mux2_1x5 mux7(.out(WriteReg_in), .in(WriteReg_mux), .sel(Add2Reg_WB));//mux before Write Reg
	
	//for branch changing the regwrite data
//	logic [63:0] Write_Data_BL [1:0];
//	assign Write_Data_BL[1] = Mux_Reg_IMD;
//	assign Write_Data_BL[0] = Write_Data_ID;
//	mux2_1x64 WDBL(.out(WriteData_BL), .in(Write_Data_BL), .sel(Add2Reg_WB));
	
	regfile register(.ReadRegister1(Inst_ID[9:5]), .ReadRegister2(Rd2_in), 
							.WriteRegister(WriteReg_in), .WriteData(Write_Data_ID), 
							.RegWrite(RegWrite_WB), .ReadData1(Rd1_Reg_out_ID), 
							.ReadData2(Rd2_Reg_out_ID), .clk);
	//mux from register and ID/EX register
	/* maybe move to EX stage
	assign ALUSrc_mux[0] = Rd2_Reg_out_ID;
	assign ALUSrc_mux[1] = SignExtend_ID;
	mux2_1x64 mux4(.out(Rd_ALU_mux_ID), .in(ALUSrc_mux), .sel(ALUSrc_EX));//mux between register and alu*/
	
	logic [63:0] RC2Reg_mux [1:0];
	assign RC2Reg_mux[0] = Mux_Reg;//from the MemToReg mux
	assign RC2Reg_mux[1] = Add_4_WB;
	mux2_1x64 mux2(.out(Write_Data_ID), .in(RC2Reg_mux), .sel(Add2Reg_WB));
	
	logic ALUSrc_EX;
	logic [63:0] SignExtend_EX;
//////////////////////////Instruction Decoder to Execution Fetch stage register////////////////////////////////////////////////////////
	ID_EX_Register Reg1(.Rd_ALU_mux_EX, .Rd1_Reg_out_EX, .Rn_EX, .Rm_EX, .Rd_EX, .Rd2_Reg_out_EX, .Add_4_EX, .Reg2Loc_EX,
				.MemtoReg_EX, .MemWrite_EX, .Reg2PC_EX, .enable_EX, .RegWrite_EX, .ALUOp_EX, .Add2Reg_EX, 
				.SignExtend_EX, .ALUSrc_EX, .Write_Data_EX, .Add_offset_EX, .Uncondbranch_EX, .Branch_EX, .MemRead_EX, .BranchDFF_EX,
				.Rd_ALU_mux_ID, .Rd1_Reg_out_ID, .Rn_ID, .Rm_ID, .Rd_ID, .Rd2_Reg_out_ID, 
				.Uncondbranch_ID, .Branch_ID, .MemRead_ID, .MemtoReg_ID, .MemWrite_ID, .Reg2PC_ID, .Add_4_ID, .Reg2Loc,
				.enable_ID, .RegWrite_ID, .ALUOp_ID, .Add2Reg_ID, .SignExtend_ID, .ALUSrc_ID, .Write_Data_ID, .Add_offset_ID, .BranchDFF, .reset(1'b0), .clk);
////////////Executation stage ///////////////////////////////////////////////////////////////////////////////////////////
	logic zeroFlag, carry_outFlag;
	logic [63:0] mux4_A_in [3:0];
	logic [63:0] mux4_B_in [3:0];
	logic [63:0] mux4_A_out, mux4_B_out_EX;
	logic zero_ALU, Add2Reg_MEM, ImdRegData, RegWrite_IMD;
	logic [63:0] resultALU [1:0];
	logic [63:0]result;
	
	assign mux4_A_in[0] = Rd1_Reg_out_EX;//wrtie data
	assign mux4_A_in[1] = Mux_Reg;
	assign mux4_A_in[2] = address_MEM;
	assign mux4_A_in[3] = Write_Data_EX;
	mux4_1x64 mux4_A (.out(mux4_A_out), .in(mux4_A_in), .sel(forward1));
	
	assign mux4_B_in[0] = Rd2_Reg_out_EX;//Rd_ALU_mux_EX;//0
	assign mux4_B_in[1] = Mux_Reg;//writedata
	assign mux4_B_in[2] = address_MEM;
	assign mux4_B_in[3] = Write_Data_EX;
	mux4_1x64 mux4_B(.out(mux4_B_out_EX), .in(mux4_B_in), .sel(forward2));
	
	/*
	logic [63:0]ImdRegData_mux[1:0];
	assign ImdRegData_mux[0] = mux4_B_out_EX;
	assign ImdRegData_mux[1] = Write_Data_EX;
	mux2_1x64 mux_imd(.out(ImdRegData_result), .in(ImdRegData_mux), .sel(ImdRegData));
	*/
	
	logic [63:0] Rd_ALU_mux;
	assign ALUSrc_mux[0] = mux4_B_out_EX;//;ImdRegData_result
	assign ALUSrc_mux[1] = SignExtend_EX;
	mux2_1x64 mux4(.out(Rd_ALU_mux), .in(ALUSrc_mux), .sel(ALUSrc_EX));
	
	//add to EX
	alu al(.A(mux4_A_out), .B(Rd_ALU_mux), .cntrl(ALUOp_EX), .
		result, .negative, .zero(zero_ALU), .overflow, .carry_out);
		
	assign resultALU[0] = result;
	assign resultALU[1] = Add_4_EX;
	mux2_1x64 aluR(.out(address_EX), .in(resultALU), .sel(Add2Reg_EX));
		
	enableDff en0(.out(negativeFlag), .in(negative), .enable(enable_EX), .clk, .reset);
	enableDff en1(.out(zeroFlag), .in(zero_ALU), .enable(enable_EX), .clk, .reset);
	enableDff en2(.out(overflowFlag), .in(overflow), .enable(enable_EX), .clk, .reset);
	enableDff en3(.out(carry_outFlag), .in(carry_out), .enable(enable_EX), .clk, .reset);
///////////////////Execution to memory stage register/////////////////////////////////////////////////////////
	EX_MEM_Register Reg2(.address_MEM, .Rd2_Reg_out_MEM, .RegWrite_MEM, .MemtoReg_MEM, .MemRead_MEM,
		.Rd_MEM, .MemWrite_MEM, .Add2Reg_MEM, .Add_offset_MEM, .BranchDFF_MEM, .Add_4_MEM,
		.address_EX, .Rd2_Reg_out_EX, .BranchDFF_EX, .Add_4_EX, 
		.RegWrite_EX, .MemtoReg_EX, .MemRead_EX, .Rd_EX, .MemWrite_EX, .Add2Reg_EX, .Add_offset_EX, .clk, .reset);
	//Memory stage ////////////////////////////////////////////////////////////////////////////
	datamem Data(.address(address_MEM), .write_enable(MemWrite_MEM), .read_enable(MemRead_MEM), 
						.write_data(Rd2_Reg_out_MEM), .clk, .xfer_size(4'b1000), .read_data(ReadData_MEM));
////////////////////////memory to write back stage register///////////////////////////////////////////////////////
	MEM_WB_Register Reg3(.ReadData_WB, .address_WB, .RegWrite_WB, .MemtoReg_WB, .Rd_WB, .Add2Reg_WB, .Add_offset_WB, .Add_4_WB,
			.ReadData_MEM, .address_MEM, .RegWrite_MEM, .MemtoReg_MEM, .Rd_MEM, .Add2Reg_MEM, .Add_offset_MEM, .Add_4_MEM, .clk, .reset);
/////Write back statge/////////////////////////////////////////////////////////////////////////////////////////// 
	logic [63:0] MenReg_mux [1:0];
	assign MenReg_mux[1] = ReadData_WB;
	assign MenReg_mux[0] = address_WB;
	mux2_1x64 mux5(.out(Mux_Reg), .in(MenReg_mux), .sel(MemtoReg_WB));//mux between data mem to reg
/////////////////////////////////Forward Unit///////////////////////////////////////////////////////////////////
	forward_Unit forward(.forward1, .forward2, .Rn_EX, .Rm_EX, .Rd_EX, .Rd_MEM, .Rd_WB, .RegWrite_MEM, 
								.RegWrite_WB, .Rd_IMD, .RegWrite_IMD);
/////Extra register ///////////////////////////////////////////////////////////
	
	WB_IMD Reg4(.Mux_Reg, .Rd_WB, .RegWrite_WB, .Mux_Reg_IMD, .Rd_IMD, .RegWrite_IMD, .clk, .reset);
	match check(.ImdRegData, .Rd_IMD, .Rm_EX, .RegWrite_IMD);
	
endmodule

module CPU_pipeline_testbench ();

		// define signals
	logic clk, reset;
	logic [3:0]  test_selector;

	
	// instantiate modules
	CPU_pipeline dut (.*);
	
	// set up the clock
	parameter CLOCK_PERIOD=100000;
	initial begin
	 clk <= 0;
	 forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end
	
	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	
	initial begin
		$display("Running benchmark: test01_ADDI");
		test_selector <= 4'd1; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
									  
		$display("Running benchmark: test02_LDUR_STUR");
		test_selector <= 4'd2; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test03_B");
		test_selector <= 4'd3; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test04_CBZ");
		test_selector <= 4'd4; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test05_SUBS_ADDS_BLT");
		test_selector <= 4'd5; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test06_BR");
		test_selector <= 4'd6; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$display("Running benchmark: test07_BR_fwd");
		test_selector <= 4'd7; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test08_BLT_delay");
		test_selector <= 4'd8; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test09_not_fwd_inst");
		test_selector <= 4'd9; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test10_BL");
		test_selector <= 4'd10; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test11_fwd");
		test_selector <= 4'd11; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);

		$display("Running benchmark: test12_not_fwd_31");
		test_selector <= 4'd12; reset <= 1; @(posedge clk);
		                       reset <= 0; @(posedge clk);
								     for (i=0; i < 15; i++) begin
											@(posedge clk);
									  end
				                 reset <= 1; @(posedge clk);
		
		$stop;  // pause the simulation
	end
endmodule
	
	 
