//==================== Multiplexer 4 ====================

module Multiplexer2(
    input  [31:0] A, 
    input  [31:0] B,
    input   sel, 
    output reg[31:0] out
);
   always @(*) begin
    case(sel)
        2'b0: out = A;
        2'b1: out = B;
    endcase
end

endmodule