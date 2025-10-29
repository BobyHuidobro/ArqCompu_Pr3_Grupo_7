#!/bin/bash

# Script helper para simular y construir el proyecto
# Compatible con Mac y Linux

echo "=========================================="
echo "  CPU 8-bits - Helper Script"
echo "=========================================="
echo ""

# Colores para output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para simular
simulate() {
    echo -e "${YELLOW}Compilando simulación con iverilog...${NC}"
    
    # Compilar con flag SIMULATION
    iverilog -DSIMULATION \
        -o testbench_contador.out \
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
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Compilación exitosa${NC}"
        echo ""
        echo -e "${YELLOW}Ejecutando simulación...${NC}"
        vvp testbench_contador.out
        
        if [ $? -eq 0 ]; then
            echo ""
            echo -e "${GREEN}✓ Simulación completada${NC}"
            echo ""
            echo "Para visualizar las ondas:"
            echo "  gtkwave testbench_contador.vcd"
        fi
    else
        echo -e "${RED}✗ Error en compilación${NC}"
        exit 1
    fi
}

# Función para construir con APIO
build_fpga() {
    echo -e "${YELLOW}Construyendo para FPGA con APIO...${NC}"
    apio build
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Build exitoso${NC}"
        echo ""
        echo "Para flashear a la FPGA:"
        echo "  apio upload"
    else
        echo -e "${RED}✗ Error en build${NC}"
        exit 1
    fi
}

# Función para limpiar archivos temporales
clean() {
    echo -e "${YELLOW}Limpiando archivos temporales...${NC}"
    rm -f *.out
    rm -f *.vcd
    rm -rf _build
    apio clean 2>/dev/null
    echo -e "${GREEN}✓ Limpieza completada${NC}"
}

# Menú principal
case "$1" in
    sim|simulate)
        simulate
        ;;
    build)
        build_fpga
        ;;
    upload)
        echo -e "${YELLOW}Flasheando a FPGA...${NC}"
        apio upload
        ;;
    clean)
        clean
        ;;
    *)
        echo "Uso: $0 {simulate|build|upload|clean}"
        echo ""
        echo "Comandos:"
        echo "  simulate  - Compilar y ejecutar testbench con iverilog"
        echo "  build     - Construir para FPGA con APIO"
        echo "  upload    - Flashear a la Go Board"
        echo "  clean     - Limpiar archivos temporales"
        echo ""
        echo "Ejemplos:"
        echo "  ./helper.sh simulate"
        echo "  ./helper.sh build"
        exit 1
        ;;
esac
