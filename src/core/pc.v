// pc.v
// Contador de programa con soporte de saltos (JMP, JEQ)

module pc(
    input clk,
    input is_jump,             // Señal de salto desde la control_unit
    input [3:0] jump_cond,     // Condición (0001 = JEQ, 1111 = JMP)
    input [7:0] target_addr,   // Dirección literal del salto (del campo literal)
    input [7:0] regA_value,    // Valor del registro A (para comparar en JEQ)
    output reg [7:0] pc
);
    initial pc = 0;

    always @(posedge clk) begin
        if (is_jump) begin
            // Salto incondicional (JMP)
            if (jump_cond == 4'b1111) begin
                pc <= target_addr;
`ifdef SIMULATION
                $display("JMP ejecutado → nueva PC = %0d (addr=%0d)", target_addr, target_addr);
`endif
            end
            // Salto si igual (JEQ): solo si A == 0
            else if (jump_cond == 4'b0001 && regA_value == 8'd0) begin
                pc <= target_addr;
`ifdef SIMULATION
                $display("JEQ ejecutado → nueva PC = %0d (addr=%0d)", target_addr, target_addr);
`endif
            end
            // Si no se cumple la condición, simplemente avanza
            else begin
                pc <= pc + 1;
            end
        end else begin
            pc <= pc + 1;
        end

`ifdef SIMULATION
        // Mostrar cada actualización del PC para depuración
        $display("PC actualizado: %0d (is_jump=%b, cond=%b, regA=%0d, target=%0d)", 
                 pc, is_jump, jump_cond, regA_value, target_addr);
`endif
    end
endmodule
