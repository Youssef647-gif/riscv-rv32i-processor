// MODULE : aludec
// Génère le signal ALUControl à partir de ALUOp, funct3, funct7b5 et opb5.

module aludec_simple ( 
    //input  [2:0] funct3,      // Champ funct3 de l’instruction
	 input        opb5,    
    input        funct7b5,    // Bit 5 du champ funct7
    input  [1:0] ALUOp,       // Type d’opération générale (venant de maindec)
    output reg [2:0] ALUControl // Signal de commande pour l’ALU
);

  always @(*) begin
        case (ALUOp)
            // Cas pour lw et sw : toujours une addition
            2'b00: ALUControl = 3'b000; // ADD

            // Cas pour les instructions de type R (add/sub)
            2'b10: begin
                if (funct7b5 == 1'b1)
                    ALUControl = 3'b001; // C'est 'sub'
                else
                    ALUControl = 3'b000; // C'est 'add'
            end

            // Cas par défaut pour les valeurs de ALUOp non gérées
            default: ALUControl = 3'bxxx;
        endcase
    end
endmodule