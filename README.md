# ArquitecturaLab1I

Creacion de ForwardingUnit y mux3
(Si no funciona ForwardingUnit ver de nuevo los registros de las guardas)

MOdificamos execute.sv (agregamos la forwardingUnit y los mux3)

Modificamos decode.sv (agregamos rn_reg, rm_reg)

Modificamos Datapath: 
    - dos señales (logic [4:0] rn_reg, rm_reg; //Nuevo)
    - el registro flopr 	#(281)	ID_EX , agregamos las señales rn_reg, rm_reg (ahora tiene 10 bits mas)
    - execute: conectamos señales nuevas (comentadas e datapath)
    - decode:


Terminar informe del punto 1 => imagen del datapath.
Agregar imagenes, corregir el codigo imem => Agregar codigo en assembler y especificar cual es la nop.