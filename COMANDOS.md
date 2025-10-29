# Guía Rápida de Comandos

## 🔧 Para Simular (Verificar que funciona)

### Opción 1: Usando el script helper
```bash
chmod +x helper.sh
./helper.sh simulate
```

### Opción 2: Manual con iverilog
```bash
# En Mac/Linux:
cd /Users/domingo/Downloads/ArqCompu_Pr3_Grupo_7-main/ArqCompu_Pr3_Grupo_7-main

# Compilar con flag SIMULATION
iverilog -DSIMULATION -o test.out \
    src/core/testbench_contador.v \
    src/core/computer.v \
    src/core/pc.v \
    src/core/instruction_memory.v \
    src/core/control_unit.v \
    src/core/register.v \
    src/core/alu.v \
    src/core/muxA.v \
    src/core/muxB.v \
    src/core/mux2.v \
    src/core/mux_address.v \
    src/core/data_memory.v

# Ejecutar
vvp test.out

# Ver ondas (opcional)
gtkwave testbench_contador.vcd
```

---

## 🚀 Para FPGA (APIO)

### 1. Verificar configuración
```bash
cd /Users/domingo/Downloads/ArqCompu_Pr3_Grupo_7-main/ArqCompu_Pr3_Grupo_7-main
apio verify
```

### 2. Construir (sintetizar)
```bash
apio build
```

Si falla, revisar errores en la salida. Problemas comunes:
- Módulos faltantes
- Nombres de señales incorrectos
- Sintaxis Verilog

### 3. Flashear a la Go Board
```bash
# Conectar la FPGA al USB primero
apio upload
```

### 4. Limpiar build anterior
```bash
apio clean
```

---

## 🏭 Para OpenLane (ASIC)

### Desde la VM de Zero to ASIC:

```bash
# 1. Copiar tu proyecto a la VM
# (usar scp, sftp, o carpeta compartida)

# 2. Navegar al proyecto
cd /path/to/ArqCompu_Pr3_Grupo_7-main

# 3. Ejecutar OpenLane
flow.tcl -design . -tag run1

# 4. Ver reportes
cd runs/run1/reports/

# Área del chip
grep "Die area" floorplan/2-initial_fp.rpt

# Cantidad de compuertas
grep "Number of cells" synthesis/1-synthesis.stat.rpt

# Verificar GDS
ls -lh ../results/signoff/top.gds

# Densidad
grep "utilization" placement/9-global_placement.rpt

# Timing
grep "slack" signoff/*timing.rpt | head -5
```

---

## 🐛 Troubleshooting

### Simulación no encuentra im.dat
```bash
# Asegúrate de estar en la raíz del proyecto
pwd
# Debe mostrar: /Users/domingo/Downloads/ArqCompu_Pr3_Grupo_7-main/ArqCompu_Pr3_Grupo_7-main

# Verifica que im.dat existe
ls -la src/core/im.dat
```

### APIO no encuentra la placa
```bash
# Listar dispositivos USB
apio system --lsusb

# Verificar permisos (Linux)
sudo apio drivers --serial-enable

# En Mac, instalar drivers FTDI si es necesario
```

### Build de APIO falla con errores de sintaxis
```bash
# Verificar sintaxis de cada módulo
iverilog -tnull src/main.v src/core/*.v

# Si hay errores, revisar:
# - Declaraciones de módulos
# - Nombres de señales
# - Coincidencia entre .pcf y main.v
```

---

## ✅ Checklist Pre-Entrega

### Para FPGA:
- [ ] `apio build` completa sin errores
- [ ] `hardware.pcf` mapea todos los pines necesarios
- [ ] Los nombres en `main.v` coinciden con `hardware.pcf`
- [ ] Testbench simula correctamente (valores 15→0)

### Para OpenLane:
- [ ] `config.json` existe en la raíz
- [ ] Todos los archivos .v listados en `VERILOG_FILES` existen
- [ ] `CLOCK_PORT` coincide con el nombre en `main.v` (`i_Clk`)
- [ ] El módulo top se llama `top` (no `main`)

### Para Demostración:
- [ ] Sabes dónde encontrar área del chip
- [ ] Sabes dónde encontrar cantidad de compuertas
- [ ] Sabes dónde está el archivo GDS
- [ ] Puedes mostrar el programa funcionando en FPGA
- [ ] Los LEDs muestran binario (0000 a 1111)
- [ ] El display muestra decimal (00 a 15)

---

## 📝 Comandos Útiles Adicionales

### Ver estructura del proyecto
```bash
tree -L 3
# o
find . -name "*.v" -o -name "*.json" -o -name "*.pcf"
```

### Contar líneas de código
```bash
wc -l src/core/*.v
```

### Buscar errores en logs
```bash
grep -i "error" _build/hardware.log
grep -i "warning" _build/hardware.log
```

### Verificar módulos Verilog
```bash
# Ver todos los módulos definidos
grep "^module" src/core/*.v src/main.v
```

---

## 🎯 Para el Día de la Entrega

### Antes de llegar:

1. **Simular**:
   ```bash
   ./helper.sh simulate
   # Verificar output: "TODOS LOS TESTS PASARON"
   ```

2. **Build exitoso**:
   ```bash
   ./helper.sh build
   # Debe completar sin errores
   ```

3. **Tener en USB** (backup):
   - Todo el proyecto
   - Reportes de OpenLane (si ya corriste)
   - Este README y las guías

### Durante la demo:

1. **Mostrar FPGA**:
   ```bash
   apio upload
   # Verificar que LEDs y display muestran 15→0
   ```

2. **Mostrar OpenLane** (en VM):
   ```bash
   cd /path/to/proyecto
   # Mostrar reportes ya generados
   cat runs/run1/reports/synthesis/1-synthesis.stat.rpt
   ```

3. **Responder preguntas**:
   - Usar `GUIA_OPENLANE.md` como referencia
   - Tener los comandos grep listos

---

¡Todo listo! 🚀
