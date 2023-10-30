// ARITHMETIC-LOGIC UNIT

module alu #(parameter N=64)
			(input logic [N-1:0] a, b,
			 input logic [3:0] ALUControl,
			 output logic [N-1:0] result,
			 output logic zero);

	logic [1:0] shift = b[63:62]; //Nuevo

	always_comb begin
		casez(ALUControl)
			4'b0000: result = a & b;
			4'b0001: result = a | b;
			4'b0010: result = a + b;
			4'b0110: result = a - b;
			4'b0111: result = b;
			4'b1000: result = b << (shift * 16);  //Nuevo
			default: result = '1;
		endcase

		zero = ~(|result); // zero is active when no bit of result is set
	end

endmodule
