module fetch #(parameter N = 64)
				(input logic PCSrc_F, clk, reset, enable,
				 input logic [N-1:0] PCBranch_F, PC_Stalled,
				 output logic [N-1:0] imem_addr_F);
				  
		logic [N-1:0] out_mux2, out_muxStall, out_add;

		mux2 #(N) mux2_inst (out_add, PCBranch_F, PCSrc_F, out_mux2); 
		mux2 #(N) mux_stall (out_mux2, PC_Stalled, enable, out_muxStall);
		flopr #(N) flopr_inst (clk, reset, out_muxStall, imem_addr_F);
		adder #(N) adder_inst (imem_addr_F, N'('d4), out_add);
			
endmodule
		