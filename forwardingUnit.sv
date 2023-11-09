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
    input logic [4:0] Rn, Rm, Rd_ExMem, Rd_MemWB,  // Nombre de registros a comparar
    input logic RegWrite_ExMem, RegWrite_MemWB,    // Señales de control 
    output logic [1:0] ForwardA, ForwardB          // Salida para  habilitar los mux  
    );

    always_comb begin 

    // EX hazard

        if (RegWrite_ExMem && (Rd_ExMem != 5'd31)
            && (Rd_ExMem == Rn)) ForwardA <= 2'b10;
            
        if (RegWrite_ExMem && (Rd_ExMem != 5'd31)
            && (Rd_ExMem == Rm)) ForwardB <= 2'b10; 

    // MEM hazard  

        if (RegWrite_MemWB && (Rd_MemWB != 5'd31)
            && ~(RegWrite_ExMem && (Rd_ExMem != 5'd31)      //? Negacion bien escrita?
            && (Rd_ExMem != Rn))
            && (Rd_ExMem == Rn)) ForwardA <= 2'b01;

        if (RegWrite_MemWB && (Rd_MemWB != 5'd31)
            && ~(RegWrite_ExMem && (Rd_ExMem != 5'd31)      //? Negacion bien escrita?
            && (Rd_ExMem != Rm))
            && (Rd_MemWB == Rm)) ForwardB <= 2'b01;
        
    end

endmodule
