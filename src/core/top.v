// top.v
// Módulo superior: conecta el CPU con LEDs y display de 7 segmentos.
// Se usa un divisor de reloj para ralentizar la ejecución visible del contador.

module top(
    input clk_in,               // Reloj de la FPGA
    input sw1, sw2, sw3, sw4,   // Interruptores (por ahora no usados)

    output led1, led2, led3, led4, // LEDs (muestran el valor en binario)
    output a1, b1, c1, d1, e1, f1, g1, // Display decenas
    output a2, b2, c2, d2, e2, f2, g2  // Display unidades
);

    // ===== Divisor de reloj =====
    reg [23:0] div_clk = 0;
    always @(posedge clk_in)
        div_clk <= div_clk + 1;

    wire slow_clock = div_clk[12]; // o incluso [10] para más rápido

    // ===== Señales de interconexión =====
    wire [7:0] alu_result;
    wire [7:0] regA_value;
    wire [7:0] regB_value;
    wire [7:0] pc_value;

    // ===== Instancia del procesador =====
    computer u_cpu (
        .clk(slow_clock),
        .alu_out_bus(alu_result),
        .regA_out_bus(regA_value),
        .regB_out_bus(regB_value),
        .pc_out_bus(pc_value)
    );

    // ===== LEDs: muestran el valor binario (bits bajos de regA) =====
    assign led1 = regA_value[0];
    assign led2 = regA_value[1];
    assign led3 = regA_value[2];
    assign led4 = regA_value[3];

    // ===== Display 7 segmentos =====
    sevenseg u_display (
        .data_in(regA_value),
        .seg1_a(a1), .seg1_b(b1), .seg1_c(c1), .seg1_d(d1), .seg1_e(e1), .seg1_f(f1), .seg1_g(g1),
        .seg2_a(a2), .seg2_b(b2), .seg2_c(c2), .seg2_d(d2), .seg2_e(e2), .seg2_f(f2), .seg2_g(g2)
    );

endmodule
