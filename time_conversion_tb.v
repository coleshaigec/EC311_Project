`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 11:19:34 AM
// Design Name: 
// Module Name: time_conversion_tb
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


module time_conversion_tb(

    );
    
    reg [38:0] time_in;
    //wire [5:0] min;
    //wire [5:0] sec;
    //wire [9:0] ms;
    wire [31:0] time_out;
    
    //time_conversion uut(time_in,min,sec,ms);
    time_conversion uut(time_in,time_out);

   
   always begin
        #10 time_in = time_in + 1000000;
   end
   
   initial begin
        time_in = 3000000000;
   end 
   
endmodule
