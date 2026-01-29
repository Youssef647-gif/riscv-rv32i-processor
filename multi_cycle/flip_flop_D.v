module flip_flop_D(
    input wire [31:0] Int,
	 output reg [31:0] Out,
	 input wire clk
);
 always @(posedge clk) begin
            Out <= Int;
    end
endmodule