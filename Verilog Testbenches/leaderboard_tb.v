`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 11:24:04 AM
// Design Name: 
// Module Name: leaderboard_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module leaderboard_tb(

    );
    
    reg [38:0]time_in;
    reg [1:0] stopwatch_mode;
    reg [2:0] display_mode;
    wire [38:0] fast_1;
    wire [38:0] fast_2;
    wire [38:0] fast_3;
    wire [38:0] slow_1;
    wire [38:0] slow_2;
    wire [38:0] slow_3;
    wire signal_sound_1;
    wire signal_sound_2;
    wire signal_sound_3;
    wire [2:0] leaderboard_LED;
    wire [1:0] slow_or_fast;
    
    leaderboard lb(.time_in(time_in),.stopwatch_mode(stopwatch_mode),.display_mode(display_mode),.fast_1(fast_1),.fast_2(fast_2),.fast_3(fast_3),.slow_1(slow_1),.slow_2(slow_2),.slow_3(slow_3),.signal_sound_1(signal_sound_1),.signal_sound_2(signal_sound_2),.signal_sound_3(signal_sound_3),.leaderboard_LED(leaderboard_LED),.slow_or_fast(slow_or_fast));
    
    
    initial begin
    #10
    stopwatch_mode=2'b01;
    time_in=143000;
    display_mode=3'b100;
    #10
    display_mode=3'b000;
    time_in=142000;
    #10
    display_mode=3'b101;
    time_in=139000;
    #10
    display_mode=3'b110;
    time_in=150000;
    #10
    $finish;
    end
    //Simulation works as expected, signals for sound change when a change in input (time_in) occurs that causes a shift in rank in either mode.
endmodule

