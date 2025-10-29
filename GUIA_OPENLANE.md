# Guía OpenLane - Parámetros del Diseño

## 📊 Respuestas para el Ayudante

Esta guía te ayuda a encontrar la información que el ayudante te pedirá durante la demostración de OpenLane.

---

## 🚀 Ejecutar OpenLane

### En la VM de Zero to ASIC:

```bash
# 1. Navegar a tu proyecto
cd /path/to/ArqCompu_Pr3_Grupo_7-main

# 2. Ejecutar el flujo completo
flow.tcl -design . -tag run1

# O paso a paso:
flow.tcl -design . -tag run1 -init_design_config
flow.tcl -design . -tag run1 -run_synthesis
flow.tcl -design . -tag run1 -run_floorplan
flow.tcl -design . -tag run1 -run_placement
flow.tcl -design . -tag run1 -run_routing
```

---

## 📁 Estructura de Reportes

Después de ejecutar OpenLane, los reportes se generan en:

```
runs/
└── run1/
    ├── reports/
    │   ├── synthesis/
    │   ├── floorplan/
    │   ├── placement/
    │   ├── routing/
    │   └── signoff/
    ├── results/
    │   ├── synthesis/
    │   ├── floorplan/
    │   ├── placement/
    │   └── signoff/
    └── logs/
```

---

## 🔍 Dónde Encontrar Cada Parámetro

### 1. **Área del Chip (Die Area)**

**Archivo**: `runs/run1/reports/floorplan/2-initial_fp.rpt`

```bash
# Buscar línea:
grep "Die area" runs/run1/reports/floorplan/2-initial_fp.rpt
```

**Ejemplo de output**:
```
Die area: 0.00 0.00 500.00 500.00 (250000.00 µm²)
```

**Respuesta**: "El área del chip es 250,000 µm² (500 x 500 µm)"

---

### 2. **Cantidad de Compuertas (Gate Count)**

**Archivo**: `runs/run1/reports/synthesis/1-synthesis.stat.rpt`

```bash
# Ver resumen:
cat runs/run1/reports/synthesis/1-synthesis.stat.rpt | grep -A 20 "Number of cells"
```

**Buscar**:
- `Number of cells`: Total de celdas
- Por tipo de celda: AND, OR, NOT, DFF, etc.

**Ejemplo**:
```
Number of cells:                    458
  sky130_fd_sc_hd__and2_1            23
  sky130_fd_sc_hd__dff_1             85
  sky130_fd_sc_hd__nand2_1           42
  ...
```

**Respuesta**: "El diseño tiene 458 celdas estándar, incluyendo 85 flip-flops"

---

### 3. **Archivo GDS (Layout Final)**

**Ubicación**: `runs/run1/results/signoff/top.gds`

```bash
# Verificar que existe:
ls -lh runs/run1/results/signoff/top.gds
```

**Para visualizar**:
```bash
# Usar KLayout (si está instalado):
klayout runs/run1/results/signoff/top.gds
```

**Respuesta**: "El archivo GDS está en runs/run1/results/signoff/top.gds"

---

### 4. **Mapa de Densidad de Potencia**

**Archivo**: `runs/run1/reports/routing/14-pdn.rpt`

```bash
cat runs/run1/reports/routing/14-pdn.rpt
```

**Buscar**:
- Power grid structure
- Via count
- Wire segments

**También en**: `runs/run1/reports/signoff/` (archivos de power analysis)

**Respuesta**: "El reporte de power delivery network muestra [datos específicos]"

---

### 5. **Mapa de Densidad de Compuertas**

**Archivo**: `runs/run1/reports/placement/9-global_placement.rpt`

```bash
cat runs/run1/reports/placement/9-global_placement.rpt
```

**Buscar**:
- `Instance density`: Porcentaje de área ocupada
- `Core utilization`: Utilización del core

**Ejemplo**:
```
Core area: 245000 µm²
Instance area: 110250 µm²
Core utilization: 45.0%
```

**Respuesta**: "La densidad de compuertas es 45%, con utilización del core de 110,250 µm²"

---

### 6. **Frecuencia Máxima / Timing**

**Archivo**: `runs/run1/reports/signoff/top-rcx_sta.timing.rpt`

```bash
# Ver slack (diferencia con el objetivo):
grep -A 5 "slack" runs/run1/reports/signoff/*timing.rpt | head -20
```

**Buscar**:
- `Setup slack`: Margen de tiempo para setup
- `Hold slack`: Margen de tiempo para hold
- `Worst negative slack (WNS)`: Peor violación

**Ejemplo**:
```
Setup slack: 5.23 ns (MET)
Hold slack: 0.45 ns (MET)
Maximum frequency: 28.5 MHz
```

**Respuesta**: "El diseño cumple timing con 5.23 ns de slack, soportando hasta 28.5 MHz"

---

### 7. **Cantidad de Violaciones de DRC**

**Archivo**: `runs/run1/reports/signoff/6-grt-drc.rpt`

```bash
cat runs/run1/reports/signoff/6-grt-drc.rpt | grep -i "violation"
```

**Ideal**: 0 violations

**Respuesta**: "El diseño tiene 0 violaciones de DRC" o "Hay X violaciones que necesitan corrección"

---

### 8. **Potencia Estimada**

**Archivo**: `runs/run1/reports/signoff/top-rcx_sta.power.rpt`

```bash
cat runs/run1/reports/signoff/top-rcx_sta.power.rpt
```

**Buscar**:
- `Total power`: Potencia total
- `Internal power`: Potencia interna de celdas
- `Switching power`: Potencia de switching
- `Leakage power`: Potencia de fuga

**Ejemplo**:
```
Total Power: 2.45 mW
  Internal: 1.23 mW (50.2%)
  Switching: 0.98 mW (40.0%)
  Leakage: 0.24 mW (9.8%)
```

**Respuesta**: "La potencia total estimada es 2.45 mW"

---

## 📝 Resumen de Comandos Rápidos

```bash
# Después de ejecutar OpenLane, usar estos comandos:

# 1. Área
grep "Die area" runs/run1/reports/floorplan/2-initial_fp.rpt

# 2. Compuertas
grep "Number of cells" runs/run1/reports/synthesis/1-synthesis.stat.rpt

# 3. GDS existe
ls -lh runs/run1/results/signoff/top.gds

# 4. Densidad
grep "utilization" runs/run1/reports/placement/9-global_placement.rpt

# 5. Timing
grep "slack" runs/run1/reports/signoff/*timing.rpt | head -5

# 6. DRC
grep -i "violation" runs/run1/reports/signoff/6-grt-drc.rpt

# 7. Potencia
cat runs/run1/reports/signoff/top-rcx_sta.power.rpt | grep "Total"
```

---

## 🎯 Configuración del Diseño

Nuestro `config.json` especifica:

| Parámetro | Valor | Significado |
|-----------|-------|-------------|
| DESIGN_NAME | top | Nombre del módulo top |
| CLOCK_PORT | i_Clk | Puerto de reloj |
| CLOCK_PERIOD | 40.0 ns | Período objetivo (25 MHz) |
| DIE_AREA | 500 x 500 µm | Área del chip |
| TARGET_DENSITY | 55% | Objetivo de densidad |

---

## 🔧 Si OpenLane Falla

### Errores Comunes:

1. **"No module named 'top'"**
   - Verifica que `config.json` tiene `"DESIGN_NAME": "top"`
   - Asegúrate que `src/main.v` define `module top`

2. **"Cannot find Verilog files"**
   - Verifica paths en `VERILOG_FILES` de `config.json`
   - Usa rutas relativas con `dir::`

3. **"Clock port not found"**
   - Verifica que el puerto se llama `i_Clk` en `main.v`
   - Debe coincidir con `"CLOCK_PORT": "i_Clk"` en config

4. **"Timing violations"**
   - Aumenta `CLOCK_PERIOD` en `config.json` (ej: 50.0 ns)
   - Acepta frecuencias más bajas

5. **"DRC violations"**
   - Reduce `TARGET_DENSITY` (ej: a 0.45)
   - Aumenta `DIE_AREA`

---

## 📊 Tabla de Respuestas Preparadas

Imprime esto y llévalo a la demo:

| Pregunta del Ayudante | Archivo | Comando |
|-----------------------|---------|---------|
| ¿Cuál es el área? | `floorplan/2-initial_fp.rpt` | `grep "Die area" ...` |
| ¿Cuántas compuertas? | `synthesis/1-synthesis.stat.rpt` | `grep "Number of cells" ...` |
| ¿Dónde está el GDS? | `results/signoff/top.gds` | `ls -lh ...` |
| ¿Cuál es la densidad? | `placement/9-global_placement.rpt` | `grep "utilization" ...` |
| ¿Cumple timing? | `signoff/*timing.rpt` | `grep "slack" ...` |
| ¿Tiene DRC violations? | `signoff/6-grt-drc.rpt` | `grep "violation" ...` |
| ¿Cuánta potencia consume? | `signoff/*power.rpt` | `cat ... \| grep "Total"` |

---

## 💡 Tips para la Demo

1. **Antes de llegar**: Corre `flow.tcl` y revisa que no hay errores
2. **Ten los reportes listos**: Abre los archivos principales en tabs
3. **Usa grep**: Es más rápido que buscar manualmente
4. **Conoce los números**: Memoriza área, compuertas y timing
5. **Practica navegar**: Familiarízate con la estructura de carpetas

¡Buena suerte! 🚀
