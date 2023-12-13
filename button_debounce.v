`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 05:48:28 PM
// Design Name: 
// Module Name: button_debounce
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




// USED CIRCUIT SCHEMATIC FROM https://allaboutfpga.com/vhdl-code-for-debounce-circuit-in-fpga/

//May require this line in constraints file: set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTNC_IBUF]
//Works for switches and buttons

module debouncer(
    input in,
    input clock,
    output db
    );
    
    wire div_clock;
    reg[32:0] count;
    reg out_clk;    
    
    fifty_ms_clock_divider clock_div(clock,div_clock);
    //D_Flip_Flop D1(in, out_clk,db);
    D_Flip_Flop D1(in, div_clk,db);
    
    
   

	initial begin
		// initialize everything to zero
		count = 0;
		out_clk = 0;
	end
	
	/*always @(posedge clock)
	begin
		// increment count by one
		// if count equals to some big number (that you need to calculate),
		//   then flip the output clock,
		//   and reset count to zero.
		
		if (count <= 2) //out_clk has a period of 20 ms
		//if (count <= 3)                 // WILL NOT SIMULATE IF 500000000 TOO LONG FOR SIMULATION TIMESCALE
		   count = count +1;
		else begin
		  count <= 0;
		  out_clk <= ~out_clk;
		end
	end*/
    

    
endmodule