module program_counter (
    input wire clk,
    input wire reset,
	 input wire PCWrite,
    input wire [31:0] pc_next,
    output reg [31:0] pc_current
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_current <= 0;
        else if (PCWrite)
            pc_current <= pc_next;
    end
endmodule