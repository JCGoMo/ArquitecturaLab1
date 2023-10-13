module fetch #(parameter N=64)
    (input logic PCSrc_F, clk, reset,
     input logic [N-1:0] PCBranch_F,
     output logic [N-1:0] imem_addr_F);

	logic [N-1:0] muxOut, addEx; //Salidas de los módulos = buses
    
    mux2 #(N) myMux(addEx, PCBranch_F, PCSrc_F, muxOut);
		 
	flopr #(N) PC(muxOut, clk, reset, imem_addr_F);
		 
	adder #(N) Add(imem_addr_F,N'('h4),addEx);
		 
endmodule