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

module button_debounce(
    input BTN,
    input clock,
    output BTN_press
    );
    
    wire div_clock;
    reg [5:0] counter;
    
    fifty_ms_clock_divider clock_div(clock,div_clock);
    D_Flip_Flop D1(BTN, div_clock,BTN_press);
    
    
    

    
endmodule
