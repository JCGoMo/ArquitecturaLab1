module imem
	#(parameter N=32)
	(input logic [6:0] addr, //Un bit más para duplicar la memoria
	 output logic [N-1:0] q);
	 
	logic [N-1:0] rom [0:127];  
	localparam logic [N-1:0] NOP = 32'h8b01003f; // ADD XZR, X1, X1;

	initial begin

				rom = '{default:0};
				rom [0:46] = 
						'{	32'hf8000001,
								32'hf8008002,
								32'hf8000203,
								32'h8b050083,
								32'hf8018003,
								32'hcb050083,
								32'hf8020003,
								32'hcb0a03e4,
								32'hf8028004,
								32'h8b040064,
								32'hf8030004,
								32'hcb030025,
								32'hf8038005,
								32'h8a1f0145,
								32'hf8040005,
								32'h8a030145,
								32'hf8048005,
								32'h8a140294,
								32'hf8050014,
								32'haa1f0166,
								32'hf8058006,
								32'haa030166,
								32'hf8060006,
								32'hf840000c,
								32'h8b1f0187,
								32'hf8068007,
								32'hf807000c,
								32'h8b0e01bf,
								32'hf807801f,
								32'hb4000040,
								32'hf8080015,
								32'hf8088015,
								32'h8b0103e2,
								32'hcb010042,
								32'h8b0103f8,
								32'hf8090018,
								32'h8b080000,
								32'hb4ffff82,
								32'hf809001e,
								32'h8b1e03de,
								32'hcb1503f5,
								32'h8b1403de,
								32'hf85f83d9,
								32'h8b1e03de,
								32'h8b1003de,
								32'hf81f83d9,
								32'hb400001f
							};
			
				/* rom [0:103] = 
					  	'{  32'hf8000001,	// (1)
							32'hf8008002,	// (2)
							32'hf8000203,	// (3)
							32'h8b050083,	// (4)
							NOP,
							NOP,
							32'hf8018003,	// (5)
							32'hcb050083,	// (6)
							NOP,
							NOP,
							32'hf8020003,	// (7)
							32'hcb0a03e4,	// (8)
							NOP,
							NOP,	
							32'hf8028004,	// (9)
							32'h8b040064,	// (10)
							NOP,
							NOP,
							32'hf8030004,	// (11)
							32'hcb030025,	// (12)
							NOP,
							NOP,
							32'hf8038005,	// (13)
							32'h8a1f0145,	// (14)
							NOP,
							NOP,
							32'hf8040005,	// (15)
							32'h8a030145,	// (16)
							NOP,
							NOP,	
							32'hf8048005,	// (17)
							32'h8a140294,	// (18)
							NOP,
							NOP,
							32'hf8050014,	// (19)
							32'haa1f0166,	// (20)
							NOP,
							NOP,
							32'hf8058006,	// (21)
							32'haa030166,	// (22)
							NOP,
							NOP,
							32'hf8060006,	// (23)
							32'hf840000c,	// (24)
							NOP,
							NOP,
							32'h8b1f0187,	// (25)
							NOP,
							NOP,
							32'hf8068007,	// (26)
							32'hf807000c,	// (27)
							32'h8b0e01bf,	// (28)
							32'hf807801f,	// (29)
							32'hb40000a0,	// (30)
							NOP,
							NOP,
							NOP,
							32'hf8080015,	// (31)
							32'hf8088015,	// (32)
							32'h8b0103e2,	// (33)
							NOP,
							NOP,
							32'hcb010042,	// (34)
							32'h8b0103f8,	// (35)
							NOP,
							NOP,
							32'hf8090018,	// (36)
							32'h8b080000,	// (37)
							32'hb4ffff42,	// (38)
							NOP,	
							NOP,
							NOP,
							32'hf809001e,	// (39)
							32'h8b1e03de,	// (40)
							32'hcb1503f5,	// (41)
							NOP,
							32'h8b1403de,	// (42)
							NOP,
							NOP,
							32'hf85f83d9,	// (43)
							32'h8b1e03de,	// (44)
							NOP,	
							NOP,
							32'h8b1003de,	// (45)
							NOP,
							NOP,	
							32'hf81f83d9,	// (46)
							32'hd2800069,		// MOVZ X9, #0x0003, lsl #00 
							NOP,
							NOP,
							32'hf80003c9,		// STUR x9, [X30, #0]		
							32'hd2bfffe9,		// MOVZ X9, #0xFFFF, lsl #01
							NOP,
							NOP,
							32'hf80083c9,		// STUR x9, [X30, #8] 
							32'hd2caaaa9,		// MOVZ X9, #0x5555, lsl #10
							NOP,
							NOP,
							32'hf80103c9,		// STUR x9, [X30, #16]
							32'hd2ffffe9,		// MOVZ X9, #0xFFFF, lsl #11
							NOP,
							NOP,
							32'hf80183c9,		// STUR x9, [X30, #24]
							32'hb400001f		// (47)
							}; */
	end		 
					
	assign 	q = rom[addr];
	
	 
endmodule