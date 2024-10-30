`timescale 1ns/10ps
//(.Inst_IF, .Add_4_IF, .PC_out_IF, .Add_offset, .Rd_ALU_mux_ID, .Reg2PC_EX, .orR0, .clk, .reset(1'b0));
module IF (Inst_IF, Add_4_IF, PC_out_IF, Add_offset, Rd_ALU_mux_ID, Reg2PC_EX, orR0, clk, reset);//I think this is complete

	input logic [63:0]Add_offset, Rd_ALU_mux_ID;
	output logic [31:0]Inst_IF;
	output logic [63:0]Add_4_IF, PC_out_IF;
	//control
	input logic Reg2PC_EX, orR0;
	input logic clk, reset;
	
	logic [63:0] PC_in, c_out1, Add_PC;
	
	logic [63:0] Add_mux [1:0];
	logic [63:0] Reg2PC_mux [1:0];
	
	assign Add_mux[0] = Add_4_IF;
	assign Add_mux[1] = Add_offset;
	mux2_1x64 mux3(.out(Add_PC), .in(Add_mux), .sel(orR0));//the mux between Adder and mux before PC
	
	assign Reg2PC_mux[0]= Add_PC;
	assign Reg2PC_mux[1]= Rd_ALU_mux_ID;
	mux2_1x64 mux0(.out(PC_in), .in(Reg2PC_mux), .sel(Reg2PC_EX));//mux between PC and another mux
	
	pc PC(.in(PC_in), .out(PC_out_IF), .clk, .reset);
	add_64 add_4(.s(Add_4_IF), .A(PC_out_IF), .B(64'd4), .cntl(1'b0), .c_out(c_out1));
	instructmem instr(.address(PC_out_IF), .instruction(Inst_IF), .clk);
	
endmodule
