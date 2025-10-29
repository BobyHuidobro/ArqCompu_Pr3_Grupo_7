// control_unit.v
// Unidad de control adaptada a los opcodes reales del im.dat.
// Incluye debug ($display) para ver las señales generadas.

module control_unit(
    input [6:0] opcode,
    output reg [3:0] alu_op,
    output reg muxA_sel,
    output reg [1:0] muxB_sel,
    output reg regA_load,
    output reg regB_load,
    output reg mem_write,
    output reg addr_sel,
    output reg flags_write,
    output reg is_jump,
    output reg [3:0] jump_cond
);
    always @(*) begin
        // ===== Valores por defecto =====
        alu_op      = 4'b0000;
        muxA_sel    = 0;
        muxB_sel    = 2'b00;
        regA_load   = 0;
        regB_load   = 0;
        mem_write   = 0;
        addr_sel    = 0;
        flags_write = 0;
        is_jump     = 0;
        jump_cond   = 4'b0000;

        // ===== Decodificación =====
        case (opcode)
            // MOV A, literal  (opcode 0000010)
            7'b0000010: begin
                alu_op      = 4'b1001;
                muxB_sel    = 2'b01;
                regA_load   = 1;
            end

            // MOV B, literal  (opcode 0000011)
            7'b0000011: begin
                alu_op      = 4'b1001;
                muxB_sel    = 2'b01;
                regB_load   = 1;
            end

            // SUB A, literal
            7'b0001010: begin
                alu_op      = 4'b0001;
                muxB_sel    = 2'b01;
                regA_load   = 1;
            end

            // CMP A, B
            7'b1001101: begin
                alu_op      = 4'b1111;
                muxA_sel    = 0;
                muxB_sel    = 2'b00;
                flags_write = 1;
            end

            // JMP addr
            7'b1010011: begin
                is_jump     = 1;
                jump_cond   = 4'b1111;
            end

            // JEQ addr
            7'b1010100: begin
                is_jump     = 1;
                jump_cond   = 4'b0001;
            end

            // NOP
            7'b0000000: begin
                // nada
            end
        endcase

`ifdef SIMULATION
        // ===== Debug (solo en simulación) =====
        $display("T=%0t OPC=%b ALUop=%b regAld=%b regBld=%b is_jump=%b jump_cond=%b muxB=%b addr_sel=%b",
                 $time, opcode, alu_op, regA_load, regB_load, is_jump, jump_cond, muxB_sel, addr_sel);
`endif
    end
endmodule

