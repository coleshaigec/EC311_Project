`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick 
// 
// Create Date: 10/23/2023 06:06:08 PM
// Design Name: 
// Module Name: D_Flip_Flop
// Project Name: EC311 Logic Design Final Project
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: D-Flip-Flop implemented in behavioral verilog
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: USED CODE FROM https://www.fpga4student.com/2017/02/verilog-code-for-d-flip-flop.html

// 
//////////////////////////////////////////////////////////////////////////////////


//USED CODE FROM https://www.fpga4student.com/2017/02/verilog-code-for-d-flip-flop.html

module D_Flip_Flop(
    input D,
    input clock,
    output reg Q
    );
    
    always @(posedge clock) begin
        Q <= D;
    end
    
endmodule