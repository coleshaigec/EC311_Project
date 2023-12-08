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



module button_debounce(
    input BTN,
    input clock,
    output BTN_press
    );
    
    wire ms_clock;
    wire Q1,Q2,Q3;
    
    clock_divider clock_div(clock,ms_clock);
    D_Flip_Flop D1(BTN, ms_clock,BTN_press);
    //D_Flip_Flop D2(Q1,seconds_clock,Q2);
    //D_Flip_Flop D3(Q2,seconds_clock,Q3);
    //and(BTN_press, Q1,Q2,Q3);
    
    
    /*always @(seconds_clock) begin
        Q1 <= BTN;
        Q2 <= Q1;
        Q3 <= Q2;
    end*/

    
endmodule
