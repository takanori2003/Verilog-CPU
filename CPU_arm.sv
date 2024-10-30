`timescale 1ns/10ps
module CPU_arm (clk, reset);
	input logic clk, reset;
	logic [63:0]PC_in, PC_out, Add_4, Add_offset, Write_Data,
					Rd1_Reg_out, Rd2_Reg_out, SignExtend, Add_PC,
					Rd_Sign_Mux, address, Rd_mem, Rd_ALU_mux,
					Mux_Reg, c_out1, c_out2, shifted;
	logic [63:0]Reg2PC_mux[1:0];
	logic [63:0]RC2Reg_mux[1:0];
	logic [63:0]ALUSrc_mux[1:0];
	logic [63:0]Add_mux[1:0];
	logic [31:0]Sign_mux[7:0];
	logic [63:0]MenReg_mux[1:0];
	logic [4:0] WriteReg_mux[1:0];
	logic [4:0] Reg2Loc_mux[1:0];
	logic [4:0] WriteReg_in, Rd2_in; 
	logic 			Reg2Loc, 
						Uncondbranch,
						Branch, 
						MemRead, 
						MemtoReg,  
						MemWrite, 
						ALUSrc,	
						contCBZ,
						contBLT,
						RegWrite,
						Reg2PC,
						Add2Reg,
						enable;
	logic [2:0] ALUOp;
	logic [2:0] signEx;
	logic [31:0]Inst, sign_mux_out;
	logic andR0, orR0, xorR0, andR1;
	logic negative, zero, overflow, carry_out;
	logic negativeFlag, zeroFlag, overflowFlag, carry_outFlag;
	
//	//IF
//	assign Reg2PC_mux[0]= Add_PC;
//	assign Reg2PC_mux[1]= Rd2_Reg_out;
//	mux2_1x64 mux0(.out(PC_in), .in(Reg2PC_mux), .sel(Reg2PC));//mux between PC and another mux
//	//move to IF
//	pc PC(.in(PC_in), .out(PC_out), .clk, .reset);
//	add_64 add_4(.s(Add_4), .A(PC_out), .B(64'd4), .cntl(1'b0), .c_out(c_out1));
//	instructmem instr(.address(PC_out), .instruction(Inst), .clk);
	
	//ID stage
	control cntl(.Opcode(Inst[31:21]), .Reg2Loc, .Uncondbranch, .Branch, .MemRead, 
			.MemtoReg, .ALUOp, .MemWrite, .ALUSrc, .RegWrite, .contCBZ, 
			.contBLT, .Reg2PC, .Add2Reg, .enable, .signEx);
			
	//not sure if this goes into ID or EX
	// create a logic gate for Alu_mux here
	and #50 and0(andR0, xorR0, Branch, contBLT);
	or  #50 or0(orR0, andR0, Uncondbranch, andR1);
	//xort gate for the Br
	and #50 and1(andR1, zero, Branch, contCBZ);
	xor #50 xor0(xorR0, negativeFlag, overflowFlag); 
	
	//add in ID
	assign Reg2Loc_mux[1] = Inst[4:0];
	assign Reg2Loc_mux[0] = Inst[20:16];
	mux2_1x5 mux1(.out(Rd2_in), .in(Reg2Loc_mux), .sel(Reg2Loc));// mux from instruction to reg
	
	
	assign WriteReg_mux[0] = Inst[4:0];
	assign WriteReg_mux[1] = 5'b11110;//for BL
	mux2_1x5 mux7(.out(WriteReg_in), .in(WriteReg_mux), .sel(Add2Reg));//mux before Write Reg
	
	assign RC2Reg_mux[0] = Mux_Reg;
	assign RC2Reg_mux[1] = Add_4;
	mux2_1x64 mux2(.out(Write_Data), .in(RC2Reg_mux), .sel(Add2Reg));
	
	//ID stage
	//000 - nothing, 001-I, 010-B, 011-CB, 100-D , 101-R
	assign Sign_mux[0] = 32'b0;
	assign Sign_mux[1] = {{20'b0}, Inst[21:10]};//I
	assign Sign_mux[2] = {{6{Inst[25]}}, Inst[25:0]};//B
	assign Sign_mux[3] = {{13{Inst[23]}}, Inst[23:5]};//CB
	assign Sign_mux[4] = {{23{Inst[20]}}, Inst[20:12]};//D
	assign Sign_mux[5] = {{26{Inst[15]}}, Inst[15:10]};//R can this be just 32'b0?
	assign Sign_mux[6] = 32'b0;
	assign Sign_mux[7] = 32'b0;
	mux8_1x32 mux6(.out(sign_mux_out), .in(Sign_mux), .sel(signEx));
	signExtension signE(.in(sign_mux_out), .out(SignExtend));
	shiftLeft shift(.in(SignExtend), .out(shifted));
	add_64 add_Offset(.s(Add_offset), .A(shifted), .B(PC_out), .cntl(1'b0), .c_out(c_out2));
	
	//remove this since it is move to IF file
	assign ALU_mux[0] = Add_4;
	assign ALU_mux[1] = Add_offset;
	mux2_1x64 mux3(.out(Add_PC), .in(Add_mux), .sel(orR0));//the mux between Adder and mux before PC
	
	//add to ID
	regfile register(.ReadRegister1(Inst[9:5]), .ReadRegister2(Rd2_in), 
							.WriteRegister(WriteReg_in), .WriteData(Write_Data), 
							.RegWrite, .ReadData1(Rd1_Reg_out), 
							.ReadData2(Rd2_Reg_out), .clk);
					
	//add to ID
	assign ALUSrc_mux[0] = Rd2_Reg_out;
	assign ALUSrc_mux[1] = SignExtend;
	mux2_1x64 mux4(.out(Rd_ALU_mux), .in(ALUSrc_mux), .sel(ALUSrc));//mux between register and alu
	
	//add to EX
	alu al(.A(Rd1_Reg_out), .B(Rd_ALU_mux), .cntrl(ALUOp), .
		result(address), .negative, .zero, .overflow, .carry_out);
	enableDff en0(.out(negativeFlag), .in(negative), .enable, .clk, .reset);
	enableDff en1(.out(zeroFlag), .in(zero), .enable, .clk, .reset);
	enableDff en2(.out(overflowFlag), .in(overflow), .enable, .clk, .reset);
	enableDff en3(.out(carry_outFlag), .in(carry_out), .enable, .clk, .reset);
	
	
	//add to MEM
	datamem Data(.address, .write_enable(MemWrite), .read_enable(MemRead), 
						.write_data(Rd2_Reg_out), .clk, .xfer_size(4'b1000), .read_data(Rd_mem));
	//add to wb
	assign MenReg_mux[1] = Rd_mem;
	assign MenReg_mux[0] = address;
	mux2_1x64 mux5(.out(Mux_Reg), .in(MenReg_mux), .sel(MemtoReg));//mux between data mem to reg
endmodule

module CPU_arm_testbench ();

	parameter ClockDelay = 100000;
	
	logic clk, reset;
	
	CPU_arm dut(.clk, .reset);

	initial $timeformat(-9, 2, " ns", 10);
	
	integer i;
	
	initial begin // Set up the clock
		clk <= 0;
		forever #(ClockDelay/2) clk <= ~clk;
	end
	
	initial begin
		reset <= 1; @(posedge clk);
		reset <= 0; @(posedge clk);
		for (i=0; i <= 30; i++) begin
			@(posedge clk); 
		end
		$stop;
	end
endmodule
	
	 