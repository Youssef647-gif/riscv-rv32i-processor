module alu (
    input  wire signed [31:0] rdA,
    input  wire signed [31:0] rdB,
    input  wire [2:0]         ALUControl,
    output reg  signed [31:0] ALUresult,
    output reg                Carry,
    output wire               zero
);

    wire [31:0] sum;
    wire [31:0] diff;

    assign sum  = rdA + rdB;
    assign diff = rdA - rdB;

    assign zero = (ALUresult == 32'd0);

    always @(*) begin
        ALUresult = 32'd0;
        Carry     = 1'b0;

        case (ALUControl)
            3'b000: begin   // ADD
                {Carry, ALUresult} = sum;
            end

            3'b001: begin   // SUB
                ALUresult = diff;
                // Carry = borrow (inversé par rapport à l'addition)
                Carry = (rdA < rdB) ? 1'b1 : 1'b0;   // ou laisser à 0 si non utilisé
            end

            default: begin
                ALUresult = 32'd0;
                Carry     = 1'b0;
            end
        endcase
    end

endmodule