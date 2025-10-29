#!/bin/bash
# Script de utilidad para el Proyecto 3
# Facilita la ejecución de comandos comunes

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=================================${NC}"
echo -e "${BLUE}  PROYECTO 3 - Helper Script${NC}"
echo -e "${BLUE}=================================${NC}"
echo ""

# Activar entorno virtual
source apio-env/bin/activate

case "$1" in
    "build")
        echo -e "${YELLOW}🔨 Sintetizando diseño con APIO...${NC}"
        apio build
        ;;
    
    "upload")
        echo -e "${YELLOW}📤 Flasheando FPGA Go Board...${NC}"
        apio upload
        ;;
    
    "flash")
        echo -e "${YELLOW}🔨 Compilando y flasheando...${NC}"
        apio build && apio upload
        ;;
    
    "clean")
        echo -e "${YELLOW}🧹 Limpiando archivos generados...${NC}"
        apio clean
        rm -f *.json *.asc *.bin test.out *.vcd
        echo -e "${GREEN}✅ Limpieza completa${NC}"
        ;;
    
    "sim")
        echo -e "${YELLOW}🧪 Compilando y ejecutando testbench...${NC}"
        iverilog -g2005-sv -DSIMULATION -o test.out \
            src/core/testbench_contador.v \
            src/core/alu.v src/core/computer.v src/core/control_unit.v \
            src/core/data_memory.v src/core/instruction_memory.v \
            src/core/jump_logic.v src/core/mux2.v src/core/muxA.v \
            src/core/muxB.v src/core/mux_address.v src/core/pc.v \
            src/core/register.v src/core/sevenseg.v src/core/status_register.v
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Compilación exitosa${NC}"
            echo -e "${YELLOW}▶️  Ejecutando simulación...${NC}"
            vvp test.out
        else
            echo -e "${RED}❌ Error en compilación${NC}"
        fi
        ;;
    
    "wave")
        echo -e "${YELLOW}📊 Abriendo GTKWave...${NC}"
        if [ -f testbench_contador.vcd ]; then
            gtkwave testbench_contador.vcd &
        else
            echo -e "${RED}❌ Archivo VCD no encontrado. Ejecuta primero: ./helper.sh sim${NC}"
        fi
        ;;
    
    "status")
        echo -e "${BLUE}📊 Estado del proyecto:${NC}"
        echo ""
        echo -e "${YELLOW}Archivos de síntesis:${NC}"
        ls -lh hardware.bin hardware.json hardware.asc 2>/dev/null || echo "  No generados aún"
        echo ""
        echo -e "${YELLOW}Archivos de simulación:${NC}"
        ls -lh test.out testbench_contador.vcd 2>/dev/null || echo "  No generados aún"
        echo ""
        echo -e "${YELLOW}Archivos fuente:${NC}"
        echo "  - $(ls src/core/*.v | wc -l) archivos Verilog en src/core/"
        echo "  - main.v, hardware.pcf, config.json"
        ;;
    
    "info")
        echo -e "${BLUE}ℹ️  Información del diseño:${NC}"
        echo ""
        echo "📦 Módulo TOP: top"
        echo "🔌 Entradas: i_Clk (25 MHz)"
        echo "💡 Salidas: 4 LEDs + 2 displays 7-seg"
        echo "⚙️  CPU: 8-bit, Harvard, con saltos"
        echo "📝 Programa: Contador 15→0"
        echo "⏱️  Frecuencia CPU: ~1.5 Hz"
        echo ""
        echo -e "${GREEN}Ver VALIDACION_PROGRAMA.md para más detalles${NC}"
        ;;
    
    "demo")
        echo -e "${YELLOW}🎬 Preparando para demo...${NC}"
        echo ""
        echo "1. Conecta la FPGA Go Board al USB"
        echo "2. Ejecuta: ./helper.sh flash"
        echo "3. Observa:"
        echo "   - Display muestra valor decimal (15→0)"
        echo "   - LEDs muestran bits 0-3 en binario"
        echo "   - Cuenta cada ~0.67 segundos"
        echo ""
        echo -e "${GREEN}Ver VALIDACION_PROGRAMA.md para respuestas al ayudante${NC}"
        ;;
    
    *)
        echo -e "${GREEN}Comandos disponibles:${NC}"
        echo ""
        echo "  ${YELLOW}build${NC}   - Sintetizar diseño (apio build)"
        echo "  ${YELLOW}upload${NC}  - Flashear FPGA (apio upload)"
        echo "  ${YELLOW}flash${NC}   - Build + Upload"
        echo "  ${YELLOW}clean${NC}   - Limpiar archivos generados"
        echo "  ${YELLOW}sim${NC}     - Compilar y ejecutar testbench"
        echo "  ${YELLOW}wave${NC}    - Abrir GTKWave (requiere sim primero)"
        echo "  ${YELLOW}status${NC}  - Ver estado de archivos"
        echo "  ${YELLOW}info${NC}    - Información del diseño"
        echo "  ${YELLOW}demo${NC}    - Instrucciones para demo"
        echo ""
        echo -e "${BLUE}Ejemplo: ./helper.sh build${NC}"
        ;;
esac
