`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// Create Date: 12/13/2023 07:13:15 PM
// Design Name: 
// Module Name: Video_seven_seg_demo
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Top level module to demonstrate all 8 working 7-segment displays with decimal points
//              displaying time, including rolling over seconds into minutes at 60 sec
// 
// Dependencies: seven_seg_fsm.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Video_seven_seg_demo(
    input clock,
    input [38:0] time_in,
    output [7:0] cathode,
    output [7:0] anode
    );
    
    reg [38:0]count;
    reg [7:0] decs = 8'b00101000;
    
    seven_seg_fsm disp(clock,count,decs,cathode,anode);

    initial begin
        count = 0;
    end
    
    always @(posedge clock) begin
		   count = count + 1; // Seconds increments once every second
    end    
    
    
endmodule
