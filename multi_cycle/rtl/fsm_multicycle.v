module fsm_multicycle (
    input  wire        clk,
    input  wire        reset,
    input  wire [6:0]  op,

    output reg        Branch,
    output reg        PCUpdate,
    output reg        IRWrite,
    output reg        RegWrite,
    output reg        MemWrite,
    output reg [1:0]  ALUSrcA,
    output reg [1:0]  ALUSrcB,
    output reg [1:0]  ALUOp,
    output reg [1:0]  ResultSrc,
    output reg        AdrSrc
);

    // États
    localparam [3:0]
        S0_Fetch     = 4'b0000,
        S1_Dec       = 4'b0001,
        S2_MemAd     = 4'b0010,
        S3_MemRead   = 4'b0011,
        S4_MemWb     = 4'b0100,
        S5_MemWrite  = 4'b0101,
        S6_Ex        = 4'b0110,
        S7_AluWb     = 4'b0111,
        S8_ExecI     = 4'b1000,
        S9_Jal       = 4'b1001,
        S10_Beq      = 4'b1010;

    reg [3:0] state_current, state_next;

    // REGISTER STATE
    always @(posedge clk or posedge reset) begin
        if (reset)
            state_current <= S0_Fetch;
        else
            state_current <= state_next;
    end

    // NEXT STATE LOGIC
    always @(*) begin
        case (state_current)

            S0_Fetch: state_next = S1_Dec;

            S1_Dec: case (op)
                7'b0000011: state_next = S2_MemAd;    // load
                7'b0100011: state_next = S2_MemAd;    // store
                7'b0110011: state_next = S6_Ex;       // R-type
                7'b0010011: state_next = S8_ExecI;    // I-type ALU
                7'b1101111: state_next = S9_Jal;      // JAL
                7'b1100011: state_next = S10_Beq;     // BEQ
                default:    state_next = S0_Fetch;
            endcase

            S2_MemAd: case (op)
                7'b0000011: state_next = S3_MemRead;  // load
                7'b0100011: state_next = S5_MemWrite; // store
                default:    state_next = S1_Dec;
            endcase

            S3_MemRead:   state_next = S4_MemWb;
            S4_MemWb:     state_next = S0_Fetch;
            S5_MemWrite:  state_next = S0_Fetch;
            S6_Ex:        state_next = S7_AluWb;
            S7_AluWb:     state_next = S0_Fetch;
            S8_ExecI:     state_next = S7_AluWb;
            S9_Jal:       state_next = S7_AluWb;
            S10_Beq:      state_next = S7_AluWb;

            default:      state_next = S0_Fetch;
        endcase
    end

    // OUTPUT LOGIC
    always @(*) begin

        // ==== ✨ Valeurs par défaut (IMPORTANT !) ====
        Branch     = 1'b0;
        PCUpdate   = 1'b0;
        IRWrite    = 1'b0;
        RegWrite   = 1'b0;
        MemWrite   = 1'b0;
        AdrSrc     = 1'b0;
        ALUSrcA    = 2'b00;
        ALUSrcB    = 2'b00;
        ALUOp      = 2'b00;
        ResultSrc  = 2'b00;

        case (state_current)

            // ================= FETCH ==================
            S0_Fetch: begin
                AdrSrc   = 1'b0;
                IRWrite  = 1'b1;
                ALUSrcA  = 2'b00;
                ALUSrcB  = 2'b10;   // +4
                ALUOp    = 2'b00;
                ResultSrc= 2'b10;   // PC+4
                PCUpdate = 1'b1;
            end
	    // ================ deco ================
	    S1_Dec: begin
                ALUSrcA  = 2'b01;
                ALUSrcB  = 2'b01;   
                ALUOp    = 2'b00;
            end
            // ================ MEM ADDRESS =============
            S2_MemAd: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01; // offset
                ALUOp   = 2'b00;
            end

            // ================ MEM READ ================
            S3_MemRead: begin
                AdrSrc    = 1'b1;
                ResultSrc = 2'b00;
            end

            // ================ MEM WB ==================
            S4_MemWb: begin
                ResultSrc = 2'b01;
                RegWrite  = 1'b1;
            end

            // =============== STORE ====================
            S5_MemWrite: begin
                AdrSrc   = 1'b1;
                MemWrite = 1'b1;
            end

            // =============== R-TYPE ====================
            S6_Ex: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp   = 2'b10;
            end

            S7_AluWb: begin
                ResultSrc = 2'b00;
                RegWrite  = 1'b1;
            end

            // =============== I-TYPE ALU ===============
            S8_ExecI: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ALUOp   = 2'b10;
            end

            // =============== JAL ======================
            S9_Jal: begin
                ALUSrcA  = 2'b01;
                ALUSrcB  = 2'b10;
                ALUOp    = 2'b00;
                ResultSrc= 2'b00;
                PCUpdate = 1'b1;
            end

            // =============== BEQ ======================
            S10_Beq: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b00;
                ALUOp   = 2'b01;
                Branch  = 1'b1;
            end

        endcase
    end

endmodule
