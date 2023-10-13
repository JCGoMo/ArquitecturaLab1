module execute #(parameter N=64)
    (input logic AluSrc,
     input logic [3:0] AluControl,
     input logic [N-1:0] PC_E, signImm_E, readData1_E, readData2_E,
     output logic [N-1:0] PCBranch_E, aluResult_E, writeData_E,
     output logic zero_E);
     logic [N-1:0] muxOut, shiftOut;

    mux2 mymux(readData2_E, signImm_E, AluSrc, muxOut);

    sl2 myshift(signImm_E, shiftOut);

    adder myAdd(PC_E, shiftOut, PCBranch_E);

    alu myAlu(readData1_E, muxOut, AluControl, aluResult_E, zero_E);

    assign writeData_E = readData2_E;
    
endmodule

