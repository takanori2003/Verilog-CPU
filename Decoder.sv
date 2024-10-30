`timescale 1ns/10ps
module decoder(Register, RegWrite, WriteReg);
	input logic [4:0] WriteReg;
	input logic RegWrite;
	output logic [30:0]Register;
	
	
	genvar i,j;
	generate 
		//do nested for loop since in[31:0][i] is not allowed
		for(i=0; i<31; i++) begin : dec
			logic outAnd;
			logic [4:0]bits5;
			for(j=0; j<5; j++) begin : gg
				xnor #50 xnor0(bits5[j], WriteReg[j], i[j]);
			end
			and #50 and0(outAnd, bits5[0], bits5[1], bits5[2],bits5[3]);
			and #50 and1(Register[i], RegWrite, outAnd, bits5[4]);
		end
	endgenerate
//	decoder2_4 dec0(.out(outOr[3:0]), .in(RegWrite[1:0]), .enable(WriteReg));
//	decoder3_8 dec1(.out(Register[7:0]), .in({RegWrite[4:2],outOr[0]}), .enable(WriteReg)); 
//	decoder3_8 dec2(.out(Register[15:8]), .in({RegWrite[4:2],outOr[1]}), .enable(WriteReg)); 
//	decoder3_8 dec3(.out(Register[23:16]), .in({RegWrite[4:2],outOr[2]}), .enable(WriteReg)); 
//	decoder3_8 dec4(.out(Register[31:17]), .in({RegWrite[4:2],outOr[3]}), .enable(WriteReg)); 
endmodule

module decoder_testbench();
		logic [4:0]RegWrite; 
		logic WriteReg;
		logic [30:0]Register;
		
		decoder dut (.Register, .RegWrite, .WriteReg);
		
		integer i;
		initial begin
			WriteReg <= 0;
			RegWrite <= 0;
			for(i=0; i<31; i++) begin
					{RegWrite} = i; #200;
			end
			RegWrite <= 0;
			WriteReg <= 1;
			for(i=0; i<31; i++) begin
					{RegWrite} = i; #200;
			end
			$stop;
		end
endmodule