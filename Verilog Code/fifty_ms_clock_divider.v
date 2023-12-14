`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// Create Date: 12/09/2023 06:10:12 PM
// Design Name: 
// Module Name: fifty_ms_clock_divider
// Project Name: EC311 Logic Design Final Project
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Divides 100 MHz onboard oscillator into 50 ms clock
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifty_ms_clock_divider(
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
		// if count equals to 5,000,000,
		//   then flip the output clock,
		//   and reset count to zero.
		
		if (count <= 5000000) //out_clk has a period of 50 ms
		//if (count <= 3)     // FOR SIMULATION PURPOSES
		   count <= count +1;
		else begin
		  count <= 0;
		  out_clk <= ~out_clk;
		end
	end


endmodule