`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 05:19:24 PM
// Design Name: 
// Module Name: time_MUX
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


module time_MUX(
    input [38:0] timewire,
    input [38:0] up_time1,
    input [38:0] up_time2,
    input [38:0] up_time3,
    input [38:0] down_time1,
    input [38:0] down_time2,
    input [38:0] down_time3,
    input [2:0] sel,
    output reg [38:0] disp_time
    );
    
    // will write this in behavioral Verilog
    
    // encoding scheme
    // 000  timewire
    // 001  down2
    // 010  down1
    // 011  down3
    // 100  timewire
    // 101  up2
    // 110  up1
    // 111  up3
    
    always @(*) begin
        case (sel)
         3'b000:
            begin
                disp_time = timewire;
            end
         3'b001:
            begin
                disp_time = down_time2;
            end
         3'b010:
            begin
                disp_time = down_time1;
            end
         3'b011:
            begin
                disp_time = down_time3;
            end
        3'b100:
            begin
                disp_time = timewire;
            end
        3'b101:
            begin
                disp_time = up_time2;
            end
        3'b110:
            begin
               disp_time = up_time1;
            end
        3'b111:
            begin
                disp_time = up_time3;
            end
        endcase
    end
    
    // this module is a simple one: you're building an 8-1 MUX
    // take in a three-bit select signal (display_mode on TLM or whatever it is)
    // use that to MUX between 8 signals: six registers which will be populated by the leaderboard module and one wire running into the MUX from the stopwatch itself
    
endmodule
