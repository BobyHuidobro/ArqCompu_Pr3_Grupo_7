// instruction_memory.v
// Memoria de instrucciones compatible con simulación y síntesis
// Usa ifdef SIMULATION para separar código de debug del código sintetizable

module instruction_memory(address, out);
    input [7:0] address;
    output reg [14:0] out;  

    reg [14:0] mem [0:255];

`ifdef SIMULATION
    // ===== MODO SIMULACIÓN: Carga desde archivo =====
    integer i;
    initial begin
        $display("=== Cargando programa desde im.dat ===");
        $readmemb("im.dat", mem);  // Ruta relativa - funciona en Mac y Windows
        $display("=== Memoria cargada. Primeras entradas: ===");
        for (i = 0; i < 16; i = i + 1) begin
            $display("mem[%0d] = %b", i, mem[i]);
        end
    end
`else
    // ===== MODO SÍNTESIS: ROM hardcoded =====
    // Programa: cuenta de 15 a 0
    initial begin
        // Inst 0: MOV A, 15 (cargar 15 en A)
        mem[0] = 15'b000001000001111;
        
        // Inst 1 (Loop): MOV B, 0 (cargar 0 en B para comparar)
        mem[1] = 15'b000001100000000;
        
        // Inst 2: CMP A, B (comparar A con B -> actualizar flags)
        mem[2] = 15'b100110100000000;
        
        // Inst 3: JEQ End (si A == 0 saltar a End, addr 6)
        mem[3] = 15'b101010000000110;
        
        // Inst 4: SUB A, 1 (A = A - 1)
        mem[4] = 15'b000101000000001;
        
        // Inst 5: JMP Loop (saltar a Loop, addr 1)
        mem[5] = 15'b101001100000001;
        
        // Inst 6 (End): MOV A, 0 (opcional: dejar A en 0)
        mem[6] = 15'b000001000000000;
        
        // Resto: NOPs
        mem[7] = 15'b000000000000000;
        mem[8] = 15'b000000000000000;
        mem[9] = 15'b000000000000000;
        
        // Inicializar el resto de la memoria a NOPs
        // (Verilog sintetiza esto eficientemente)
    end
`endif

    always @(*) begin
        out = mem[address];
    end
endmodule
