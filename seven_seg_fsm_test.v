`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 08:54:59 AM
// Design Name: 
// Module Name: fsm_test
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


module seven_seg_fsm_test(

    );
    
    reg clock; 
    reg mode;
    wire out_clk;
    reg [31:0] a;
    wire [6:0] cathode;
    wire [7:0] anode;
    
    seven_seg_fsm DUT (
        .clock(clock),
        .mode(mode),
        .input_number(a),
        .cathode(cathode),
        .anode(anode)
    ); 
    
    // Clock generator
    always #1 clock = ~clock;
    always #8 a = a + 8;
    always #100 mode = ~mode;
    
    initial begin
        clock = 0;
        a = 0;
        mode = 0;
    end
    initial #200 $finish;
    
endmodule
