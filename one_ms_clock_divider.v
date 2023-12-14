`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// 
// Create Date:    13:28:31 11/27/2017 
// Design Name: 
// Module Name:    one_ms_clock_divider
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Divides 100 MHz onboard oscillator into 1 ms clock
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module one_ms_clock_divider(
    input clock, 
    output reg out_clk);
	
	reg[32:0] count;

	initial begin
		// initialize everything to zero
		count = 0;
		out_clk = 0;
	end
	
	always @(posedge clock)
	begin
		// increment count by one
		// if count equals to 100,000,
		//   then flip the output clock,
		//   and reset count to zero.
		
		if (count <= 100000) begin //out_clk has a period of 1 ms
//		if (count <= 100) begin //For simulation purposes
		   count = count +1;
		end else begin
		  count <= 0;
		  out_clk <= ~out_clk;
		end
	end


endmodule