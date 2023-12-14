`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 06:10:54 PM
// Design Name: 
// Module Name: DFF_test
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


module DFF_test(

    );
    
    reg D, clock;
    wire Q/*, Q_bar*/;
    
    D_Flip_Flop DFF(D,clock,Q/*,Q_bar*/);
    
    always
      #10  clock = ~clock;
    always
        #20 D = ~D;
      
    
    initial begin
        D = 0;
        clock = 0;
        #80 $finish;
    end 

     
    
endmodule
