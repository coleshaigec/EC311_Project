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
    reg [1:0] mode;
    //wire out_clk;
    reg [38:0] a;
    wire [7:0] cathode;
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
    //always #8 a = a + 8;
    //always #100 mode = ~mode;
    always
        #1 a = a + 100000;
    
    
    
    
    initial begin
        clock = 0;
        a = 1000000000;
        mode = 2;
    end
    initial #200 $finish;
    
endmodule
