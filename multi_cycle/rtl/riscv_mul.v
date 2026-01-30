module riscv_mul(
       input wire clk,
		 input wire reset,
		 output wire [31:0] Result,
		 //output wire carry,
		 output wire [31:0] pc,
		 output wire [31:0] instr,
		 //output wire resultsrc,
		 //output wire memwrite,
		 //output wire [2:0] alucontrol,
		 //output wire alusrc,
		 output wire regwrite,
		 //output wire [1:0] ALUop,
		 //output wire [31:0] Rd1,Rd2,
		 output wire [31:0] resWB,
		 output wire [31:0] valeur,
		 output wire [31:0] source2
);
wire PCWrite;
wire [31:0]pc_current;
wire [31:0]result;
wire AdrSrc;
wire [31:0]Adr;
wire MemWrite;
wire [31:0]writedata;
wire [31:0]Readdata;
wire IRWrite;
wire [31:0]OLdpc;
wire [31:0]Instr;
wire [31:0]Data;
wire [31:0]rd1;
wire [31:0]rd2;
wire [31:0]reg13;
wire [31:0]ImmExt;
wire [1:0]ImmSrc;
wire [31:0]a1;
wire [31:0]Dw;
wire [31:0]SrcA;
wire [31:0]SrcB;
wire [1:0] ALUSrcA;
wire [1:0] ALUSrcB;
wire [2:0] ALUControl;
wire [31:0]ALUResult;
wire carry;
wire zero;
wire RegWrite;
wire [31:0]AluOut;
wire [1:0] ResultSrc;
//PROGRAM COUNTER 
program_counter PCount(
        .clk(clk),
        .reset(reset),
		  .PCWrite(PCWrite),
        .pc_next(result),
        .pc_current(pc_current)
);
// MUX1_APRES pc
Multiplexer2 MUX1 (
	  .A(pc_current),
	  .B(result),
	  .sel(AdrSrc),
	  .out(Adr)
);
//inst_data_memory
inst_data_memory DM (
		.clk(clk),
		.mem_write(MemWrite),
		.addr(Adr),
		.write_data(writedata),
		.read_data(Readdata)
);
// IF_ID
If_Id FD(
   .clk(clk),
	.IRWrite(IRWrite),
	.pc_current(pc_current),
	.Rd(Readdata),
	.OLdpc(OLdpc),
	.Instr(Instr)
	);
//flip_flop_D_APRES INSR_DATA_MEMORY
flip_flop_D FFD1(
   .clk(clk),
	.Int(Readdata),
	.Out(Data)
);
// REGISTER FILE 
Reg_file RF (
	  .a1(Instr[19:15]),
	  .a2(Instr[24:20]),
	  .a3(Instr[11:7]),
	  .we3(RegWrite),
	  .clk(clk),
	  .wd3(result),
	  .rd1(rd1),
	  .rd2(rd2),
	  .register13(reg13)
);
//Extended
Extended Extend (
	  .instr(Instr),
	  .ImmSrc(ImmSrc),
	  .ImmExt(ImmExt)
);
Reg_flip_flop RFF(
	   .clk(clk),
		.rd1(rd1),
		.rd2(rd2),
		.a1(a1),
		.b1(writedata)
);
// MUX4_1
Multiplexer4 Mux41(
		.A(pc_current),
		.B(OLdpc),
		.C(a1),
		.D(Dw),
		.out(SrcA),
		.sel(ALUSrcA)
);
// MUX4_2
Multiplexer4 Mux42(
		.A(writedata),
		.B(ImmExt),
		.C(32'd4),
		.D(Dw),
		.out(SrcB),
		.sel(ALUSrcB)
);
//Alu
alu ALU (
		.rdA(SrcA),
		.rdB(SrcB),
		.ALUControl(ALUControl),
		.ALUresult(ALUResult),
		.Carry(carry),
		.zero(zero)
);
//flip_flop_D_APRES ALU
flip_flop_D FFD2(
   .clk(clk),
	.Int(ALUResult),
	.Out(AluOut)
);
// MUX4_3
Multiplexer4 Mux43(
		.A(AluOut),
		.B(Data),
		.C(ALUResult),
		.D(Dw),
		.out(result),
		.sel(ResultSrc)
);
// COMTROL UNIT
Controller Cont(
        .clk(clk),
        .reset(reset),
		  .op(Instr[6:0]),
		  .funct7b5(Instr[30]),
		  .funct3(Instr[14:12]),
		  .zero(zero),
		  .PCWrite(PCWrite),
		  .IRWrite(IRWrite),
		  .RegWrite(RegWrite),
		  .MemWrite(MemWrite),
		  .ALUSrcA(ALUSrcA),
		  .ALUSrcB(ALUSrcB),
		  .ResultSrc(ResultSrc),
		  .AdrSrc(AdrSrc),
		  .ALUControl(ALUControl),
		  .ImmSrc(ImmSrc)
);      
assign Result= result;
assign pc= pc_current;
assign instr= Instr;
//assign resultsrc=ResultSrc;
//assign memwrite=MemWrite;
//assign alucontrol=ALUControl;
//assign alusrc=ALUSrc;
assign regwrite=RegWrite;
//assign ALUop=aluop;
//assign Rd1=rd1;
//assign Rd2=rd2;
assign resWB=reg13;
assign valeur=Readdata;
assign source2=IRWrite;
//	assign carry=carry;
endmodule 
		  