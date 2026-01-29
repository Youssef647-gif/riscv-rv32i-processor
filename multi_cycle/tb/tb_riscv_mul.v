`timescale 1ns / 1ps

module tb_riscv_mul;

    // ───────────────────────────────────────────────
    // Signaux uniquement au niveau du testbench
    // ───────────────────────────────────────────────
    reg         clk;
    reg         reset;

    // ───────────────────────────────────────────────
    // Instanciation du processeur (DUT)
    // ───────────────────────────────────────────────
    riscv_mul dut (
        .clk       (clk),
        .reset     (reset),
        // Les sorties ne sont pas connectées ici → on les observe via dut.XXX
        .Result    (),
        .pc        (),
        .instr     (),
        .regwrite  (),
        .resWB     (),
        .valeur    (),
        .source2   ()
    );

    // ───────────────────────────────────────────────
    // Génération horloge (période 80 ns pour coller à ton ancien waveform)
    // ───────────────────────────────────────────────
    always #100 clk = ~clk;

    // ───────────────────────────────────────────────
    // Séquence de test simple
    // ───────────────────────────────────────────────
    initial begin
        // Valeurs initiales
        clk   = 0;
        reset = 1;

        // On attend un peu puis on enlève le reset
        #10;
        reset = 0;

        // Durée suffisante pour exécuter sw + lw + nop + un peu plus
        #2000;

        // Affichage final pour vérification rapide dans la console
        $display("\n=== FIN SIMULATION ===");
        $display("t = %t", $time);
        $display("PC         = 0x%h", dut.pc_current);
        $display("Instruction= 0x%h", dut.Instr);
        $display("x13 (resWB)= %d (0x%h)", dut.resWB, dut.resWB);
        $display("RegWrite   = %b",     dut.RegWrite);
        $display("Readdata   = 0x%h",   dut.Readdata);

        $finish;   // ou $stop si tu veux garder la waveform ouverte
    end

    // ───────────────────────────────────────────────
    // Monitoring console (très utile pendant le debug)
    // ───────────────────────────────────────────────
    initial begin
        $monitor(
            "t=%6t | PC=%h | Instr=%h | state=%d | RegW=%b | x13=%h | RdData=%h",
            $time,
            dut.pc_current,
            dut.Instr,
            dut.Cont.FSM.state_current,
            dut.RegWrite,
            dut.resWB,
            dut.Readdata
        );
    end

endmodule