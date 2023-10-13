module flopr
	#(parameter N=64) // input/output bits
	(input logic [N-1:0] d,
	input logic clk,
	input logic reset,
	output logic [N-1:0] q);

	always_ff @(posedge clk, posedge reset)
		if(reset) q <= 'b0;
		else q<= d;
		
endmodule
