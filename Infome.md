# Informe Laboratorio ARMv8 en SystemVerilog 2023

# fecha de entrega: martes 14 de noviembre

# integrantes:  
- Gonzàlez Moreno Juan Cruz
- Chesta Lucas
- Solano Florencia

# Desarrollo:
# Ej 1: MOVZ
* Cambios Datapath: Para la ejecución de la instrucción MOVZ modificamos el módulo `signext` aprovechando su salida de 64 bits, utilizamos los bits `[15:0]` para el inmediato y los bits `[63,62]` para identificar el LSL. Luego modificamos el módulo ALU ,el cual ya estaba preparado para recibir la salida del signext. Agregamos un caso más dentro de ALU, la ocurrencia de un MOVZ, en cuyo caso ubicamos los bits en el lugar indicado en base al LSL con un shift correspondiente al LSL. El resto del recorrido es el normal para cualquier operación de la ALU.

* Cambios Controller: En `controller` realizamos modificaciones en `maindec`, añadimos el caso de una instrucción MOVZ y establecimos las señales de control acorde al comportamiento de la instrucción, seteamos todas las señales en 0 excepto `RegWrite` (escribimos el resultado en un registro), `ALUSrc` (usamos la salida de signext como entrada en la ALU), `ALUOp` al que le dimos el valor 11(arbitrariamente elegimos un valor que las demás instrucciones no usarán).
En el módulo `aludec` añadimos el caso de una instrucción MOVZ y le asignamos el valor 1000 a su salida `alucontrol`(arbitrariamente elegimos un valor que las demás instrucciones no usarán).


![diagrama del nuevo microprocesador](img)



## Programa en assembler LEGv8:


		    STUR X1, [X0, #0]    	// MEM 0:0x1
		    STUR X2, [X0, #8]    	// MEM 1:0x2
		    STUR X3, [X16, #0]   	// MEM 2:0x3
		    ADD X3, X4, X5
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X3, [X0, #24] 		// MEM 3:0x9
		    SUB X3, X4, X5
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X3, [X0, #32] 		// MEM 4:0xFFFFFFFFFFFFFFFF
		    SUB X4, XZR, X10
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X4, [X0, #40] 		// MEM 5:0xFFFFFFFFFFFFFFF6
		    ADD X4, X3, X4
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X4, [X0, #48] 		// MEM 6:0xFFFFFFFFFFFFFFF5
		    SUB X5, X1, X3
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X5, [X0, #56] 		// MEM 7:0x2
		    AND X5, X10, XZR
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X5, [X0, #64] 		// MEM 8:0x0
		    AND X5, X10, X3
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X5, [X0, #72] 		// MEM 9:0xA
		    AND X20, X20, X20
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X20, [X0, #80] 	// MEM 10:0x14
		    ORR X6, X11, XZR
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X6, [X0, #88] 		// MEM 11:0xB
		    ORR X6, X11, X3
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X6, [X0, #96] 		// MEM 12:0xFFFFFFFFFFFFFFFF
		    LDUR X12, [X0, #0]
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    ADD X7, X12, XZR
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X7, [X0, #104] 	// MEM 13:0x1
		    STUR X12, [X0, #112] 	// MEM 14:0x1
		    ADD XZR, X13, X14
		    STUR XZR, [X0, #120] 	// MEM 15:0x0
		    CBZ X0, L1
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X21, [X0, #128] 	// MEM 16:0x0 (si falla CBZ =21)
L1:         STUR X21, [X0, #136] 	// MEM 17:0x15
		    ADD X2, XZR, X1
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
L2:         SUB X2, X2, X1
		    ADD X24, XZR, X1
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X24, [X0, #144] 	// MEM 18:0x1 y MEM 19=0x1
		    ADD X0, X0, X8
		    CBZ X2, L2
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X30, [X0, #144] 	// MEM 20:0x1E
		    ADD X30, X30, X30
		    SUB X21, XZR, X21
		    ADD XZR, X1, X1 		// NOP
		    ADD X30, X30, X20
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    LDUR X25, [X30, #-8]
		    ADD X30, X30, X30
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    ADD X30, X30, X16
		    ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
		    STUR X25, [X30, #-8] 	// MEM 21:0xA (= MEM 9)
			MOVZ X9, #0xAAAA, lsl #00
			ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
			STUR x9, [X30, #0]		// MEM 22: AAAA
			MOVZ X9, #0xBBBB, lsl #16
			ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
			STUR x9, [X30, #8]		// MEM 23: BBBB
			MOVZ X9, #0xCCCC, lsl #32
			ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
			STUR x9, [X30, #16] 	// MEM 24: CCCC
			MOVZ X9, #0xDDDD, lsl #48
			ADD XZR, X1, X1 		// NOP
		    ADD XZR, X1, X1 		// NOP
			STUR x9, [X30, #24]		// MEM 25: DDDD

finloop:    CBZ XZR, finloop



``` 
        rom [0:103] = 
					  	'{  32'hf8000001,	// (1)
							32'hf8008002,	// (2)
							32'hf8000203,	// (3)
							32'h8b050083,	// (4)
							NOP,
							NOP,
							32'hf8018003,	// (5)
							32'hcb050083,	// (6)
							NOP,
							NOP,
							32'hf8020003,	// (7)
							32'hcb0a03e4,	// (8)
							NOP,
							NOP,	
							32'hf8028004,	// (9)
							32'h8b040064,	// (10)
							NOP,
							NOP,
							32'hf8030004,	// (11)
							32'hcb030025,	// (12)
							NOP,
							NOP,
							32'hf8038005,	// (13)
							32'h8a1f0145,	// (14)
							NOP,
							NOP,
							32'hf8040005,	// (15)
							32'h8a030145,	// (16)
							NOP,
							NOP,	
							32'hf8048005,	// (17)
							32'h8a140294,	// (18)
							NOP,
							NOP,
							32'hf8050014,	// (19)
							32'haa1f0166,	// (20)
							NOP,
							NOP,
							32'hf8058006,	// (21)
							32'haa030166,	// (22)
							NOP,
							NOP,
							32'hf8060006,	// (23)
							32'hf840000c,	// (24)
							NOP,
							NOP,
							32'h8b1f0187,	// (25)
							NOP,
							NOP,
							32'hf8068007,	// (26)
							32'hf807000c,	// (27)
							32'h8b0e01bf,	// (28)
							32'hf807801f,	// (29)
							32'hb40000a0,	// (30)
							NOP,
							NOP,
							NOP,
							32'hf8080015,	// (31)
							32'hf8088015,	// (32)
							32'h8b0103e2,	// (33)
							NOP,
							NOP,
							32'hcb010042,	// (34)
							32'h8b0103f8,	// (35)
							NOP,
							NOP,
							32'hf8090018,	// (36)
							32'h8b080000,	// (37)
							32'hb4ffff42,	// (38)
							NOP,	
							NOP,
							NOP,
							32'hf809001e,	// (39)
							32'h8b1e03de,	// (40)
							32'hcb1503f5,	// (41)
							NOP,
							32'h8b1403de,	// (42)
							NOP,
							NOP,
							32'hf85f83d9,	// (43)
							32'h8b1e03de,	// (44)
							NOP,	
							NOP,
							32'h8b1003de,	// (45)
							NOP,
							NOP,	
							32'hf81f83d9,	// (46)
							32'hd2800069,		// MOVZ X9, #0x0003, lsl #00 
							NOP,
							NOP,
							32'hf80003c9,		// STUR x9, [X30, #0]		
							32'hd2bfffe9,		// MOVZ X9, #0xFFFF, lsl #01
							NOP,
							NOP,
							32'hf80083c9,		// STUR x9, [X30, #8] 
							32'hd2caaaa9,		// MOVZ X9, #0x5555, lsl #10
							NOP,
							NOP,
							32'hf80103c9,		// STUR x9, [X30, #16]
							32'hd2ffffe9,		// MOVZ X9, #0xFFFF, lsl #11
							NOP,
							NOP,
							32'hf80183c9,		// STUR x9, [X30, #24]
							32'hb400001f		// (47)
							}; */	 
```















