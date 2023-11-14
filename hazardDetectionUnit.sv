module hazardDetectionUnit (input logic MemRead_IdEx, MemRead_ExMem,
                            input logic [4:0] Rd_IdEx, Rd_ExMem, Rn1_IfId, Rm2_IfId,
                            output logic stall
                           );
    always_comb begin
        if (MemRead_IdEx && ((Rd_IdEx == Rn1_IfId) || (Rd_IdEx == Rm2_IfId)))
            stall = 1'b1;
        else
            stall = 1'b0;
    end
endmodule