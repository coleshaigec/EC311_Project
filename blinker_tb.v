`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2023 09:46:11 PM
// Design Name: 
// Module Name: blinker_tb
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


module blinker_tb(

    );
    
    reg clk;
    wire led;
    
    blinker blink(clk,led);
    
    always #10 clk = ~clk;
    
    initial begin
        clk = 0;
    end
    
endmodule
