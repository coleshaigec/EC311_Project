`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 06:21:38 PM
// Design Name: 
// Module Name: debounced_switch_counter
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

//For testing button and switch debouncing
//May require this line in constraints file: set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTNC_IBUF]


module debounced_switch_counter(
    input [15:0]sw,
    //input BTNC,
    input clock,
    //output reg [7:0]led
    output [6:0] cathode,
    output [7:0] anode
    );
    
    reg mode;
    wire debounced_sw;
    reg [7:0]count;
    reg [7:0] decs = 8'b10101010;
    
    //counter ct(debounced_swt,count);
    seven_seg_fsm disp(clock,mode,count,decs,cathode,anode);
    button_debounce switch(swt[0],clock,debounced_sw);
    
    initial begin
        mode = 1;
        count = 0;
    end
    
    always @(posedge debounced_sw) begin
        count <= count + 1; 
    end
    
    
    
endmodule


