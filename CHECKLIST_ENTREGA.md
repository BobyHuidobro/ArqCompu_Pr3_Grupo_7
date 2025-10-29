# 📋 CHECKLIST ENTREGA FINAL - Proyecto 3
## Fecha: 29 de octubre de 2025

---

## ✅ PRE-ENTREGA (Antes de ir al laboratorio)

### Archivos Verificados
- [x] `hardware.bin` generado (31 KB)
- [x] `hardware.json` generado (677 KB)
- [x] `hardware.pcf` configurado con pines Go Board
- [x] `config.json` listo para OpenLane
- [x] Todos los `.v` en la raíz del proyecto
- [x] `im.dat` creado para simulación
- [x] Testbench compilado y pasando

### Tests Ejecutados
- [x] `apio build` exitoso (22.78s)
- [x] Simulación con `iverilog + vvp` exitosa
- [x] Todos los tests del testbench pasaron
- [x] Programa cuenta correctamente 15→0

### Documentación
- [x] README.md actualizado
- [x] VALIDACION_PROGRAMA.md creado
- [x] GUIA_OPENLANE.md preparada
- [x] REPORTE_VALIDACION_FINAL.md listo
- [x] helper_nuevo.sh funcional

---

## 📱 EN EL LABORATORIO

### 1. Preparación Inicial
- [ ] Llevar laptop con proyecto
- [ ] Tener cable USB disponible
- [ ] Abrir terminal en carpeta del proyecto
- [ ] Activar entorno: `source apio-env/bin/activate`

### 2. Demo FPGA (4 puntos)
- [ ] Conectar FPGA Go Board
- [ ] Ejecutar: `apio upload`
- [ ] Verificar que flashea correctamente
- [ ] **Observar comportamiento:**
  - [ ] Display muestra 15 inicialmente
  - [ ] Cuenta regresiva visible: 15→14→13...→0
  - [ ] LEDs muestran binario (1111→1110→...→0000)
  - [ ] Al llegar a 0, se mantiene
  - [ ] Tiempo entre decrementos: ~0.67 segundos

### 3. Explicación al Ayudante
**Preparar respuestas a:**

#### "¿Cómo funciona?"
- [ ] Explicar: CPU ejecuta programa de 7 instrucciones
- [ ] Mencionar: Loop con CMP, JEQ, SUB, JMP
- [ ] Recalcar: NO hardcoded, ejecutado por el CPU

#### "¿Cómo se implementó?"
- [ ] Mostrar `instruction_memory.v` (ROM hardcoded)
- [ ] Explicar diferencia SIMULATION vs síntesis
- [ ] Mencionar arquitectura Harvard de 8-bit

#### "¿Cómo se visualiza?"
- [ ] LEDs: bits 0-3 de regA directamente
- [ ] Display: módulo `sevenseg` convierte a BCD
- [ ] Reloj: divisor de 25 MHz a ~1.5 Hz

---

## 🏭 DEMO OPENLANE (1 punto)

### Preparación
- [ ] Tener `config.json` listo
- [ ] Conocer parámetros clave del diseño
- [ ] Revisar `GUIA_OPENLANE.md`

### Parámetros a Mostrar
**El ayudante puede pedir cualquiera:**

#### Área del Diseño
- [ ] Ubicación: `runs/<run_name>/reports/final_summary_report.csv`
- [ ] Buscar: `chip_area_mm2` o `die_area_um2`

#### Número de Compuertas
- [ ] Ubicación: `runs/<run_name>/reports/synthesis/1-synthesis.AREA_0.stat.rpt`
- [ ] Buscar: `Number of cells` o similar

#### Archivo GDS
- [ ] Ubicación: `runs/<run_name>/results/final/gds/`
- [ ] Archivo: `<design_name>.gds`
- [ ] Visualizar con: KLayout o similar

#### Densidad de Potencia
- [ ] Ubicación: `runs/<run_name>/reports/routing/`
- [ ] Archivo: Mapa de densidad de potencia (PNG/PDF)

#### Densidad de Compuertas
- [ ] Ubicación: `runs/<run_name>/reports/placement/`
- [ ] Archivo: Mapa de densidad de celdas

### Comandos OpenLane
```bash
# En la VM Zero to ASIC:
cd /path/to/proyecto
docker run -it -v $(pwd):/project efabless/openlane:latest
flow.tcl -design /project
```

---

## 🎯 PUNTOS DE LA RÚBRICA

### Entrega Final (5 puntos totales)

#### 1. OpenLane (1 punto)
- [x] Código preparado con `config.json`
- [ ] Capaz de mostrar parámetros al ayudante:
  - [ ] Área
  - [ ] Compuertas
  - [ ] GDS
  - [ ] Densidad potencia
  - [ ] Densidad compuertas

#### 2. FPGA (4 puntos)
- [x] Código sintetiza con APIO
- [x] Programa cuenta 15→0
- [x] Implementado via CPU (no hardcoded)
- [ ] Display muestra decimal
- [ ] LEDs muestran binario
- [ ] Demo funcional al ayudante

---

## 📚 DOCUMENTOS DE REFERENCIA RÁPIDA

### Durante la Demo
Tener abiertos:
1. `VALIDACION_PROGRAMA.md` - Respuestas técnicas
2. `GUIA_OPENLANE.md` - Parámetros OpenLane
3. `REPORTE_VALIDACION_FINAL.md` - Overview completo

### Comandos de Emergencia
```bash
# Si algo falla, recompilar:
source apio-env/bin/activate
apio clean
apio build
apio upload

# Ver helper:
./helper_nuevo.sh
```

---

## ⚠️ PROBLEMAS COMUNES Y SOLUCIONES

### FPGA no detectada
**Síntomas:** `apio upload` da error "device not found"
**Solución:**
1. Verificar cable USB conectado
2. `ls /dev/cu.*` para ver dispositivos
3. Reinstalar drivers FTDI si necesario

### Display no muestra nada
**Posibles causas:**
1. Segmentos invertidos (lógica negativa)
2. Pin mapping incorrecto en `hardware.pcf`
**Verificar:** Consultar datasheet Go Board

### Contador muy rápido/lento
**Solución:** Cambiar bit del divisor en `main.v`
```verilog
// Actual: div_clk[24] ≈ 1.5 Hz
// Más lento: div_clk[23] ≈ 3 Hz
// Muy lento: div_clk[25] ≈ 0.75 Hz
```

### OpenLane falla
**Solución:**
1. Verificar todos los módulos tienen `endmodule`
2. No usar `$display` en código para síntesis
3. Verificar `config.json` sintácticamente correcto

---

## 🎉 DESPUÉS DE LA DEMO

### Si todo salió bien
- [ ] Commit final con tag "entrega-final"
- [ ] Push a GitHub
- [ ] Backup de todos los archivos

### Si hubo problemas
- [ ] Documentar qué falló
- [ ] Revisar logs de error
- [ ] Consultar con ayudante/profesor

---

## 📊 AUTOEVALUACIÓN

**Antes de ir al lab, responde:**

1. ¿Puedo explicar cómo funciona el programa contador?  
   - [ ] Sí, con confianza
   - [ ] Más o menos
   - [ ] Necesito repasar

2. ¿Sé dónde están los parámetros de OpenLane?  
   - [ ] Sí
   - [ ] Necesito ver la guía

3. ¿Puedo flashear la FPGA sin ayuda?  
   - [ ] Sí
   - [ ] Necesito recordar comandos

4. ¿Entiendo qué hace cada módulo del CPU?  
   - [ ] Sí
   - [ ] Parcialmente
   - [ ] Necesito repasar

**Si alguna respuesta es "No" o "Necesito repasar", revisar documentación correspondiente.**

---

## 🔑 PUNTOS CLAVE PARA RECORDAR

1. **El contador NO está hardcoded** - Es un programa que ejecuta el CPU
2. **Frecuencia visible** - ~1.5 Hz para que se vea el conteo
3. **LEDs = binario, Display = decimal** - Misma fuente (regA), distinta representación
4. **Ifdef SIMULATION** - Código se comporta distinto en sim vs síntesis
5. **Go Board = 25 MHz** - Necesita divisor de reloj para ser visible

---

**¡ÉXITO EN LA ENTREGA!** 🚀

---

**Última revisión:** 29 oct 2025, 11:35 AM
