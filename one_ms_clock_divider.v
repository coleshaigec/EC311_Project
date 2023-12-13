`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:28:31 11/27/2017 
// Design Name: 
// Module Name:    Cloc_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
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
		// if count equals to some big number (that you need to calculate),
		//   then flip the output clock,
		//   and reset count to zero.
		
		//if (count <= 100000) //out_clk has a period of 1 ms
		if (count <= 100000) begin //out_clk has a period of 1 ms
		//if (count <= 3) begin              // WILL NOT SIMULATE IF 500000000 TOO LONG FOR SIMULATION TIMESCALE
		   count = count +1;
		end else begin
		  count <= 0;
		  out_clk <= ~out_clk;
		end
	end


endmodule