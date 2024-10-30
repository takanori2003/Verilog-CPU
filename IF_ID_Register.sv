`timescale 1ns/10ps

module IF_ID_Register(Inst_ID, PC_out_ID, Add_4_ID, Inst_IF, PC_out_IF, Add_4_IF, clk, reset);
	output logic [31:0]Inst_ID;
	output logic [63:0]PC_out_ID, Add_4_ID;
	input logic [31:0]Inst_IF;
	input logic [63:0]PC_out_IF, Add_4_IF;
	input logic clk, reset;
	
	adjustRegister #(32) adjReg0 (.out(Inst_ID), .in(Inst_IF), .reset, .clk);
	
	adjustRegister #(64) adjReg1 (.out(PC_out_ID), .in(PC_out_IF), .reset, .clk);
	// reset when flush is true
	adjustRegister #(64) adjReg2 (.out(Add_4_ID), .in(Add_4_IF), .reset, .clk);
endmodule
