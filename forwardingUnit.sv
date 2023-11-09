/* 
1. EX hazard:
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ≠ 31)
and (EX/MEM.RegisterRd = ID/EX.RegisterRn1)) ForwardA = 10
if (EX/MEM.RegWrite
and (EX/MEM.RegisterRd ≠ 31)
and (EX/MEM.RegisterRd = ID/EX.RegisterRm2)) ForwardB = 10 

2. MEM hazard:
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ≠ 31)
and (MEM/WB.RegisterRd = ID/EX.RegisterRn1)) ForwardA = 01
if (MEM/WB.RegWrite
and (MEM/WB.RegisterRd ≠ 31)
and (MEM/WB.RegisterRd = ID/EX.RegisterRm2)) ForwardB = 01

2. MEM hazard v2:

if (MEM/WB.RegWrite and (MEM/WB.RegisterRd ≠ 31)
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 31)
and (EX/MEM.RegisterRd ≠ ID/EX.RegisterRn1))
and (MEM/WB.RegisterRd = ID/EX.RegisterRn1)) ForwardA = 01
if (MEM/WB.RegWrite and (MEM/WB.RegisterRd ≠ 31)
and not(EX/MEM.RegWrite and (EX/MEM.RegisterRd ≠ 31)
and (EX/MEM.RegisterRd ≠ ID/EX.RegisterRm2))
and (MEM/WB.RegisterRd = ID/EX.RegisterRm2)) ForwardB = 01

*/

module forwardingUnit #(parameter N = 64) (
    input logic [4:0] Rn, Rm, Rd_ExMem, Rd_MemWB,
    input logic RegWrite_ExMem, RegWrite_MemWB,
    output logic [1:0] ForwardA, ForwardB
);

    always_comb begin
        // Resetear las salidas antes de hacer nuevas asignaciones
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // EX hazard
        if (RegWrite_ExMem && (Rd_ExMem != 5'd31)) begin
            if (Rd_ExMem == Rn) ForwardA = 2'b10;
            if (Rd_ExMem == Rm) ForwardB = 2'b10;
        end

        // MEM hazard
        if (RegWrite_MemWB && (Rd_MemWB != 5'd31)) begin
            if (~RegWrite_ExMem || ((Rd_ExMem != Rn) && (Rd_ExMem != Rm))) begin
                if (Rd_MemWB == Rn) ForwardA = 2'b01;
                if (Rd_MemWB == Rm) ForwardB = 2'b01;
            end
        end
    end

endmodule

