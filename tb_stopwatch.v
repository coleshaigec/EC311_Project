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

module tb_stopwatch(

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
wire [38:0] t_out;
wire zero;

// Instantiate module

stopwatch stopwatch_UUT(.s(startstop), .p(prog), .clk(clk), .u(up), .rst(rst), .inc(inc), .min(min), .t(t_out), .zero(zero));

// Generate signals

// CONFIGURATION ONE
// This configuration tests the count up functionality on the stopwatch
// The program signal is hard-coded at zero for the duration of the simulation (as there is no need to program the stopwatch for it to count up)
// The up signal is hard-coded at one for the duration of the simulation, as this testbench does not leave the count-up mode
// This testbench runs through the states in count-up, moving the machine from the starting state through the count-up cycle to verify outputs

//initial begin
//    clk = 0;
//    prog = 0;
//    up = 1; 
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

initial begin
//    clk = 0;
//    prog = 1;
//    up = 0; 
//    inc = 0;
//    min = 1;
//    startstop = 0;
    clk = 0;
    prog = 0;
    up = 0; 
    inc = 0;
    min = 0;
    startstop = 0; rst = 0; #16;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0; #200;
    startstop = 1; rst = 0; #15;
    startstop = 0; rst = 0;
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
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0; #12;
    inc = 1; #12;
    inc = 0;
    rst = 1; #15
    rst = 0;
    startstop = 1; rst = 0; #17
    startstop = 0;
end

always begin
#10 clk = ~clk;
end






endmodule
