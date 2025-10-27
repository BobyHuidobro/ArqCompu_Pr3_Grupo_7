module top (
    input CLK,
    input [3:0] BUTTONS,
    output [3:0] LEDS
);
    wire [7:0] alu_out_bus;
    wire [7:0] regA_out_bus;
    wire [7:0] regB_out_bus;

    computer cpu_inst (
        .clk(CLK)
        .alu_out_bus(alu_out_bus)
        .regA_out_bus(regA_out_bus)
        .regB_out_bus(regB_out_bus)
    );

    assign LEDS = regA_out_bus[3:0]
endmodule
