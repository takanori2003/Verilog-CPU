`timescale 1ns/10ps
module EX(address_EX, negativeFlag, overflowFlag, ALUOp_EX, Rd1_Reg_out_EX, Rd_ALU_mux_EX, Mux_Reg, 
			enable_EX, forwardA, forwardB, address_MEM, clk, reset);
	output logic [63:0]  address_EX;
	output logic negativeFlag, overflowFlag; 
	input logic [63:0] Rd1_Reg_out_EX, Rd_ALU_mux_EX, Mux_Reg, address_MEM; 
	
	input logic enable_EX; 
	input logic [1:0]forwardA, forwardB;
	input logic reset, clk;
	input logic [2:0]ALUOp_EX;
	
	
	logic negative, zero, overflow, carry_out;
	logic [63:0] mux4_B_out_EX;
	
	logic zeroFlag, carry_outFlag;
	logic [63:0] mux4_A_in [3:0];
	logic [63:0] mux4_B_in [3:0];
	logic [63:0] mux4_A_out;

	
	
	
	assign mux4_A_in[0] = Rd1_Reg_out_EX;
	assign mux4_A_in[1] = Mux_Reg;
	assign mux4_A_in[2] = address_MEM;
	assign mux4_A_in[3] = Rd1_Reg_out_EX;
	mux4_1x64 mux4_A (.out(mux4_A_out), .in(mux4_A_in), .sel(forwardA));
	
	assign mux4_B_in[0] = Rd_ALU_mux_EX;
	assign mux4_B_in[1] = Mux_Reg;
	assign mux4_B_in[2] = address_MEM;
	assign mux4_B_in[3] = Rd_ALU_mux_EX;
	mux4_1x64 mux4_B(.out(mux4_B_out_EX), .in(mux4_B_in), .sel(forwardB));
	
	//add to EX
	alu al(.A(mux4_A_out), .B(mux4_B_out_EX), .cntrl(ALUOp_EX), .
		result(address_EX), .negative, .zero, .overflow, .carry_out);
		
	enableDff en0(.out(negativeFlag), .in(negative), .enable(enable_EX), .clk, .reset);
	enableDff en1(.out(zeroFlag), .in(zero), .enable(enable_EX), .clk, .reset);
	enableDff en2(.out(overflowFlag), .in(overflow), .enable(enable_EX), .clk, .reset);
	enableDff en3(.out(carry_outFlag), .in(carry_out), .enable(enable_EX), .clk, .reset);
	
	//out, in, enable, clk, reset)
	//include the mux 
endmodule 