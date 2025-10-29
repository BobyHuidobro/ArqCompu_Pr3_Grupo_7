// test.v
// Testbench para verificar el funcionamiento del core completo (top.v)
// Simula el conteo descendente de 15 a 0 usando el programa cargado en im.dat.

`timescale 1ns/1ps

module test();

    reg clk_tb;
    reg sw1_tb, sw2_tb, sw3_tb, sw4_tb;
    wire led1_tb, led2_tb, led3_tb, led4_tb;
    wire a1, b1, c1, d1, e1, f1, g1;
    wire a2, b2, c2, d2, e2, f2, g2;

    // Instancia del módulo superior (el computador completo)
    top uut (
        .clk_in(clk_tb),
        .sw1(sw1_tb),
        .sw2(sw2_tb),
        .sw3(sw3_tb),
        .sw4(sw4_tb),
        .led1(led1_tb),
        .led2(led2_tb),
        .led3(led3_tb),
        .led4(led4_tb),
        .a1(a1), .b1(b1), .c1(c1), .d1(d1), .e1(e1), .f1(f1), .g1(g1),
        .a2(a2), .b2(b2), .c2(c2), .d2(d2), .e2(e2), .f2(f2), .g2(g2)
    );

    // Generador de reloj (periodo 10 ns → 100 MHz)
    always #5 clk_tb = ~clk_tb;

    initial begin
        $display("=== Iniciando simulación del contador descendente ===");
        $dumpfile("test.vcd");
        // Guarda toda la jerarquía completa del computador
        $dumpvars(0, uut);
        $dumpvars(0, uut.u_cpu);

        // 🔹 Señales internas del computador (nombre corregido: u_cpu)
        $dumpvars(1, uut.u_cpu.pc_out_bus);
        $dumpvars(1, uut.u_cpu.alu_out_bus);
        $dumpvars(1, uut.u_cpu.regA_out_bus);
        $dumpvars(1, uut.u_cpu.regB_out_bus);

        // Inicialización
        clk_tb = 0;
        sw1_tb = 0;
        sw2_tb = 0;
        sw3_tb = 0;
        sw4_tb = 0;

        // Corre suficiente tiempo para observar el comportamiento
        #2000000;

        $display("=== Fin de simulación ===");
        $finish;
    end

endmodule


