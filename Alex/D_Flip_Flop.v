`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 06:06:08 PM
// Design Name: 
// Module Name: D_Flip_Flop
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


//USED CODE FROM https://www.fpga4student.com/2017/02/verilog-code-for-d-flip-flop.html

module D_Flip_Flop(
    input D,
    input clock,
    output reg Q
    //output reg Q_bar
    );
    
    always @(posedge clock) begin
        Q <= D;
    end
    
    /*always @(Q) begin
        Q_bar = ~Q;
    end*/
    
endmodule
