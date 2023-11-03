
module mux3 #(parameter N = 64)
				(input logic [N-1:0] d0, d1, d2,
				input logic [1:0] s,
				output logic [N-1:0] y);
	
    logic [N-1:0] mux_out_izq;

    mux2 #(N) mux2_izquierda (d0, d1, s[0:0], mux_out_izq);
    mux2 #(N) mux2_derecha (mux_out_izq,d2, s[1:1], y );

endmodule