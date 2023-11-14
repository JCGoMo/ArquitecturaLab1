# Laboratorio ARMv8 en SystemVerilog

**Fecha de entrega:** martes 14 de noviembre

## Integrantes
- González Moreno, Juan Cruz
- Chesta, Lucas
- Solano, Florencia

# 1) Implementación de la Instrucción MOVZ en un Microprocesador con Pipeline

## Introducción
En el marco del proyecto, se ha llevado a cabo la implementación de la instrucción MOVZ en un microprocesador con pipeline. La instrucción MOVZ, que significa "Move wide with zero", permite cargar valores inmediatos en un registro, especificando la posición del valor inmediato mediante bits de desplazamiento LSL.

## Modificaciones Introducidas

## 1. Cambios en el Datapath

### 1.1 Modificación en el módulo `signext`
Se realizó una modificación en el módulo `signext` para aprovechar su salida de 64 bits. Los bits `[15:0]` se utilizan para representar el inmediato, mientras que los bits `[63:62]` identifican el LSL. Esta adaptación permite un manejo eficiente de la información necesaria para la instrucción MOVZ.

### 1.2 Modificación en el módulo `ALU`
Dentro del módulo `ALU`, se incorporó un caso adicional para la instrucción MOVZ. Cuando se detecta esta instrucción, se posicionan los bits según el LSL indicado, utilizando un desplazamiento correspondiente. El resto del proceso sigue la lógica estándar para cualquier operación de la ALU.

## 2. Cambios en el Controller

### 2.1 Modificación en el módulo maindec
En el módulo `maindec` del `controller`, se añadió un caso específico para la instrucción MOVZ. Se establecieron las señales de control de manera acorde al comportamiento de esta instrucción, configurando `RegWrite` para escribir el resultado en un registro, `ALUSrc` para utilizar la salida de `signext` como entrada en la `ALU`, y `ALUOp` con el valor 11, seleccionado arbitrariamente para diferenciar la instrucción MOVZ de las demás.

### 2.2 Modificación en el módulo aludec
En el módulo `aludec`, se incorporó un caso adicional para la instrucción MOVZ. La salida `alucontrol` se ajustó con el valor 1000, seleccionado arbitrariamente para distinguir la instrucción MOVZ de las demás.

## Diagrama del Nuevo Microprocesador

![diagrama del nuevo microprocesador](img)

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
