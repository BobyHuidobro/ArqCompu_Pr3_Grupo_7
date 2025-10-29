module muxA(
    input [7:0] regA,
    input [7:0] regB,
    input sel,
    output [7:0] out
);
    assign out = (sel) ? regB : regA;
endmodule
