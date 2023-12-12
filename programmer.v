`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 05:16:36 PM
// Design Name: 
// Module Name: programmer
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


// why put the program decision into here at all? One extra register inside the stopwatch logic should solve all these problems...

module programmer(
    input minute,
    input clk,
    input button,
    output reg [21:0] maxtime
    );
    
    // IMPORTANT NOTE BELOW: ADDS COMPLEXITY TO MACHINE
    // need a reset provision here and something to zero the count when we reach the maximum minute and second counts
    
    // register timecount stores count 
 
    reg [21:0] timecount;
    
    // minute controls whether the button increments the minute (if 1) or the second (if 0) 
    // maxtime incremented each time the button goes high
    
    // here, add code to debounce the button signals -- will build preliminary module without this
    
    
    initial begin
        timecount = 22'b000000000000000000000;
    end
                       
    always @(posedge button) begin
        case(minute)
           1'b0: timecount <= timecount + 1000;
           1'b1: timecount <= timecount + 60000;
          endcase
    end
          
    always @(posedge clk) begin
        maxtime <= timecount;
    end
    
endmodule
