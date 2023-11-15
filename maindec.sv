module maindec (input logic [11:0] Op,
					output logic Reg2Loc, ALUSrc, MemtoReg,
					RegWrite, MemRead, MemWrite, Branch,
					output logic [1:0] ALUOp);
					
		always_comb begin
			casez (Op)
				// LDUR
				11'b111_1100_0010: begin
						Reg2Loc <= 1'b0;
						ALUSrc <= 1'b1;
						MemtoReg <= 1'b1;
						RegWrite <= 1'b1;
						MemRead <= 1'b1;
						MemWrite <= 1'b0;
						Branch <= 1'b0;
						ALUOp <= 2'b00;
					end
				// STUR
				11'b111_1100_0000:begin
						Reg2Loc <= 1'b1;
						ALUSrc <= 1'b1;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;
						MemRead <= 1'b0;
						MemWrite <= 1'b1;
						Branch <= 1'b0;
						ALUOp <= 2'b00;
					end
				// CBZ
				11'b101_1010_0???:begin
						Reg2Loc <= 1'b1;
						ALUSrc <= 1'b0;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;
						MemRead <= 1'b0;
						MemWrite <= 1'b0;
						Branch <= 1'b1;
						ALUOp <= 2'b01;
					end
				// ADD
				11'b100_0101_1000,
				// SUB
				11'b110_0101_1000,
				// AND
				11'b100_0101_0000,
				// ORR
				11'b101_0101_0000: begin
						Reg2Loc <= 1'b0;
						ALUSrc <= 1'b0;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b1;
						MemRead <= 1'b0;
						MemWrite <= 1'b0;
						Branch <= 1'b0;
						ALUOp <= 2'b10;
					end
				//MOVZ
				11'b110_1001_01??: begin    //Nuevo
						Reg2Loc <= 1'b0;	//Nuevo 
						ALUSrc <= 1'b1;		//Nuevo, usamos la salida de signext en la entrada b de la ALU
						MemtoReg <= 1'b0;	//Nuevo
						RegWrite <= 1'b1;	//Nuevo, escribimos el res en un registro al final
						MemRead <= 1'b0;	//Nuevo
						MemWrite <= 1'b0;	//Nuevo
						Branch <= 1'b0;		//Nuevo
						ALUOp <= 2'b11;		//Nuevo, Ningun otro tenia el valor 11, fue arbitrario(Importa el numero?)
					end
				default: begin
						Reg2Loc <= 1'b0;
						ALUSrc <= 1'b0;
						MemtoReg <= 1'b0;
						RegWrite <= 1'b0;
						MemRead <= 1'b0;
						MemWrite <= 1'b0;
						Branch <= 1'b0;
						ALUOp <= 2'b00;
					end
			endcase
		end
endmodule
