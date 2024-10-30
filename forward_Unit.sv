`timescale 1ns/10ps

module forward_Unit(forward1, forward2, Rn_EX, Rm_EX, Rd_EX, Rd_MEM, Rd_WB, RegWrite_MEM, RegWrite_WB, Rd_IMD, RegWrite_IMD);
	input logic [4:0] Rn_EX, Rm_EX, Rd_MEM, Rd_WB, Rd_EX, Rd_IMD;
	input logic RegWrite_MEM, RegWrite_WB, RegWrite_IMD;
	output logic [1:0] forward1, forward2;
	
	logic EX_MEM_RegRd0, EX_MEM_RegRd1, EX_MEM_RegRd2,
			MEM_WB_RegRd0, MEM_WB_RegRd1, MEM_WB_RegRd2,
			IMD_RegRd0, IMD_RegRd2;
	logic [1:0]case1, case2, case3;

	
	logic [4:0]comp0, comp1, comp2, comp3, comp4, comp5;
	logic [2:0]compFAC1, compFBC1, compFAC2, compFBC2;
	logic andR0, andR1, andR2, andR3;
	
	// Checking if the value is not 31 for Rd_MEM and Rd_EX /////////////////////////////
	and #50 and0(EX_MEM_RegRd0, Rd_MEM[0], Rd_MEM[1], Rd_MEM[2], Rd_MEM[3]);
	nand #50 and1(EX_MEM_RegRd2, EX_MEM_RegRd0, Rd_MEM[4]);
	//and #50 and2(, EX_MEM_RegRd0, EX_MEM_RegRd1);//result EX/MEM.RegisterRd !== 5'b11111
	
	and #50 and3(MEM_WB_RegRd0, Rd_WB[0], Rd_WB[1], Rd_WB[2], Rd_WB[3]);
	nand #50 and4(MEM_WB_RegRd2, MEM_WB_RegRd0, Rd_WB[4]);
	//and #50 and5(MEM_WB_RegRd2, MEM_WB_RegRd0, MEM_WB_RegRd1);
	
	//////check for not 31
	and #50 and30(IMD_RegRd0, Rd_IMD[0], Rd_IMD[1], Rd_IMD[2], Rd_IMD[3]);
	nand #50 and31(IMD_RegRd2, IMD_RegRd0, Rd_IMD[4]);
	
	// Checking if Rd == Rn or Rm ////////////
	genvar i;
	generate
	for (i = 0; i < 5; i++) begin : loop0
		xnor #50 xnor0(comp0[i], Rd_MEM[i], Rn_EX[i]);
		xnor #50 xnor1(comp1[i], Rd_MEM[i], Rm_EX[i]);
		xnor #50 xnor2(comp2[i], Rd_WB[i], Rn_EX[i]);
		xnor #50 xnor3(comp3[i], Rd_WB[i], Rm_EX[i]);
		xnor #50 xnor4(comp4[i], Rd_IMD[i], Rn_EX[i]);
		xnor #50 xnor5(comp5[i], Rd_IMD[i], Rm_EX[i]);

		end
	endgenerate
	logic case1_0, case1_1, case2_0, case2_1;

	//compare for FAC1 ForwardA is 10
	and #50 and6(compFAC1[0], comp0[0], comp0[1], comp0[2]);
	and #50 and7(compFAC1[1], comp0[3], comp0[4]);
	and #50 and8(compFAC1[2], compFAC1[0], compFAC1[1]);
	
	and #50 and9(case1[0], compFAC1[2], EX_MEM_RegRd2, RegWrite_MEM);//determine the 1st val of ForwardA
	not #50 no0(case1_0, case1[0]);

	// check if its true 
	

	//compare for FBCA1 ForwardB is 10 EX/MEM
	and #50 and10(compFBC1[0], comp1[0], comp1[1], comp1[2]);
	and #50 and11(compFBC1[1], comp1[3], comp1[4]);
	and #50 and12(compFBC1[2], compFBC1[0], compFBC1[1]);
	
	and #50 and13(case1[1], compFBC1[2], EX_MEM_RegRd2, RegWrite_MEM);//determine the 1st val of ForwardA
	not #50 no1(case1_1, case1[1]);
	
	
	//compare for FAC2 ForwardA is 01
	and #50 and14(compFAC2[0], comp2[0], comp2[1], comp2[2]);
	and #50 and15(compFAC2[1], comp2[3], comp2[4]);
	and #50 and16(compFAC2[2], compFAC2[0], compFAC2[1]);
	
	and #50 and17(case2[0], compFAC2[2], MEM_WB_RegRd2, RegWrite_WB, case1_0);
	not #50 no2(case2_0, case2[0]);
	
	//compare for FBCA2 ForwardB is 01
	and #50 and18(compFBC2[0], comp3[0], comp3[1], comp3[2]);
	and #50 and19(compFBC2[1], comp3[3], comp3[4]);
	and #50 and20(compFBC2[2], compFBC2[0], compFBC2[1]);
	
	and #50 and21(case2[1], compFBC2[2], MEM_WB_RegRd2, RegWrite_WB, case1_1);
	not #50 no3(case2_1, case2[1]);
	
	//case for 11 for the three instruction apart
	and #50 and22(andR0, comp4[0], comp4[1], comp4[2], comp4[3]);
	and #50 and23(andR1, andR0, comp4[4], IMD_RegRd2);
	and #50 and24(case3[0], andR1, case1_0, case2_0, RegWrite_IMD);
	
	
	and #50 and26(andR2, comp5[0], comp5[1], comp5[2], comp5[3]);
	and #50 and27(andR3, andR2, comp4[4], IMD_RegRd2);
	and #50 and28(case3[1], andR3, case1_1, case2_1, RegWrite_IMD);
	
	or #50 or0(forward1[1], case1[0], case3[0]); 
	or #50 or1(forward1[0], case2[0], case3[0]); 
	or #50 or2(forward2[1], case1[1], case3[1]); 
	or #50 or3(forward2[0], case2[1], case3[1]); 
	
endmodule
	