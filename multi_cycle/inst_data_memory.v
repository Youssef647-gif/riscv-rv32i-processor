module inst_data_memory(
    input  wire        clk,
    input  wire        mem_write,
    input  wire [31:0] addr,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    reg [31:0] memory [0:31];

    integer k;

    initial begin
        for (k = 0; k < 32; k = k + 1)
            memory[k] = 32'b0;

        // PC=0  → sw x1, 4(x2)     opcode=0100011  funct3=010  imm=4
        // sw rs2, imm(rs1) → [31:25]=0000000  rs2=00001(x1)  rs1=00010(x2)  funct3=010  imm[11:5]=0000000  opcode=0100011
        memory[0] = 32'b0000000_00001_00010_010_00100_0100011;   // sw x1, 4(x2)

        // PC=4  → lw x13, 4(x2)     opcode=0000011  funct3=010  imm=4
        // lw rd, imm(rs1)  → imm[11:0]=000000000100  rs1=00010(x2)  funct3=010  rd=01101(x13)  opcode=0000011
        memory[1] = 32'b000000000100_00010_010_01101_0000011;    // lw x13, 4(x2)

        // (optionnel) instruction suivante pour arrêter proprement ou boucle
        memory[2] = 32'h00000013;  // nop = addi x0,x0,0
    end

    always @(posedge clk) begin
        if (mem_write)
            memory[addr[6:2]] <= write_data; 
    end

    always @(*) begin
        read_data = memory[addr[6:2]];
    end

endmodule