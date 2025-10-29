module muxB(
    input [7:0] regB,
    input [7:0] literal,
    input [7:0] mem_data,
    input [1:0] sel,
    output [7:0] out
);
    assign out = (sel == 2'b00) ? regB :
                 (sel == 2'b01) ? literal :
                 (sel == 2'b10) ? mem_data :
                 8'b0;
endmodule
