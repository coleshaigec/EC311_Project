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
    
    reg [21:0]time_in;
    reg [1:0] stopwatch_mode;
    reg [2:0] display_mode;
    wire [21:0] leaderboard_number;
    wire signal_sound_1;
    wire signal_sound_2;
    wire signal_sound_3;
    
    leaderboard lb(.time_in(time_in),.stopwatch_mode(stopwatch_mode),.display_mode(display_mode),.leaderboard_number(leaderboard_number),.signal_sound_1(signal_sound_1),.signal_sound_2(signal_sound_2),.signal_sound_3(signal_sound_3));
    
    
    initial begin
    #10
    stopwatch_mode=2'b01;
    time_in=143000;
    display_mode=3'b100;
    #10
    display_mode=3'b000;
    time_in=142000;
    #10
    time_in=139000;
    #10
    time_in=150000;
    #10
    $finish;
    end
    
endmodule
