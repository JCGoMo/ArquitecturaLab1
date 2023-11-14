# **Laboratorio ARMv8 en SystemVerilog**

**Fecha de entrega:** martes 14 de noviembre

## Integrantes
- González Moreno, Juan Cruz
- Chesta, Lucas
- Solano, Florencia

# 1) Implementación de la Instrucción MOVZ en un Microprocesador con Pipeline

## Introducción
En el marco del proyecto, se ha llevado a cabo la implementación de la instrucción MOVZ en un microprocesador con pipeline. La instrucción MOVZ, que significa "Move wide with zero", permite cargar valores inmediatos en un registro, especificando la posición del valor inmediato mediante bits de desplazamiento LSL.

## Modificaciones Introducidas

### 1. Cambios en el Datapath

- Modificación en el módulo `signext`:
  
	Se realizó una modificación en el módulo `signext` para aprovechar su salida de 64 bits. Los bits `[15:0]` se utilizan para representar el inmediato, mientras que los bits `[63:62]` identifican el LSL. Esta adaptación permite un manejo eficiente de la información necesaria para la instrucción MOVZ.

- Modificación en el módulo `ALU`:

	Dentro del módulo `ALU`, se incorporó un caso adicional para la instrucción MOVZ. Cuando se detecta esta instrucción, se posicionan los bits según el LSL indicado, utilizando un desplazamiento correspondiente. El resto del proceso sigue la lógica estándar para cualquier operación de la ALU.

### 2. Cambios en el Controller

- Modificación en el módulo `maindec`:

	Se añadió un caso específico para la instrucción MOVZ. Se establecieron las señales de control de manera acorde al comportamiento de esta instrucción, configurando `RegWrite` para escribir el resultado en un registro, `ALUSrc` para utilizar la salida de `signext` como entrada en la `ALU`, y `ALUOp` con el valor 11, seleccionado arbitrariamente para diferenciar la instrucción MOVZ de las demás.

- Modificación en el módulo `aludec`:

	Se incorporó un caso adicional para la instrucción MOVZ. La salida `alucontrol` se ajustó con el valor 1000, seleccionado arbitrariamente para distinguir la instrucción MOVZ de las demás.

## Recorrido de la Instrucción MOVZ

![diagrama del nuevo microprocesador](imagenes/datapath.png)

## Verificación de la Implementación

Para verificar la correcta implementación, se agregaron al final del código proporcionado las siguientes instrucciones MOVZ con distintos valores numéricos y de LSL. 

```css
		MOVZ x9, #0xAAAA, lsl #00 
		STUR x9, [X30, #0]

		MOVZ X9, #0xBBBB, lsl #16
		STUR X9, [X30, #8]

		MOVZ X9, #0xCCCC, lsl #32
		STUR X9, [X30, #16]

		MOVZ X9, #0xDDDD, lsl #48
		STUR X9, [X30, #24]
```

Los resultados se compararon con los valores esperados almacenados en el archivo "mem.dump" al finalizar la ejecución del código.

## Resultados y Conclusiones
La instrucción MOVZ se integró exitosamente en el microprocesador con pipeline, manteniendo la funcionalidad de las instrucciones existentes. Las modificaciones en el datapath y en el controller se llevaron a cabo de manera coherente, y la verificación con programas de prueba confirmó el correcto funcionamiento del microprocesador ampliado.

# 2) Implementación de Hazard Detection Unit y Forwarding Unit en el Procesador LEGv8

## Introducción
En el marco de la evolución del procesador LEGv8, se ha implementado un bloque de Hazard Detection Unit (HDU) y otro de Forwarding Unit con el objetivo de abordar y gestionar de manera eficiente los data hazards en el pipeline. La técnica de forwarding-stall se ha aplicado para minimizar el impacto de estos hazards, permitiendo un flujo de ejecución más suave.

## Modificaciones Realizadas 

### 1. Hazard Detection Unit (HDU) en el Bloque Instruction Decode (ID):
   
Se implementó un bloque de Hazard Detection Unit (HDU) en la instancia del Instruction Decode (ID). Este bloque analiza las condiciones detalladas en el capítulo 4.7 del libro "Computer Organization and Design - ARM Edition" para detectar data hazards de distintos tipos. Las dependencias de datos se han considerado exhaustivamente para abordar situaciones de riesgo.

![Hazard Detection Unit](imagenes/hdu.png)

### 2. Forwarding Unit en el Bloque Execute (EX):

Se creó una nueva entidad denominada `Forwarding Unit` encargada de gestionar el forwarding de datos entre etapas del pipeline, contribuyendo así a la mitigación de data hazards. Esta unidad permite dirigir los datos adecuadamente para evitar stalls innecesarios.

![Forwarding Unit](imagenes/forwarding.png)

### 3. Nuevo Registro FLOPRE

Se diseñó un nuevo registro denominado `flopr_e`, similar al FLOPR pero con la adición de una señal de enable. Cuando el enable está activado (enable = 1), el `flopr_e` opera de manera normal; sin embargo, al detectar un flanco de CLK con enable desactivado (enable = 0), congela su valor y evita cambios en el pipeline.

Esta variacion se aplicó en el `flopr` del modulo `#fetch`. Su función principal es congelar el valor del Program Counter (PC) al surgir un stall. Asimismo, se aplicó esta variante en el pipeline IF_ID para preservar el valor de la instrucción cuando se presenta un stall, tanto en el interior del módulo #datapath como en el módulo `#processor_arm`.

### 4. Modificaciones en el Datapath

Se agregaron las siguientes señales al datapath:

- `stall_out`:  señal de stall que se propaga hacia el modulo `#processor_arm`.
- `rn_reg`, `rm_reg`: señales de los registros de los operandos de la instrucción con los que el forwarding unit debe trabajar.
- `control_mux` : señales de control para el multiplexor de control de la unidad de forwarding.

Ademas de cada conexion de señales internas entre los modulos.

