# Proyecto 3 - Arquitectura de Computadores
## CPU de 8-bits: De RTL a GDS y FPGA

### 📋 Descripción
Este proyecto implementa un CPU de 8-bits que cuenta regresivamente de 15 a 0, mostrando el resultado en:
- **4 LEDs**: Valor en binario (bits 0-3)
- **Display de 7 segmentos**: Valor en decimal (00-15)

---

## 🚀 Uso con APIO (FPGA)

### 1. Verificar síntesis
```bash
apio build
```

### 2. Flashear a la Go Board
```bash
apio upload
```

### 3. Simular (opcional)
Para simular, usar la flag de compilación:
```bash
iverilog -DSIMULATION -o test.out src/core/testbench.v src/core/*.v
vvp test.out
```

---

## 🔧 Uso con OpenLane (ASIC)

### 1. Preparar el entorno
Desde la máquina virtual de Zero to ASIC:

```bash
cd /path/to/ArqCompu_Pr3_Grupo_7-main
```

### 2. Ejecutar OpenLane
```bash
flow.tcl -design . -tag run1
```

### 3. Encontrar parámetros del diseño

Los reportes se generan en `runs/run1/reports/`:

- **Área del chip**: `runs/run1/reports/signoff/6-grt-drc.rpt`
- **Cantidad de compuertas**: `runs/run1/reports/synthesis/1-synthesis.stat.rpt.strategy4`
- **GDS final**: `runs/run1/results/signoff/top.gds`
- **Mapa de densidad**: `runs/run1/reports/placement/*.rpt`

### Parámetros importantes a reportar:
- **DESIGN_NAME**: top
- **CLOCK_PERIOD**: 40.0 ns (25 MHz)
- **DIE_AREA**: 500 x 500 µm²
- **TARGET_DENSITY**: 55%

---

## 📁 Estructura del Proyecto

```
.
├── config.json          # Configuración de OpenLane
├── hardware.pcf         # Pin constraints para Go Board
├── apio.ini             # Configuración de APIO
├── src/
│   ├── main.v           # Módulo top principal
│   └── core/
│       ├── computer.v            # CPU principal
│       ├── pc.v                  # Program Counter
│       ├── instruction_memory.v  # ROM con programa
│       ├── control_unit.v        # Unidad de control
│       ├── alu.v                 # ALU
│       ├── register.v            # Registros A y B
│       ├── data_memory.v         # RAM
│       ├── sevenseg.v            # Decodificador 7-seg
│       ├── mux*.v                # Multiplexores
│       └── im.dat                # Programa (solo simulación)
```

---

## 🔍 Programa del CPU

El programa en la memoria de instrucciones implementa un contador regresivo:

```assembly
0:  MOV A, 15      # Cargar 15 en registro A
1:  MOV B, 0       # Cargar 0 en registro B (Loop)
2:  CMP A, B       # Comparar A con 0
3:  JEQ 6          # Si A==0, saltar a End
4:  SUB A, 1       # A = A - 1
5:  JMP 1          # Volver a Loop
6:  MOV A, 0       # End: mantener A en 0
```

---

## ⚙️ Diferencias Simulación vs Síntesis

El código usa `ifdef SIMULATION` para separar:

### En SIMULACIÓN:
- Se carga el programa desde `im.dat` con `$readmemb`
- Se muestran mensajes de debug con `$display`

### En SÍNTESIS (FPGA/ASIC):
- El programa está hardcoded en ROM
- No hay mensajes de debug
- Optimizado para síntesis

Para simular: compile con `-DSIMULATION`
Para sintetizar: compile sin flags (comportamiento por defecto)

---

## 📊 Mapeo de Pines (Go Board)

| Señal | Pin | Descripción |
|-------|-----|-------------|
| i_Clk | 15 | Reloj 25MHz |
| o_LED_1 | 56 | LED bit 0 |
| o_LED_2 | 57 | LED bit 1 |
| o_LED_3 | 59 | LED bit 2 |
| o_LED_4 | 60 | LED bit 3 |
| o_Segment1_* | 1-4, 90-93 | Display decenas |
| o_Segment2_* | 8, 94-100 | Display unidades |

---

## ✅ Checklist de Entrega

- [x] Código sintetizable (sin $display en síntesis)
- [x] Programa cuenta 15→0 implementado
- [x] 4 LEDs muestran valor binario
- [x] Display muestra valor decimal
- [x] config.json para OpenLane
- [x] hardware.pcf para APIO
- [x] Compatible Mac/Windows

---

## 🐛 Troubleshooting

### Error: "im.dat not found" en simulación
Asegúrate de ejecutar desde la raíz del proyecto o ajustar la ruta relativa.

### Error: "port mismatch" en APIO
Verifica que los nombres en `main.v` coincidan con `hardware.pcf`.

### Display muestra valores incorrectos
La Go Board usa displays de cátodo común. Si ves valores invertidos, 
revisa la lógica de inversión en `sevenseg.v` (líneas finales).

---

## 👥 Autores
Grupo 7 - Arquitectura de Computadores 2025-20
