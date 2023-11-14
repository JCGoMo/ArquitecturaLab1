module forwardingUnit #(parameter N = 64) (
    input logic [4:0] Rn, Rm, Rd_ExMem, Rd_MemWB,
    input logic RegWrite_ExMem, RegWrite_MemWB,
    output logic [1:0] ForwardA, ForwardB
);

    always_comb begin

        ForwardA = 2'b00;
        ForwardB = 2'b00;

        if (RegWrite_ExMem & Rd_ExMem != 31 & Rd_ExMem == Rn)
            ForwardA = 2'b10;
        else if (RegWrite_MemWB & Rd_MemWB != 31 & Rd_MemWB == Rn) 
            ForwardA = 2'b01;

        if (RegWrite_ExMem & Rd_ExMem != 31 & Rd_ExMem == Rm)
            ForwardB = 2'b10;
        else if (RegWrite_MemWB & Rd_MemWB != 31 & Rd_MemWB == Rm)
            ForwardB = 2'b01;
    end
    
endmodule
