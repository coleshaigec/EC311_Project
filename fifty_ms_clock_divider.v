`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 06:10:12 PM
// Design Name: 
// Module Name: fifty_ms_clock_divider
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
		
		if (count <= 5000000) //out_clk has a period of 50 ms
		//if (count <= 3)                 // WILL NOT SIMULATE IF 500000000 TOO LONG FOR SIMULATION TIMESCALE
		   count <= count +1;
		else begin
		  count <= 0;
		  out_clk <= ~out_clk;
		end
	end


endmodule
