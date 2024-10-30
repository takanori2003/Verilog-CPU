`timescale 1ns/10ps

module control(Opcode, Reg2Loc, Uncondbranch, Branch, MemRead, 
MemtoReg, ALUOp, MemWrite, ALUSrc, RegWrite, contCBZ, contBLT, Reg2PC, Add2Reg, enable, signEx);
	input logic [10:0]Opcode;
	output logic   Reg2Loc, 
						Uncondbranch,
						Branch, 
						MemRead, 
						MemtoReg,  
						MemWrite, 
						ALUSrc,	
						RegWrite,
						contCBZ,
						contBLT,
						Reg2PC,
						Add2Reg,
						enable;
						
	output logic [2:0]ALUOp;
	output logic [2:0]signEx;//000 - nothing, 001-I, 010-B, 011-CB, 100-D, 101-R 
	parameter  ADDI = 11'b1001000100x,
					ADDS = 11'b10101011000,
					B    = 11'b000101xxxxx,
					B_LT = 11'b01010100xxx, 
					BL   = 11'b100101xxxxx,
					BR   = 11'b11010110000,
					CBZ  = 11'b10110100xxx,
					LDUR = 11'b11111000010,
					STUR = 11'b11111000000,
					SUBS = 11'b11101011000;
	
	always_comb begin;
		casex(Opcode)
			ADDI: begin 
						Reg2Loc  = 1'b1;
						Uncondbranch = 1'b0;
						Branch   = 1'b0;
						MemRead  = 1'bx;
						MemtoReg = 1'b0;
						ALUOp    = 3'b010;//add
						MemWrite = 1'b0;
						ALUSrc   = 1'b1;
						RegWrite = 1'b1;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b001;
						//Flash    = 1'b0;
			end 
			ADDS: begin
						Reg2Loc  = 1'b0;
						Uncondbranch = 1'b0;
						Branch   = 1'b0;
						MemRead  = 1'bx;
						MemtoReg = 1'b0;
						ALUOp    = 3'b010;
						MemWrite = 1'b0;
						ALUSrc   = 1'b0;
						RegWrite = 1'b1;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b1;
						signEx   = 3'b000;
						//Flash    = 1'b0;

			end 
			B: begin
						Reg2Loc  = 1'bx;
						Uncondbranch = 1'b1;
						Branch   = 1'bx;
						MemRead  = 1'bx;
						MemtoReg = 1'bx;
						ALUOp    = 3'bxxx;
						MemWrite = 1'b0;
						ALUSrc   = 1'bx;
						RegWrite = 1'b0;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b010;
						//Flash    = 1'b1;
						
			end 
			B_LT: begin  // create a logic gate for overflow and zero in top module
						Reg2Loc  = 1'b0;
						Uncondbranch = 1'b0;
						Branch   = 1'b1;
						MemRead  = 1'bx;
						MemtoReg = 1'bx;
						ALUOp    = 3'bxxx;
						MemWrite = 1'b0;
						ALUSrc   = 1'b0;
						RegWrite = 1'b0;
						contCBZ  = 1'b0;
						contBLT  = 1'b1;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b011;
						//Flash    = 1'b1;
			end 
			BL: begin
						Reg2Loc  = 1'bx;
						Uncondbranch = 1'b1;
						Branch   = 1'bx;
						MemRead  = 1'bx;
						MemtoReg = 1'bx;
						ALUOp    = 3'bxxx;
						MemWrite = 1'b0;
						ALUSrc   = 1'bx;
						RegWrite = 1'b1;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b1;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b010;
						//Flash    = 1'b1;
			end 
			BR: begin
						Reg2Loc  = 1'b1;
						Uncondbranch = 1'b1;
						Branch   = 1'bx;
						MemRead  = 1'bx;
						MemtoReg = 1'bx;
						ALUOp    = 3'bxxx;
						MemWrite = 1'b0;
						ALUSrc   = 1'bx;
						RegWrite = 1'b0;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b1;
						enable   = 1'b0;
						signEx   = 3'b101;//R
						//Flash    = 1'b1;
						
			end 
			CBZ: begin
						Reg2Loc  = 1'b1;
						Uncondbranch = 1'b0;
						Branch   = 1'b1;
						MemRead  = 1'bx;
						MemtoReg = 1'bx;
						ALUOp    = 3'b000;
						MemWrite = 1'b0;
						ALUSrc   = 1'b0;
						RegWrite = 1'b0;
						contCBZ  = 1'b1;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b011;
						//Flash    = 1'b1;
			end 
			LDUR: begin
						Reg2Loc  = 1'b1;
						Uncondbranch = 1'b0;
						Branch   = 1'b0;
						MemRead  = 1'b1;
						MemtoReg = 1'b1;
						ALUOp    = 3'b010;//add 011 for sub
						MemWrite = 1'b0;
						ALUSrc   = 1'b1;
						RegWrite = 1'b1;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b100;
						//Flash    = 1'b0;
			end 
			STUR: begin
						Reg2Loc  = 1'b1;
						Uncondbranch = 1'b0;
						Branch   = 1'b0;
						MemRead  = 1'b1;
						MemtoReg = 1'b1;
						ALUOp    = 3'b010;
						MemWrite = 1'b1;
						ALUSrc   = 1'b1;
						RegWrite = 1'b0;
						contCBZ  = 1'b0;
						contBLT  = 1'b0;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b0;
						signEx   = 3'b100;
						//Flash    = 1'b0;
			end 
			SUBS: begin
						Reg2Loc  = 1'b0;
						Uncondbranch = 1'b0;
						Branch   = 1'b0;
						MemRead  = 1'bx;
						MemtoReg = 1'b0;
						ALUOp    = 3'b011;
						MemWrite = 1'b0;
						ALUSrc   = 1'b0;
						RegWrite = 1'b1;
						Add2Reg   = 1'b0;
						Reg2PC   = 1'b0;
						enable   = 1'b1;
						signEx   = 3'b000;
						//Flash    = 1'b0;
			end
		endcase
	end 
endmodule
