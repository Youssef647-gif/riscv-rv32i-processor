module Reg_file (
    input  wire        clk,
    input  wire [4:0]  a1, a2, a3,
    input  wire [31:0] wd3,
    input  wire        we3,
    output wire signed [31:0] rd1, rd2,
    output wire signed [31:0] register13
);
    reg signed [31:0] regs [0:31];

    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'd0;
        
        regs[1]  = 32'd11;
        regs[2]  = 32'd12;
        regs[3]  = 32'd2;
        regs[4]  = 32'd7;
        regs[8]  = 32'd8;
        regs[13] = 32'd0;
        regs[16] = 32'd2;
        regs[25] = 32'd5;
    end

    always @(posedge clk) begin
        if (we3 && a3 != 5'd0)      // x0 est toujours 0
            regs[a3] <= wd3;
    end

    assign rd1       = regs[a1];
    assign rd2       = regs[a2];
    assign register13 = regs[13];
endmodule