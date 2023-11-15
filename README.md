# ArquitecturaLab1

modificaciones en imem.sv --> flush con salida en 0

datapath modificado --> nueva señal flush
- ID_EX con control en 0 (se modifico el mux de control para q sea 0 con flush tmb)
- EX_MEM con control en 0 (se agrego un mux de control para q sea 0 con flush)
- se setea flush = PCSrc

se modifico processor_arm.sv para hacer las conecciones de flush