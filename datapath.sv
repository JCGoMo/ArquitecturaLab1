// DATAPATH

module datapath #(parameter N = 64)
					(input logic reset, clk,
					input logic reg2loc,									
					input logic AluSrc,
					input logic [3:0] AluControl,
					input logic	Branch,
					input logic memRead,
					input logic memWrite,
					input logic regWrite,	
					input logic memtoReg,				
					input logic [31:0] IM_readData,
					input logic [N-1:0] DM_readData,
					output logic [N-1:0] IM_addr, DM_addr, DM_writeData,
					output logic DM_writeEnable, DM_readEnable,
					output logic stall_out, flush);					
					
	logic PCSrc;
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E, writeData3; 
	logic [N-1:0] signImm_D, readData1_D, readData2_D;
	logic zero_E, stall;
	logic [95:0] qIF_ID;
	logic [281:0] qID_EX;
	logic [202:0] qEX_MEM;
	logic [134:0] qMEM_WB;
	logic [4:0] rn_reg, rm_reg, control_flush_out; //Nuevo
	logic [9:0] control_mux; //Nuevo
	
	fetch 	#(64) 	FETCH 	(.PCSrc_F(PCSrc),
										.clk(clk),
										.reset(reset),
										.enable(~stall),				// Nuevo
										.PCBranch_F(qEX_MEM[197:134]),
										.imem_addr_F(IM_addr));								
	
	
	flopr_e 	#(96)		IF_ID 	(.clk(clk),
										.reset(reset),
										.enable(~stall), 				// Nuevo
										.d({IM_addr, IM_readData}),
										.q(qIF_ID));
										
	
	decode 	#(64) 	DECODE 	(.regWrite_D(qMEM_WB[134]),
										.reg2loc_D(reg2loc), 
										.clk(clk),
										.MemRead_IdEx(qID_EX[264]),		// Nuevo
										.MemRead_ExMem(qEX_MEM[200]),	// Nuevo
										.writeData3_D(writeData3),
										.instr_D(qIF_ID[31:0]), 
										.signImm_D(signImm_D), 
										.readData1_D(readData1_D),
										.readData2_D(readData2_D),
										.wa3_D(qMEM_WB[4:0]),
										.Rd_IdEx(qID_EX[4:0]),			// Nuevo
										.Rd_ExMem(qEX_MEM[4:0]),			// Nuevo
										.rn_reg(rn_reg),		//Nuevo
										.rm_reg(rm_reg),		//Nuevo	
										.stall(stall));			//Nuevo
	//Salida para el ID_EX fuera de datapath 
	assign stall_out = stall; 									//Nuevo
																									
	mux2 # (10) control ({AluSrc, AluControl, Branch, memRead, memWrite, regWrite, memtoReg}, 10'b0, (stall | flush), control_mux);	 /* 0 => control normal, 1 => stall (0000) */
						
	flopr 	#(281)	ID_EX 				(.clk(clk),
										.reset(reset), // Añadimos rn_reg y rm_reg Nuevo
										.d({rn_reg, rm_reg ,control_mux,	/* del Branch al memtoReg => qID_EX[265:261] */
											qIF_ID[95:32], signImm_D, readData1_D, readData2_D, qIF_ID[4:0]}),
										.q(qID_EX));	
							
	execute 	#(64) 	EXECUTE 	(  
										.AluSrc(qID_EX[270]),
										.AluControl(qID_EX[269:266]),
										.PC_E(qID_EX[260:197]), 
										.signImm_E(qID_EX[196:133]), 
										.readData1_E(qID_EX[132:69]), 
										.readData2_E(qID_EX[68:5]),
										.rn_register(qID_EX[280:276]),     			// Nuevo 5 bits
										.rm_register(qID_EX[275:271]),				// 5 bits
										.rd_ExMem(qEX_MEM[4:0]),					// 5 bits
										.rd_MemWb(qMEM_WB[4:0]),					// 5 bits
										.WB_content_rd(writeData3),					// 64 bits
										.Mem_content_rd(qEX_MEM[133:69]),		    // 64 bits
										.regWrite_ExMem(qEX_MEM[199]),				// 1 bit
										.regWrite_MemWb(qMEM_WB[134]),				// 1 bit: El mismo que regWrite_D en decode.  
										.PCBranch_E(PCBranch_E), 
										.aluResult_E(aluResult_E), 
										.writeData_E(writeData_E), 
										.zero_E(zero_E));											
											
	mux2 #(5) control_flush (qID_EX[265:261], 5'b0, flush, control_flush_out);

	flopr 	#(203)	EX_MEM 	(.clk(clk),
										.reset(reset), 
										.d({control_flush_out/* (branch, memRead, memWrite ==> qEX_MEM[200], regWrite => qEX_MEM[199], memtoReg) */, PCBranch_E, zero_E, aluResult_E, writeData_E, qID_EX[4:0]}),
										.q(qEX_MEM));	
	
										
	memory				MEMORY	(.Branch_M(qEX_MEM[202]), 
										.zero_M(qEX_MEM[133]), 
										.PCSrc_M(PCSrc));
									
	assign flush = PCSrc;
	
	// Salida de señales a Data Memory
	assign DM_writeData = qEX_MEM[68:5];
	assign DM_addr = qEX_MEM[132:69];
	
	// Salida de señales de control:
	assign DM_writeEnable = qEX_MEM[200];
	assign DM_readEnable = qEX_MEM[201];
	
	flopr 	#(135)	MEM_WB 	(.clk(clk),
										.reset(reset), 
										.d({qEX_MEM[199:198], qEX_MEM[132:69],	DM_readData, qEX_MEM[4:0]}),
										.q(qMEM_WB));
		
	
	writeback #(64) 	WRITEBACK (.aluResult_W(qMEM_WB[132:69]), 
										.DM_readData_W(qMEM_WB[68:5]), 
										.memtoReg(qMEM_WB[133]), 
										.writeData3_W(writeData3));		

endmodule
