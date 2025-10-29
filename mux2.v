module mux2(e0, e1, c, out);
   input [7:0] e0, e1;
   input       c;
   output reg [7:0] out;

   always @(*) begin
     case(c)
       1'b0: out = e0;
       1'b1: out = e1;
       default: out = 8'b0;
     endcase
   end
endmodule