# 📋 VALIDACIÓN DEL PROYECTO 3
## Grupo 7 - Arquitectura de Computadores
### Fecha: 29 de octubre de 2025

---

## ✅ RESUMEN DE VALIDACIÓN

### 1. SÍNTESIS CON APIO (FPGA) - ✓ COMPLETADO

**Comando ejecutado:**
```bash
source apio-env/bin/activate
apio build
```

**Resultado:**
```
[SUCCESS] Took 22.78 seconds
```

**Archivos generados:**
- ✅ `hardware.bin` (31 KB) - Binario listo para flashear
- ✅ `hardware.json` (677 KB) - Netlist sintetizada
- ✅ `hardware.asc` (265 KB) - ASCII configuration
- ✅ `hardware.pcf` - Mapeo de pines Go Board

**Interpretación:** El diseño sintetizó correctamente para la FPGA iCE40-HX1K.

---

### 2. SIMULACIÓN DEL TESTBENCH - ✓ TODOS LOS TESTS PASARON

**Comando ejecutado:**
```bash
iverilog -g2005-sv -DSIMULATION -o test.out \
  src/core/testbench_contador.v \
  src/core/alu.v src/core/computer.v src/core/control_unit.v \
  src/core/data_memory.v src/core/instruction_memory.v \
  src/core/jump_logic.v src/core/mux2.v src/core/muxA.v \
  src/core/muxB.v src/core/mux_address.v src/core/pc.v \
  src/core/register.v src/core/sevenseg.v src/core/status_register.v

vvp test.out
```

**Resultado:**
```
===========================================
   ✓✓✓ TODOS LOS TESTS PASARON ✓✓✓
===========================================
```

**Tests validados:**
1. ✅ Registro A inicializado correctamente a 15
2. ✅ A está decrementando correctamente
3. ✅ A llegó a 0 correctamente
4. ✅ A se mantiene en 0 después de terminar
5. ✅ Programa reinicia (PC vuelve a 0, A vuelve a 15)

**Archivo VCD generado:**
- ✅ `testbench_contador.vcd` (46 KB) - Visualizable con GTKWave

---

## 🔧 ARQUITECTURA DEL PROYECTO

### Módulo TOP (main.v)
```verilog
module top (
    input i_Clk,              // 25 MHz de Go Board
    output o_LED_1,           // Bit 0 de regA
    output o_LED_2,           // Bit 1 de regA
    output o_LED_3,           // Bit 2 de regA
    output o_LED_4,           // Bit 3 de regA
    output [6:0] Segment1,    // Display decenas
    output [6:0] Segment2     // Display unidades
);
```

**Funcionalidad:**
- Divisor de reloj: 25 MHz → ~1.5 Hz (div_clk[24])
- LEDs muestran bits 0-3 de regA en binario
- Display muestra regA en decimal (0-15)
- CPU ejecuta programa contador 15→0

### Programa en Memoria de Instrucciones
```assembly
Addr | Binario          | Assembler
-----|------------------|---------------------------
  0  | 000001000001111  | MOV A, 15      ; Cargar 15 en A
  1  | 000001100000000  | MOV B, 0       ; Loop: Cargar 0 en B
  2  | 100110100000000  | CMP A, B       ; Comparar A con B
  3  | 101010000000110  | JEQ End        ; Si A==0, saltar a 6
  4  | 000101000000001  | SUB A, 1       ; A = A - 1
  5  | 101001100000001  | JMP Loop       ; Saltar a 1
  6  | 000001000000000  | End: MOV A, 0  ; Dejar A en 0
  7+ | 000000000000000  | NOP            ; No operation
```

**Comportamiento esperado en FPGA:**
1. Al conectar, A = 15 (LEDs: 1111, Display: 15)
2. Cada ~0.67 segundos decrementa
3. Secuencia: 15 → 14 → 13 → ... → 1 → 0
4. Al llegar a 0, se detiene
5. LEDs y display muestran 0

---

## 🎯 RESPUESTAS PARA EL AYUDANTE

### Pregunta: "¿Cómo funciona el programa contador?"
**Respuesta:**
El programa carga 15 en el registro A, luego entra en un loop que:
1. Compara A con 0
2. Si A != 0, decrementa A y repite
3. Si A == 0, termina

Esto NO está implementado directamente en Verilog, sino que es un programa
que ejecuta el CPU instrucción por instrucción, cumpliendo con el requisito
de que "debe ser a través de su core".

### Pregunta: "¿Cómo se muestran los resultados?"
**Respuesta:**
- **LEDs (binario):** Los 4 bits bajos del registro A se conectan directamente
  a o_LED_1 hasta o_LED_4 mediante assign o_LED_X = regA_value[X]
  
- **Display (decimal):** El módulo sevenseg convierte el valor de regA
  (0-15) a dos dígitos BCD que se muestran en el display de 7 segmentos

### Pregunta: "¿Qué frecuencia de reloj usa?"
**Respuesta:**
- Reloj de Go Board: 25 MHz (i_Clk)
- Divisor de reloj: contador de 25 bits (div_clk)
- Reloj del CPU: div_clk[24] ≈ 1.49 Hz
- Esto hace que el conteo sea visible (~0.67 segundos por decremento)

---

## 📝 COMANDOS PARA LA DEMO

### Flashear a FPGA
```bash
source apio-env/bin/activate
apio upload
```

### Limpiar archivos generados
```bash
apio clean
```

### Re-compilar y flashear
```bash
source apio-env/bin/activate
apio build
apio upload
```

---

## 🚀 ESTADO DEL PROYECTO

| Componente | Estado | Notas |
|------------|--------|-------|
| CPU Core | ✅ Completo | 8-bit, soporte saltos, ALU funcional |
| Programa | ✅ Validado | Contador 15→0 simulado y funcionando |
| Síntesis APIO | ✅ Exitosa | hardware.bin generado (22.78s) |
| Testbench | ✅ Pasando | Todos los tests OK |
| Display 7-seg | ✅ Implementado | Conversión decimal correcta |
| LEDs binarios | ✅ Implementado | Mapeados a bits 0-3 |
| Mapeo pines | ✅ Completo | hardware.pcf configurado |
| Documentación | ✅ Completa | README, GUIA_OPENLANE, etc. |

**¡Listo para la entrega final!** 🎉
