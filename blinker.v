`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/12/2023 09:35:51 PM
// Design Name: 
// Module Name: blinker
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


module blinker(
    input [38:0] time_in,
    //input clk,
    output reg blinker
    );
    
   reg [32:0] count;
    
    always @*
	begin
//	count = time_in;
//		blinker = 1;
//    end
//		if (count <= 100) //out_clk has a period of 1000 ms
		if(count <= 100000000) begin //out_clk has a period of 10 ms
		      if (time_in[8] == 1) begin                // WILL NOT SIMULATE IF 500000000 TOO LONG FOR SIMULATION TIMESCALE
//		      blinker = 0;
//		      end
            count = count + 1;
            //blinker = ~blinker;
		  end 
		else begin
          //blinker = 1;
        	count = 0;
            blinker = ~blinker;
		end end
	end
	
	initial begin
	   blinker = 0;
//	   count = 0;
    end
    
endmodule
