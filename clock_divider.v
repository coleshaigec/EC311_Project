`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 04:36:06 PM
// Design Name: 
// Module Name: clock_divider
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



module clock_divider(
    input clk_in,
    output reg clk_out
    );
   
   reg [27:0] count;
   // Board uses a 100 MHz clock --> 100 MHz corresponds to period of 0.01ns
   // Stopwatch requires 1ms clock period
   // Therefore this clock divider counts to 1ms / 0.01ns = 100,000,000 
    initial begin 
        count = 0;
        clk_out = 0;
    end
    
    always @(posedge clk_in)
    begin
        count = count + 1;
        if (count == 100000000) begin
            clk_out <= ~clk_out;
            count <= 0;
        end
    end    
    
endmodule