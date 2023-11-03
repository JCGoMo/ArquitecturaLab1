module execute
	#(parameter N = 64)
	(input logic AluSrc,
	input logic [3:0] AluControl,
	input logic [N-1:0] PC_E, signImm_E, readData1_E, readData2_E,
	input logic [4:0] rn_register, rm_register, rd_ExMem, rd_MemWb, //Registros de Fetch/Dec, Ex/Mem y Mem/WB
	input logic [N-1:0] WB_content_rd, Mem_content_rd,
	input logic regWrite_ExMem, regWrite_MemWb,						// Señales de control de Ex/Mem y Mem/WB
	output logic [N-1:0] PCBranch_E, aluResult_E, writeData_E,
	output logic zero_E);
	 
	logic [N-1:0] slOut, muxOut, muxA_out, muxB_out;
	logic [1:0] control_muxB , control_muxA;
	 
	sl2 #(N)		Shift(signImm_E, slOut);
	adder #(N)	Add(PC_E, slOut, PCBranch_E);
	/* mux2 #(N)	Mux(readData2_E, signImm_E, AluSrc, muxOut); */
	/* alu #(N) 	Alu(readData1_E, muxOut, AluControl, aluResult_E, zero_E); */

	mux2 #(N)	Mux(muxB_out, signImm_E, AluSrc, muxOut);
	alu #(N) 	Alu(muxA_out, muxOut, AluControl, aluResult_E, zero_E);
	
	mux3 #(N)	MuxA(readData1_E, WB_content_rd, Mem_content_rd , control_muxA, muxA_out);
	mux3 #(N)	MuxB(readData2_E, WB_content_rd, Mem_content_rd , control_muxB, muxB_out);

	forwardingUnit #(N) ForwardingUnit(.Rn(rn_register),
									   .Rm(rm_register),
									   .Rd_ExMem(rd_ExMem),
									   .Rd_MemWb(rd_MemWb),
									   .RegWrite_ExMem(regWrite_ExMem),
									   .RegWrite_MemWb(regWrite_MemWb),
									   .ForwardA(control_muxA),
									   .ForwardB(control_muxB));

	assign writeData_E = readData2_E;
	
endmodule