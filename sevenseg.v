// sevenseg.v
// Módulo que convierte un valor de 8 bits en dos dígitos decimales
// y los muestra en dos displays de 7 segmentos (decenas y unidades).

module sevenseg(
    input  [7:0] data_in,       // Valor a mostrar (0–99)
    output seg1_a, seg1_b, seg1_c, seg1_d, seg1_e, seg1_f, seg1_g, // Decenas
    output seg2_a, seg2_b, seg2_c, seg2_d, seg2_e, seg2_f, seg2_g  // Unidades
);

    // Limita el valor a 99
    wire [7:0] value = (data_in > 8'd99) ? 8'd99 : data_in;

    // Calcula decenas y unidades
    wire [3:0] tens   = value / 10;
    wire [3:0] ones   = value % 10;

    // Función que traduce un dígito (0–9) a segmentos (a–g)
    function [6:0] to_segments;
        input [3:0] num;
        begin
            case (num)
                4'd0: to_segments = 7'b0111111;
                4'd1: to_segments = 7'b0000110;
                4'd2: to_segments = 7'b1011011;
                4'd3: to_segments = 7'b1001111;
                4'd4: to_segments = 7'b1100110;
                4'd5: to_segments = 7'b1101101;
                4'd6: to_segments = 7'b1111101;
                4'd7: to_segments = 7'b0000111;
                4'd8: to_segments = 7'b1111111;
                4'd9: to_segments = 7'b1101111;
                default: to_segments = 7'b0000000;
            endcase
        end
    endfunction

    // Obtiene la codificación para decenas y unidades
    wire [6:0] seg_tens  = to_segments(tens);
    wire [6:0] seg_units = to_segments(ones);

    // Asigna segmentos (activos en bajo)
    assign {seg1_g, seg1_f, seg1_e, seg1_d, seg1_c, seg1_b, seg1_a} = ~seg_tens;
    assign {seg2_g, seg2_f, seg2_e, seg2_d, seg2_c, seg2_b, seg2_a} = ~seg_units;

endmodule
