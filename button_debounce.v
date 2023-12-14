`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// 
// Create Date: 10/23/2023 05:48:28 PM
// Design Name: 
// Module Name: button_debounce
// Project Name: EC311 Logic Design Final Project
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Debounces buttons and switches with a delay of 50ms
// 
// Dependencies: fifty_ms_clock_divider.v
//               D_Flip_Flop.v
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
    input in, //Input button / switch
    input clock,
    output db //Output debounced button / switch
    );
    
    wire div_clock;
  
    fifty_ms_clock_divider clock_div(clock,div_clock); // Debouncer holds signal for a period of 50ms
    D_Flip_Flop D1(in, div_clk,db); // Debouncing mechanism
    
endmodule