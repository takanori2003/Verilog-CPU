// Test bench for ALU
//`timescale 1ns/10ps
`timescale 1ns/10ps

// Meaning of signals in and out of the ALU:

// Flags:
// negative: whether the result output is negative if interpreted as 2's comp.
// zero: whether the result output was a 64-bit zero.
// overflow: on an add or subtract, whether the computation overflowed if the inputs are interpreted as 2's comp.
// carry_out: on an add or subtract, whether the computation produced a carry-out.

// cntrl			Operation						Notes:
// 000:			result = B						value of overflow and carry_out unimportant
// 010:			result = A + B
// 011:			result = A - B
// 100:			result = bitwise A & B		value of overflow and carry_out unimportant
// 101:			result = bitwise A | B		value of overflow and carry_out unimportant
// 110:			result = bitwise A XOR B	value of overflow and carry_out unimportant

module alustim();

	parameter delay = 1000000;

	logic		[63:0]	A, B;
	logic		[2:0]		cntrl;
	logic		[63:0]	result;
	logic					negative, zero, overflow, carry_out ;

	parameter ALU_PASS_B=3'b000, ALU_ADD=3'b010, ALU_SUBTRACT=3'b011, ALU_AND=3'b100, ALU_OR=3'b101, ALU_XOR=3'b110;
	

	alu dut (.A, .B, .cntrl, .result, .negative, .zero, .overflow, .carry_out);

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 2, " ns", 10);

	integer i;
	logic [63:0] test_val;
	initial begin
	
		$display("%t testing PASS_A operations", $time);
		cntrl = ALU_PASS_B;
		for (i=0; i<100; i++) begin
			A = $random(); B = $random();
			#(delay);
			assert(result == B && negative == B[63] && zero == (B == '0));
		end
		// add
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay);
		assert(result == 64'h0000000000000002 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'hC000000000000001; B = 64'hC000000000000001;
		#(delay);
		assert(result == 64'hF8000000000000002 && carry_out == 1 && overflow == 0 && negative == 1 && zero == 0);
		
		$display("%t testing addition", $time);
		cntrl = ALU_ADD;
		A = 64'h2000000000000001; B = 64'h6000000000000001;
		#(delay);
		assert(result == 64'h8000000000000002 && carry_out == 0 && overflow == 1 && negative == 1 && zero == 0);
		
		//subtration
		$display("%t testing subtraction, overflow, carryout", $time);
        cntrl = ALU_SUBTRACT;
        for (i=0; i<100; i++) begin
            A = $random(); B = $random();
            #(delay);
            assert(result == A - B);
        end
        A = 64'h8000000000000000; B = 64'h7FFFFFFFFFFFFFFF;
        #(delay);
        assert(overflow == 1 && carry_out == 1);
        #(delay*50);
		  
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h0000000000000001; B = 64'h0000000000000001;
		#(delay); 
		assert(result == 64'h0000000000000000 && carry_out == 0 && overflow == 0 && negative == 0 && zero == 1);
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h000000000000002C; B = 64'h000000000000000D;
		#(delay);
		assert(result == 64'h000000000000000F && carry_out == 0 && overflow == 0 && negative == 0 && zero == 0);
		
		$display("%t testing subtraction", $time);
		cntrl = ALU_SUBTRACT;
		A = 64'h000000000000000C; B = 64'h0000000000000010;//needs 
		#(10000);
		assert(result == 64'h8000000000000001 && carry_out == 0 && overflow == 0 && negative == 1 && zero == 0);
		
		
		
		// and 
		$display("%t testing and", $time);
		cntrl = ALU_AND;
		A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);
		
		$display("%t testing and", $time);
		cntrl = ALU_AND;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);
		
		// or
		$display("%t testing or", $time);
		cntrl = ALU_OR;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);
		
		$display("%t testing or", $time);
		cntrl = ALU_OR;
		A = 64'h2AAAAAAAAAAAAAAA; B = 64'h5555555555555555;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && negative == 0 && zero == 0);
		
		$display("%t testing or", $time);
		cntrl = ALU_OR;
		A = 64'h7FFFFFFFFFFFFFFF; B = 64'h7FFFFFFFFFFFFFFF;
		#(delay);
		assert(result == 64'h7FFFFFFFFFFFFFFF && negative == 0 && zero == 0);
		
		// xor
		$display("%t testing xor", $time);
		cntrl = ALU_XOR;
		A = 64'h0000000000000000; B = 64'h0000000000000000;
		#(delay);
		assert(result == 64'h0000000000000000 && negative == 0 && zero == 1);
		
		$display("%t testing or", $time);
		cntrl = ALU_XOR;
		A = 64'hAAAAAAAAAAAAAAAA; B = 64'h5555555555555555;
		#(delay);
		assert(result == 64'hFFFFFFFFFFFFFFFF && negative == 1 && zero == 0);
		
		$display("%t testing or", $time);
		cntrl = ALU_XOR;
		A = 64'hFFFFFFFFFFFFFFFF; B = 64'hFFFFFFFFFFFFFFFF;
		#(delay);
		assert(result == A^B && negative == 0 && zero == 1);
		
		
	end
endmodule
