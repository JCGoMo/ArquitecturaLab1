module fetch #(parameter N = 64)
				(input logic PCSrc_F, clk, reset, enable,
				 input logic [N-1:0] PCBranch_F,
				 output logic [N-1:0] imem_addr_F);
				  
		logic [N-1:0] out_mux2, out_add;
		
		mux2 #(N) mux2_inst (out_add, PCBranch_F, PCSrc_F, out_mux2);
		flopr_e #(N) flopr_inst (clk, reset, enable, out_mux2, imem_addr_F);
		adder #(N) adder_inst (imem_addr_F, N'('d4), out_add);
			
endmodule
		