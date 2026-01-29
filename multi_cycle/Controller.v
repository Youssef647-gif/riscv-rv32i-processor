module Controller(
    input  wire        clk,
    input  wire        reset,
    input  wire [6:0]  op,    
    input        funct7b5,    // Bit 5 du champ funct7
    input  [2:0] funct3,       // Type d’opération générale (venant de maindec)
	 input zero,
	 output wire       PCWrite,
    output wire       IRWrite,
    output wire       RegWrite,
    output wire       MemWrite,
    output wire [1:0] ALUSrcA,
    output wire [1:0] ALUSrcB,
    output wire [1:0] ResultSrc,
    output wire       AdrSrc,
	 output wire [2:0] ALUControl, // Signal de commande pour l’ALU
	 output wire [1:0] ImmSrc // Signal de commande pour l’ALU
);
wire [1:0] ALUOp;
wire branch;
wire PCUpdate;
fsm_multicycle FSM(
.clk(clk),
.reset(reset),
.op(op),
.Branch(branch),
.IRWrite(IRWrite),
.RegWrite(RegWrite),
.MemWrite(MemWrite),
.ALUSrcA(ALUSrcA),
.ALUSrcB(ALUSrcB),
.ALUOp(ALUOp),
.ResultSrc(ResultSrc),
.AdrSrc(AdrSrc),
.PCUpdate(PCUpdate)
);
aludec_simple ALUdec(
.opb5(op[5]),
.funct7b5(funct7b5),
.ALUOp(ALUOp),
.ALUControl(ALUControl)
);
Inst_dec INST_DEC(
.op(op),
.ImmSrc(ImmSrc)
);
assign PCWrite = ((zero && branch) || PCUpdate);
endmodule