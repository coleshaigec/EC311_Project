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
    output test,
    output [2:0] rank,
    output [1:0] lb_mode,
    output [7:0] cathode,
    output [7:0] anode,
    output blinker
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
//    reg [18:0] init_state = 19'b0000000000000010000;
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
    wire [38:0] disptime;
// Instantiate debouncers

//    debouncer st_debounce(.in(startstop),.clock(clock),.db(db_st));
//    debouncer inc_debounce(.in(increment),.clock(clock),.db(inc));
//    debouncer rst_debounce(.in(reset),.clock(clock),.db(rst));

// Instantiate stopwatch

    reg _startstop = 0;
    //reg _test = 0;
    reg _prog = 0;
    reg _up = 1;
    reg _reset =0;
    reg _increment = 0;
    reg _min = 0;
    stopwatch tl_stopwatch(.s(_startstop),  .init_state(_init_state),.p(_prog), .clk(clock), .u(_up), .rst(_reset), .inc(_increment), .min(_min), .t(t), .zero(zero));
        
// Instantiate time display MUX

// Need to reconfigure leaderboard to get it to spit out six output registers before we can use the time MUX

//  time_MUX dispMUX(.sel(display_mode), .up_time1(up1), .up_time2(up2), .up_time3(up3), .down_time1(down1), .down_time2(down2), .down_time3(down3), .disp_time(disptime), .timewire(t));
    
//Instantiate display

    //debounced_switch_counter dsc(.clock(clock),.time_in(t), .cathode(cathode), .anode(anode));
//    seven_seg_fsm disp_FSM(.clock(clock),.input_number(disptime), .dec_points(decimal_points),.cathode(cathode),.anode(anode));
    seven_seg_fsm disp_FSM(.clock(clock),.input_number(t), .dec_points(decimal_points),.cathode(cathode),.anode(anode));
    //seven_seg_fsm_old disp_FSM(.clock(clock),.mode(1'b0),.input_number(t),.dec_points(decimal_points),.cathode(cathode),.anode(anode));
    
   
    
//Instantiate leaderboard

//   leaderboard tl_leaderboard(.time_in(disptime), .stopwatch_mode(stopwatch_mode), .display_mode(display_mode), .signal_sound_1(sound1),. signal_sound_2(sound2), .signal_sound_3(sound3), .leaderboard_LED(rank), .slow_or_fast(lb_mode), .fast_1(down1), .fast_2(down2), .fast_3(down3), .slow_1(up1), .slow_2(up2), .slow_3(up3));

// Instantiate sound module

// This one will probably need some rejigging in order to accommodate changes to wire I/O
// music music_out(.clk_100MHz(clock), .beep_trigger(zero), .speaker(speaker), .sound1(sound1), .sound2(sound2), .sound3(sound3));    


    //blinker blink(.time_in(t), .clk(clock), .blinker(blinker));
//    blinker blink(.time_in(t), .blinker(blinker));
   
        
endmodule
