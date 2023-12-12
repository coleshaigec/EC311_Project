`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 10:50:48 AM
// Design Name: 
// Module Name: leaderboard
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

module leaderboard(
    input wire[38:0] time_in,
    input [1:0] stopwatch_mode,
    input  [2:0] display_mode,
//    output reg [21:0] leaderboard_number,
    output reg signal_sound_1,
    output reg signal_sound_2,
    output reg signal_sound_3,
    output reg [2:0] leaderboard_LED,
    output reg [1:0] slow_or_fast,
    output reg [38:0] fast_1,
    output reg [38:0] fast_2,
    output reg [38:0] fast_3,
    output reg [38:0] slow_1,
    output reg [38:0] slow_2,
    output reg [38:0] slow_3
);

    
    reg [38:0] time_in_wire;
    wire [38:0] time_in_reg;
    always @* begin
        time_in_wire=time_in;
    end

    always @(time_in)
    begin
        case (stopwatch_mode)
            2'b01: begin
                if (time_in>=slow_1) begin
                    slow_3<=slow_2;
                    slow_2<=slow_1;
                    slow_1<=time_in;
                    if (signal_sound_1!=1)
                        signal_sound_1=1;
                    else
                        signal_sound_1=0;
                end
                else if (time_in>=slow_2)begin
                    slow_3<=slow_2;
                    slow_2<=time_in;
                    if (signal_sound_2!=1)
                        signal_sound_2=1;
                    else
                        signal_sound_2=0;
                end
                else if(time_in>=slow_3)begin
                    slow_3<=time_in;
                    if (signal_sound_3!=1)
                        signal_sound_3=1;
                    else
                        signal_sound_3=0;
                end
            end
            2'b10: begin
                if (time_in<=fast_1) begin
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
//                assign leaderboard_number=fast_1;
                slow_or_fast=2'b11;
                leaderboard_LED=3'b001;
            end
            3'b010: begin
//                assign leaderboard_number=fast_2;
                slow_or_fast=2'b11;
                leaderboard_LED=3'b011;
            end
            3'b011: begin
//                assign leaderboard_number=fast_3;
                slow_or_fast=2'b11;
                leaderboard_LED=3'b111;
            end
            3'b100: begin
//                assign leaderboard_number=slow_1;
                slow_or_fast=2'b01;
                leaderboard_LED=3'b001;
            end
            3'b101: begin
//                assign leaderboard_number=slow_2;
                slow_or_fast=2'b01;
                leaderboard_LED=3'b011;
            end
            3'b110: begin
//                assign leaderboard_number=slow_3;
                slow_or_fast=2'b01;
                leaderboard_LED=3'b111;
            end
            default: begin
//                assign leaderboard_number=0;
                slow_or_fast=2'b00;
                leaderboard_LED=3'b000;
            end
        endcase
    end
endmodule