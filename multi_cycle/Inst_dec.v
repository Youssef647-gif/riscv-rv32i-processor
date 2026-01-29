module Inst_dec  ( 
    //input  [2:0] funct3,      // Champ funct3 de l’instruction
	 input   [6:0]     op,    
    output reg [1:0] ImmSrc // Signal de commande pour l’ALU
);
 // Définition des opcodes RISC-V
    localparam OP_load = 7'b0000011; // LW, LH, LB
    localparam OP_S_type = 7'b0100011; // SW, SH, SB

    // Logique combinatoire pour déterminer ImmSrc
    always @(*) begin
        case (op)
            OP_load: ImmSrc = 2'b00; // I-Type (Load et ALU Imm)
            OP_S_type:                    ImmSrc = 2'b01; // S-Type (Store)
            default:                      ImmSrc = 2'b00; // Valeur par défaut (ou X)
        endcase
    end

endmodule