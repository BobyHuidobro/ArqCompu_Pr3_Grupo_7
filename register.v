module register(
    input clk,
    input [7:0] data,
    input load,
    output reg [7:0] out
);
    initial out = 8'b0; // evita X al inicio

    always @(posedge clk) begin
        if (load)
            out <= data;
    end
endmodule
