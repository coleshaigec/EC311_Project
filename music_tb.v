`timescale 1ns / 1ps

module music_tb;

    reg clk_100mHz = 0;
    always #5 clk_100mHz = ~clk_100mHz;

    reg [2:0] mode_tb;
    reg beep_trigger_tb;
    wire speaker_tb;

    music uut (
        .clk_100mHz(clk_100mHz),
        .mode(mode_tb),
        .beep_trigger(beep_trigger_tb),
        .speaker(speaker_tb)
    );

    initial begin
        $dumpfile("music.vcd");
        $dumpvars(0,music_tb);
        mode_tb = 3'b000;
        beep_trigger_tb = 0;

        // Test scenario 1: Ascending scale
        mode_tb = 3'b001;
        #1000;  // Run simulation for a longer duration

        // Test scenario 2: Descending scale
        mode_tb = 3'b010;
        #1000;  // Run simulation for a longer duration

        // Test scenario 3: Ascending-descending scale
        mode_tb = 3'b011;
        #1000;  // Run simulation for a longer duration

        // Test scenario 4: Beep state (assumes beep_trigger_tb is asserted)
        mode_tb = 3'b100;
        beep_trigger_tb = 1;
        #1000;  // Run simulation for a longer duration
        beep_trigger_tb = 0;

        // Add more test scenarios as needed

        // End simulation
        $finish;
    end

endmodule