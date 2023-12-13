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
wire blinker;
//reg [1:0] lb_mode;
//wire [38:0] t_out;
//wire zero;

// Instantiate module

top top_UUT(.prog(prog), .increment(inc), .reset(rst), .clock(clk), .min(min), .up(up), .startstop(startstop), .stopwatch_mode(swm), .display_mode(dm), .rank(rank), .cathode(cathode), .anode(anode) ,.blinker(blinker));

// Generate signals

initial begin
    clk = 0;
    prog = 0;
    up = 1; 
    inc = 0;
    min = 0;
    dm = 0;
    rst = 0;
    swm = 0;
    startstop = 0;
//    #50
//    startstop = 1; #18;
//    startstop = 0;
end

always begin
#10 clk = ~clk;
end

endmodule
