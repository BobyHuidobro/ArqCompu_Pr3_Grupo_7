`timescale 1ns / 1ps

// Testbench para validar el programa contador 15→0
// Simula el comportamiento completo del CPU

module testbench_contador;

    // Señales del testbench
    reg clk;
    wire [7:0] regA_value;
    wire [7:0] regB_value;
    wire [7:0] alu_result;
    wire [7:0] pc_value;

    // Instancia del CPU
    computer cpu_inst (
        .clk(clk),
        .alu_out_bus(alu_result),
        .regA_out_bus(regA_value),
        .regB_out_bus(regB_value),
        .pc_out_bus(pc_value)
    );

    // Generador de reloj: 10ns de período (100 MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor de valores
    initial begin
        $display("===========================================");
        $display("   TESTBENCH: Contador 15 → 0");
        $display("===========================================");
        $display("");
        $display("Ciclo | PC | RegA | RegB | ALU  | Esperado");
        $display("------|----| -----|------|------|----------");
    end

    // Valores esperados para el registro A en cada ciclo relevante
    reg [7:0] expected_values [0:15];
    integer cycle_count;
    integer i;

    initial begin
        // Inicializar valores esperados
        expected_values[0] = 8'd15;  // Después del MOV A, 15
        expected_values[1] = 8'd15;  // Después del MOV B, 0
        expected_values[2] = 8'd15;  // Después del CMP
        expected_values[3] = 8'd15;  // Después del JEQ (no salta)
        expected_values[4] = 8'd14;  // Después del SUB A, 1
        
        cycle_count = 0;
    end

    // Monitor cada ciclo de reloj
    always @(posedge clk) begin
        #1; // Pequeño delay para capturar valores estables
        
        $display("%5d | %2d | %4d | %4d | %4d | -", 
                 cycle_count, pc_value, regA_value, regB_value, alu_result);
        
        cycle_count = cycle_count + 1;
    end

    // Verificación específica de valores de A
    reg [7:0] previous_A;
    integer decrement_count;
    
    initial begin
        previous_A = 8'd0;
        decrement_count = 0;
        
        // Esperar un poco para que el CPU inicialice
        #20;
        
        // Monitorear decrementos
        forever begin
            @(posedge clk);
            #1;
            
            // Detectar cuando A decrementa
            if (regA_value < previous_A && previous_A != 0) begin
                decrement_count = decrement_count + 1;
                $display(">>> DECREMENTO DETECTADO: %d → %d (decremento #%d)", 
                         previous_A, regA_value, decrement_count);
            end
            
            // Detectar cuando A llega a 0
            if (regA_value == 0 && previous_A == 1) begin
                $display("");
                $display("===========================================");
                $display("   ✓ CONTADOR LLEGÓ A 0 EXITOSAMENTE");
                $display("   Total de decrementos: %d", decrement_count);
                $display("===========================================");
            end
            
            previous_A = regA_value;
        end
    end

    // Test automático de la secuencia esperada
    initial begin
        integer test_passed;
        test_passed = 1;
        
        // Esperar inicialización
        #15;
        
        // Verificar que A empieza en 15 (después del primer MOV)
        @(posedge clk);
        @(posedge clk);
        #1;
        if (regA_value !== 8'd15) begin
            $display("ERROR: A debería ser 15, pero es %d", regA_value);
            test_passed = 0;
        end else begin
            $display("✓ A inicializado correctamente a 15");
        end
        
        // Esperar varios ciclos y verificar que A va disminuyendo
        repeat(100) @(posedge clk);
        
        if (regA_value < 8'd15) begin
            $display("✓ A está decrementando (valor actual: %d)", regA_value);
        end else begin
            $display("ERROR: A no está decrementando");
            test_passed = 0;
        end
        
        // Esperar a que llegue a 0 (máximo 200 ciclos más)
        repeat(200) @(posedge clk);
        
        if (regA_value == 8'd0) begin
            $display("✓ A llegó a 0 correctamente");
        end else begin
            $display("ERROR: A no llegó a 0 (valor: %d)", regA_value);
            test_passed = 0;
        end
        
        // Verificar que se mantiene en 0
        repeat(20) @(posedge clk);
        if (regA_value == 8'd0) begin
            $display("✓ A se mantiene en 0 después de terminar");
        end else begin
            $display("ERROR: A cambió después de llegar a 0");
            test_passed = 0;
        end
        
        // Resultado final
        #100;
        $display("");
        $display("===========================================");
        if (test_passed) begin
            $display("   ✓✓✓ TODOS LOS TESTS PASARON ✓✓✓");
        end else begin
            $display("   ✗✗✗ ALGUNOS TESTS FALLARON ✗✗✗");
        end
        $display("===========================================");
        
        $finish;
    end

    // Timeout de seguridad (detener después de 500 ciclos)
    initial begin
        #5000;
        $display("");
        $display("TIMEOUT: Simulación detenida después de 500 ciclos");
        $finish;
    end

    // Generar archivo VCD para visualizar en GTKWave
    initial begin
        $dumpfile("testbench_contador.vcd");
        $dumpvars(0, testbench_contador);
        $dumpvars(0, cpu_inst);
    end

endmodule
