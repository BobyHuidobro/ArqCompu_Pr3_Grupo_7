# 🚀 CHEAT SHEET - Demo Rápida
## Proyecto 3 - Grupo 7

---

## ⚡ COMANDOS ESENCIALES

```bash
# Activar entorno
source apio-env/bin/activate

# Flashear FPGA
apio upload

# Si necesitas recompilar
apio build && apio upload
```

---

## 🎯 QUÉ DEBE PASAR

1. **Display:** 15 → 14 → 13 → ... → 00
2. **LEDs:** 1111 → 1110 → ... → 0000
3. **Tiempo:** ~0.67 seg por decremento
4. **Al llegar a 0:** Se detiene

---

## 💬 RESPUESTAS RÁPIDAS

### "¿Cómo funciona?"
"El CPU ejecuta un programa de 7 instrucciones almacenado en ROM:
carga 15 en A, luego loop: compara con 0, si no es 0 decrementa,
si es 0 termina. Los LEDs muestran bits 0-3 en binario, el display
muestra el valor en decimal."

### "¿Está hardcoded?"
"No. Es un programa que el CPU ejecuta instrucción por instrucción.
Está en la memoria ROM (instruction_memory.v) pero el CPU lo procesa
con fetch-decode-execute."

### "¿Dónde está el programa?"
"En instruction_memory.v, líneas 25-52, en el bloque `initial`
para síntesis. Son 7 instrucciones de 15 bits cada una."

### "¿Qué frecuencia usa?"
"El reloj de la Go Board es 25 MHz. Lo divido con un contador
de 25 bits (div_clk). El CPU usa div_clk[24] que da ~1.5 Hz
para que el conteo sea visible."

---

## 📊 PARÁMETROS OPENLANE

Si piden ver parámetros del diseño:

**Área:**
- Archivo: `runs/<run>/reports/final_summary_report.csv`
- Buscar: `chip_area_mm2` o `die_area_um2`

**Compuertas:**
- Archivo: `runs/<run>/reports/synthesis/1-synthesis.AREA_0.stat.rpt`
- Buscar: `Number of cells`

**GDS:**
- Ubicación: `runs/<run>/results/final/gds/<design>.gds`
- Visualizar: KLayout

**Densidad:**
- Mapas en: `runs/<run>/reports/placement/` y `/routing/`

---

## 🔧 ARQUITECTURA EN 30 SEGUNDOS

"CPU de 8 bits, arquitectura Harvard, instrucciones de 15 bits.
Tiene registros A y B, ALU de 16 operaciones, Program Counter,
registro de Status para flags. Soporta saltos condicionales.
Conectado a 4 LEDs y display de 7 segmentos vía módulo sevenseg
que convierte binario a BCD."

---

## 📝 PROGRAMA ASSEMBLY

```
0: MOV A, 15   ; Iniciar en 15
1: MOV B, 0    ; Loop: B = 0
2: CMP A, B    ; Comparar
3: JEQ 6       ; Si A==0, saltar a End
4: SUB A, 1    ; A = A - 1
5: JMP 1       ; Volver a Loop
6: MOV A, 0    ; End
```

---

## ⚠️ SI ALGO FALLA

### FPGA no detectada
```bash
ls /dev/cu.*  # Ver dispositivos
# Reconectar cable USB
```

### Display no muestra
- Verificar lógica negativa en hardware.pcf
- Revisar conexión física

### Muy rápido/lento
- Cambiar bit del divisor en main.v
- Actual: [24] ≈ 1.5 Hz

---

## ✅ CHECKLIST DEMO

- [ ] FPGA conectada
- [ ] `apio upload` ejecutado
- [ ] Display cuenta 15→0
- [ ] LEDs muestran binario
- [ ] Explicación clara al ayudante

---

**¡ÉXITO!** 🎉
