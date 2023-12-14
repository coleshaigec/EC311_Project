`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 04:40:05 PM
// Design Name: 
// Module Name: tb_stopwatch
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

module tb_top(

    );

// This testbench module contains multiple testbench configurations that thoroughly test the stopwatch's functionality
// Each one is preceded by comments explaining what it does
// Only one configuration should be active at any given time with the others being commented out before running sim
// All testbenches use the same 100MHz ck frequency/10ns period as the NEXYS A7 100t FPGA board's built-in clock


// STOPWATCH MODULE I/0:
    //    input s,                    // START/STOP signal for the stopwatch 
    //    input p,                    // PROGRAM: if 0, the stopwatch runs; if 1, the stopwatch enters programming mode
    //    input clk,
    //    input u,                    // UP: if 1, the stopwatch counts up; if 0, the stopwatch counts down
    //    input rst,                  // RESET: resets the time during stopwatch operation
    //    input inc,                  // INCREMENT: used in the programming mode to increase the maxtime
    //    input min,                  // MINUTE: used in the programming mode
    //    output reg [22:0] t_out,    // TIME (in milliseconds): this is the main output of the module
    //    output zero                 // if the countdown mode is active and the time runs out, this signal goes to sound module to tell it to beep

// Signal declarations

reg startstop;
reg prog;
reg clk;
reg up;
reg inc;
reg rst;
reg min;
reg [1:0] swm;
reg [2:0] dm;
reg [1:0] lbm;
wire [2:0] rank;
wire [7:0] cathode;
wire [7:0] anode;
wire speaker;
//reg [1:0] lb_mode;
//wire [38:0] t_out;
//wire zero;

// Instantiate module

top top_UUT(.prog(prog), .increment(inc), .reset(rst), .clock(clk), .min(min), .up(up), .startstop(startstop), .stopwatch_mode(swm), .display_mode(dm), .speaker(speaker), .rank(rank), .cathode(cathode), .anode(anode));

// Generate signals
   
initial begin
    clk = 0;
    prog = 0;
    up = 1; 
    inc = 0;
    min = 0;
    startstop = 0; rst = 0; #100;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #195;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #50;
    startstop = 0; rst = 1; #18;
    startstop = 0; rst = 0; #100;
    startstop = 1; rst = 0; #20;
    startstop = 0; rst = 0; #150;
    startstop = 0; rst = 1; #18;
    startstop = 0; rst = 0;
    clk = 0;
    prog = 0;
    up = 0; 
    inc = 0;
    min = 0;
    startstop = 0; rst = 0; #100;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #195;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #50;
    startstop = 0; rst = 1; #18;
    startstop = 0; rst = 0; #100;
    startstop = 1; rst = 0; #20;
    startstop = 0; rst = 0; #150;
    startstop = 0; rst = 1; #18;
    startstop = 0; rst = 0;
     clk = 0;
    prog = 0;
    up = 0; 
    inc = 0;
    min = 1;
    startstop = 0; rst = 0; #16;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #200;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; prog = 1;
    inc = 1; #16;
    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
    inc = 1; #16;
//    inc = 0; #12;
//    inc = 1; #12;

    min = 0;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0;
    prog = 0;
    rst = 1; #15
    rst = 0; #100
    startstop = 1; rst = 0; #17
    startstop = 0;
     clk = 0;
    prog = 0;
    up = 0; 
    inc = 0;
    min = 0;
    startstop = 0; rst = 0; #16;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #50;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #120;
    prog = 1;
    inc = 1; #16;
    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
    inc = 1; #16;
//    inc = 0; #12;
//    inc = 1; #12;

    min = 0;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0;
    prog = 0;
    rst = 1; #15
    rst = 0; #100
    startstop = 1; rst = 0; #17
    startstop = 0;
    
    
    
    #5000 $finish;
    end
always begin
#10 clk = ~clk;
end


// CONFIGURATION TWO
// This configuration tests the hard-coded count-down functionality on the stopwatch
// Up signal hard-coded at zero
// Program signal hard-coded at zero to push the stopwatch to the HCT mode

//initial begin
//    clk = 0;
//    prog = 0;
//    up = 0; 
//    inc = 0;
//    min = 0;
//    startstop = 0; rst = 0; #100;
//    startstop = 1; rst = 0; #15;
//    startstop = 0; rst = 0; #195;
//    startstop = 1; rst = 0; #15;
//    startstop = 0; rst = 0; #50;
//    startstop = 0; rst = 1; #18;
//    startstop = 0; rst = 0; #100;
//    startstop = 1; rst = 0; #20;
//    startstop = 0; rst = 0; #150;
//    startstop = 0; rst = 1; #18;
//    startstop = 0; rst = 0;
//end

//always begin
//#10 clk = ~clk;
//end

// CONFIGURATION THREE
// This configuration tests the program mode on the stopwatch
// The program signal is hard-coded at 1
// The signals here can easily be altered to test responses to various incrementing behaviors (seconds, minutes, resets, etc.)
// This mode appears to be working correctly

//initial begin
//    clk = 0;
//    prog = 0;
//    up = 0; 
//    inc = 0;
//    min = 1;
//    startstop = 0; rst = 0; #16;
//    startstop = 1; rst = 0; #15;
//    startstop = 0; rst = 0; #200;
//    startstop = 1; rst = 0; #15;
//    startstop = 0; rst = 0; prog = 1;
//    inc = 1; #16;
//    inc = 0; #12;
////    inc = 1; #12;
////    inc = 0; #12;
//    inc = 1; #16;
////    inc = 0; #12;
////    inc = 1; #12;

//    min = 0;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0;
//    prog = 0;
//    rst = 1; #15
//    rst = 0; #100
//    startstop = 1; rst = 0; #17
//    startstop = 0;
//end

//always begin
//#10 clk = ~clk;
//end

// CONFIGURATION FOUR
// This mode tests transitions between states, with a particular focus on ensuring seamless transitions into and out of program mode

//initial begin
//    clk = 0;
//    prog = 0;
//    up = 0; 
//    inc = 0;
//    min = 0;
//    startstop = 0; rst = 0; #16;
//    startstop = 1; rst = 0; #15;
//    startstop = 0; rst = 0; #50;
//    startstop = 1; rst = 0; #15;
//    startstop = 0; rst = 0; #120;
//    prog = 1;
//    inc = 1; #16;
//    inc = 0; #12;
////    inc = 1; #12;
////    inc = 0; #12;
//    inc = 1; #16;
////    inc = 0; #12;
////    inc = 1; #12;

//    min = 0;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0; #12;
//    inc = 1; #12;
//    inc = 0;
//    prog = 0;
//    rst = 1; #15
//    rst = 0; #100
//    startstop = 1; rst = 0; #17
//    startstop = 0;
//end

//always begin
//#10 clk = ~clk;
//end


//always begin
//#10 clk = ~clk;
//end

endmodule
