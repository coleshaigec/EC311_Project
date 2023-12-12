`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Cole Shaigec, Alex Melnick, Henry Bega, Macy Bryer-Charette
// 
// Create Date: 12/11/2023 11:26:07 AM
// Design Name: Stopwatch
// Module Name: top
// Project Name: 
// Target Devices: XILINX ARTIX-7
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

// NEW SIGNALS

// BUTTONS
// startstop
// inc
// rst

// SWITCHES
// [2:0] display_mode
// prog
// up
// min
// [1:0] stopwatch_mode


// LED output
// 5 LEDs for Henry
// 2 for slow_or_fast
// 3 for leaderboard_LED

module top (
    input prog,
    input increment,
    input reset,
    input up,
    input min,
    input startstop,
    input [1:0] stopwatch_mode,
    input  [2:0] display_mode,
    input clock,
//    output speaker,
    output [2:0] rank,
    output [1:0] lb_mode,
    output [7:0] cathode,
    output [7:0] anode
);

reg on = 1;
// Wire and register declarations

// Registers for display
    //reg display_number_format;
    reg [31:0] number_to_display;
    reg [7:0] decimal_points = 8'b00101000;

// Wires for debounced signals
    wire db_st;
    wire inc;
    wire rst;

// Wires for stopwatch i/O signals
    wire zero;
//    wire clkSW;
    wire [38:0] t;
//    one_ms_clock_divider Babs(clock, clkSW);

// Output wires for leaderboard

    wire sound1;
    wire sound2;
    wire sound3;

// Output registers for leaderboard and time MUX

//    wire [38:0] up1;
//    wire [38:0] up2;
//    wire [38:0] up3;
//    wire [38:0] down1;
//    wire [38:0] down2;
//    wire [38:0] down3;
//    wire [38:0] disptime;
// Instantiate debouncers

//    debouncer st_debounce(.in(startstop),.clock(clock),.db(db_st));
//    debouncer inc_debounce(.in(increment),.clock(clock),.db(inc));
//    debouncer rst_debounce(.in(reset),.clock(clock),.db(rst));

// Instantiate stopwatch

    stopwatch tl_stopwatch(.s(startstop), .p(prog), .clk(clock), .u(up), .rst(reset), .inc(inc), .min(min), .t(t), .zero(zero));
        
// Instantiate time display MUX

// Need to reconfigure leaderboard to get it to spit out six output registers before we can use the time MUX

//    time_MUX dispMUX(.sel(display_mode), .up_time1(up1), .up_time2(up2), .up_time3(up3), .down_time1(down1), .down_time2(down2), .down_time3(down3), .disp_time(disptime), .timewire(t));
    
//Instantiate display

    seven_seg_fsm disp_FSM(.clock(clock),.input_number(t), .dec_points(decimal_points),.cathode(cathode),.anode(anode));
    
//Instantiate leaderboard

//    leaderboard tl_leaderboard(.time_in(disptime), .stopwatch_mode(stopwatch_mode), .display_mode(display_mode), .signal_sound_1(sound1),. signal_sound_2(sound2), .signal_sound_3(sound3), .leaderboard_LED(rank), .slow_or_fast(lb_mode), .fast_1(down1), .fast_2(down2), .fast_3(down3), .slow_1(up1), .slow_2(up2), .slow_3(up3));

// Instantiate sound module

// This one will probably need some rejigging in order to accommodate changes to wire I/O
// music music_out(.clk_100MHz(clock), .beep_trigger(zero), .speaker(speaker), .sound1(sound1), .sound2(sound2), .sound3(sound3));    

endmodule
