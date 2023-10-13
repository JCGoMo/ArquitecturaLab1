module signext
	(input logic [31:0] a,
	 output logic [63:0] y);

	always_comb
		casez(a[31:21])
			//55 veces el bit 20 de 'a' concatenado a los bits del 20 al 12 de 'a'
			11'b111_1100_00?0: y = {{55{a[20]}},a[20:12]};
			//45 veces el bit 23 de 'a' concatenado a los bits del 23 al 5 de 'a'
			11'b101_1010_0???: y = {{45{a[23]}},a[23:5]};
			default : y = '0;
		endcase

endmodule