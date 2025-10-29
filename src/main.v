// top module - Módulo principal para FPGA Go Board
// Cumple con los requisitos del Proyecto 3:
// - Cuenta regresiva de 15 a 0 usando el CPU
// - Muestra resultado en binario en 4 LEDs
// - Muestra resultado en decimal en display de 7 segmentos

module top (
    input i_Clk,           // Pin de reloj de la Go Board
    
    // 4 LEDs para mostrar valor binario
    output o_LED_1,
    output o_LED_2,
    output o_LED_3,
    output o_LED_4,
    
    // Display de 7 segmentos - Segmento 1 (Decenas)
    output o_Segment1_A,
    output o_Segment1_B,
    output o_Segment1_C,
    output o_Segment1_D,
    output o_Segment1_E,
    output o_Segment1_F,
    output o_Segment1_G,
    
    // Display de 7 segmentos - Segmento 2 (Unidades)
    output o_Segment2_A,
    output o_Segment2_B,
    output o_Segment2_C,
    output o_Segment2_D,
    output o_Segment2_E,
    output o_Segment2_F,
    output o_Segment2_G
);

    // ===== Divisor de reloj para hacer visible el conteo =====
    // Go Board tiene un reloj de 25 MHz
    // Usamos un divisor para obtener ~1 Hz (actualización cada segundo)
    reg [24:0] div_clk = 0;
    always @(posedge i_Clk)
        div_clk <= div_clk + 1;

    // Seleccionar bit apropiado para ~1 Hz
    // div_clk[24] = 25MHz / 2^24 ≈ 1.49 Hz
    wire slow_clock = div_clk[24];

    // ===== Señales de interconexión del CPU =====
    wire [7:0] alu_result;
    wire [7:0] regA_value;
    wire [7:0] regB_value;
    wire [7:0] pc_value;

    // ===== Instancia del procesador (computer.v) =====
    computer cpu_inst (
        .clk(slow_clock),
        .alu_out_bus(alu_result),
        .regA_out_bus(regA_value),
        .regB_out_bus(regB_value),
        .pc_out_bus(pc_value)
    );

    // ===== LEDs: muestran los 4 bits bajos de regA en binario =====
    assign o_LED_1 = regA_value[0];
    assign o_LED_2 = regA_value[1];
    assign o_LED_3 = regA_value[2];
    assign o_LED_4 = regA_value[3];

    // ===== Display de 7 segmentos: muestra regA en decimal (0-99) =====
    sevenseg display_inst (
        .data_in(regA_value),
        .seg1_a(o_Segment1_A), .seg1_b(o_Segment1_B), .seg1_c(o_Segment1_C), 
        .seg1_d(o_Segment1_D), .seg1_e(o_Segment1_E), .seg1_f(o_Segment1_F), 
        .seg1_g(o_Segment1_G),
        .seg2_a(o_Segment2_A), .seg2_b(o_Segment2_B), .seg2_c(o_Segment2_C), 
        .seg2_d(o_Segment2_D), .seg2_e(o_Segment2_E), .seg2_f(o_Segment2_F), 
        .seg2_g(o_Segment2_G)
    );

endmodule
