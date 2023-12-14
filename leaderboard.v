`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Henry Bega 
// 
// Create Date: 12/07/2023 10:50:48 AM
// Design Name: 
// Module Name: leaderboard
// Project Name: ENG EC 311 Introduction to Digital Logic Design Final Project
// Target Devices: 
// Tool Versions: 
// Description: leaderboard module that orders the high scores of two submodes through a fed in time. If the time meets requirements (if it is better than any of the high scores), it replaces the specific high score.
//Signals are sent as LEDs that show what mode and what rank is being shown on 7 segment display. Signals are sent whenever a rank changed to produce a 1 second sound (done in beep.v module)
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module leaderboard(
    input wire[38:0] time_in, //39 bit input due to 10 nano second incremented time in coming from stopwatch module
    input [1:0] stopwatch_mode,//Determine which mode the time will be handled through
    input  [2:0] display_mode,//Determines which LED's to light up depending on mode and rank (to indicate what is being shown on 7 segment display)
//    output reg [21:0] leaderboard_number,
    output reg signal_sound_1,
    output reg signal_sound_2,
    output reg signal_sound_3,
    output reg [2:0] leaderboard_LED,//LEDs indicating rank
    output reg [1:0] slow_or_fast,//LEDs indicating mode
    output reg [38:0] fast_1,//These proceeding 39 bit regs are outputs send to a Mux that will be used to determine what to show on the 7 segment display alongside stopwatch timer incrementation and alarm clock decrementation
    output reg [38:0] fast_2,
    output reg [38:0] fast_3,
    output reg [38:0] slow_1,
    output reg [38:0] slow_2,
    output reg [38:0] slow_3
);

    
    //To enter always block, a change in input is needed coming from stopwatch module with its time output. That time output is sent to the leaderboard here, and is evaluated through a case statement. The "scores" of both modes are outputs sent to a Mux where they will be chosen to be displayed on 7 segment according to switch inputs

    always @(time_in)
    begin
        case (stopwatch_mode) //Indicates slow or fast mode, whichever mode it is in affects the conditions the time in is evaluated through
            2'b01: begin
                if (time_in>=slow_1) begin //Slow1 is the best score, fast1 is the best score for their respective modes
                    slow_3<=slow_2; //An analogy for slow mode is doing a competitive activity like a Plank. The longest times are the best times. Here, if the time in input is greater than the top slow mode score, it replaces it and rearranges the other scores properly
                    slow_2<=slow_1;
                    slow_1<=time_in;
                    if (signal_sound_1!=1)//Logic to cause a sound to be played. When this signal changes, it corresponds to the sound module (beep.v), allowing for a sound specific to a change in the first high score (for either mode)
                        signal_sound_1=1;
                    else
                        signal_sound_1=0;
                end
                else if (time_in>=slow_2)begin
                    slow_3<=slow_2;
                    slow_2<=time_in;
                    if (signal_sound_2!=1)//Same logic as previous to play a different sound when second high score changes
                        signal_sound_2=1;
                    else
                        signal_sound_2=0;
                end
                else if(time_in>=slow_3)begin
                    slow_3<=time_in;
                    if (signal_sound_3!=1)//Same logic as previous to play a different sound when second high score changes
                        signal_sound_3=1;
                    else
                        signal_sound_3=0;
                end
            end
            2'b10: begin
                if (time_in<=fast_1) begin//Same logic for replacing high scores but for the fast mode if the switches we configure is turned on to the fast mode 
                    fast_3<=fast_2;
                    fast_2<=fast_1;
                    fast_1<=time_in;
                    if (signal_sound_1!=1)
                        signal_sound_1=1;
                    else
                        signal_sound_1=0;
                end
                else if (time_in<=fast_2)begin
                    fast_3<=fast_2;
                    fast_2<=time_in;
                    if (signal_sound_2!=1)
                        signal_sound_2=1;
                    else
                        signal_sound_2=0;
                end
                else if(time_in>=fast_3)begin
                    fast_3<=time_in;
                    if (signal_sound_3!=1)
                        signal_sound_3=1;
                    else
                        signal_sound_3=0;
                end
            end
        endcase
    end 
// delete every occurrence of leaderboard number
// change bitwidths as necessary

    always @* begin
        case(display_mode)
            3'b001: begin
                //assign leaderboard_number=fast_1;
                slow_or_fast=2'b11; //this signal is for LEDS, meant to show on the FPGA which mode we are showing on the 7 segment display
                leaderboard_LED=3'b001;//this signal is for LEDS, meant to show which rank (which score) we are showing on the 7 segment display in our slow or fast mode
            end
            3'b010: begin
//             //   assign leaderboard_number=fast_2;
                slow_or_fast=2'b11;
                leaderboard_LED=3'b011;
            end
            3'b011: begin
//             //   assign leaderboard_number=fast_3;
                slow_or_fast=2'b11;
                leaderboard_LED=3'b111;
            end
            3'b100: begin
//            //    assign leaderboard_number=slow_1;
                slow_or_fast=2'b01;
                leaderboard_LED=3'b001;
            end
            3'b101: begin
//               // assign leaderboard_number=slow_2;
                slow_or_fast=2'b01;
                leaderboard_LED=3'b011;
            end
            3'b110: begin
//              //  assign leaderboard_number=slow_3;
                slow_or_fast=2'b01;
                leaderboard_LED=3'b111;
            end
            default: begin
//             //   assign leaderboard_number=0;
                slow_or_fast=2'b00;
                leaderboard_LED=3'b000;
            end
        endcase
    end
endmodule
