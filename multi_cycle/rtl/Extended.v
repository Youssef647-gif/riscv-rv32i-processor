module Extended  (
    input  signed [31:0] instr,
    input  signed [1:0] ImmSrc,
    output reg signed [31:0] ImmExt
);
    always @(*) begin
	 case (ImmSrc)
				2'b00: ImmExt = {{20{instr[31]}}, instr[31:20]};//load
				2'b01: ImmExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};//store
				//2'b10: ImmExt = {7'b0000000, instr};//branch
            default: ImmExt = 32'b0;
     endcase 
	 end 
endmodule