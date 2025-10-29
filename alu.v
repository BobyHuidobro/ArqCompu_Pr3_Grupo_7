module alu(
    input [7:0] a,
    input [7:0] b,
    input [3:0] s,
    output reg [7:0] out
);
    always @(*) begin
        case (s)
            4'b0000: out = a + b;        // ADD
            4'b0001: out = a - b;        // SUB
            4'b0010: out = b;            // MOV literal/B
            4'b1001: out = b;            // MOV (usado por MOV A, literal)
            4'b1111: out = (a == b) ? 8'd1 : 8'd0; // CMP (marca resultado 1/0)
            default: out = 8'd0;
        endcase
    end
endmodule
