module Reg_flip_flop(
  input wire [31:0] rd1,
  input wire [31:0] rd2,
  output reg [31:0] a1,
  output reg [31:0] b1,
  input wire clk
  );
   always @(posedge clk) begin
            a1 <= rd1;
				b1 <= rd2;
    end
endmodule