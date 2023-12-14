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
    output speaker,
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
    reg [31:0] number_to_display;
    reg [7:0] decimal_points = 8'b00101000;

// Wires for debounced signals
    wire db_st;
    wire inc;
    wire rst;

// Wires for stopwatch I/O signals
    wire zero;
    wire [38:0] t;

// Output wires for leaderboard

    wire sound1;
    wire sound2;
    wire sound3;

// Output registers for leaderboard and time MUX

    wire [38:0] up1;
    wire [38:0] up2;
    wire [38:0] up3;
    wire [38:0] down1;
    wire [38:0] down2;
    wire [38:0] down3;
    wire [38:0] disptime;
    
// Instantiate debouncers

   debouncer st_debounce(.in(startstop),.clock(clock),.db(db_st));
   debouncer inc_debounce(.in(increment),.clock(clock),.db(inc));
   debouncer rst_debounce(.in(reset),.clock(clock),.db(rst));

// Instantiate stopwatch

    stopwatch tl_stopwatch(.s(db_st),.p(prog), .clk(clock), .u(up), .rst(rst), .inc(inc), .min(min), .t(t), .zero(zero));
        
// Instantiate time display MUX

     time_MUX dispMUX(.sel(display_mode), .up_time1(up1), .up_time2(up2), .up_time3(up3), .down_time1(down1), .down_time2(down2), .down_time3(down3), .disp_time(disptime), .timewire(t));
    
//Instantiate display

    //debounced_switch_counter dsc(.clock(clock),.time_in(t), .cathode(cathode), .anode(anode));
//    seven_seg_fsm disp_FSM(.clock(clock),.input_number(disptime), .dec_points(decimal_points),.cathode(cathode),.anode(anode));
    seven_seg_fsm disp_FSM(.clock(clock),.input_number(t), .dec_points(decimal_points),.cathode(cathode),.anode(anode));
    //seven_seg_fsm_old disp_FSM(.clock(clock),.mode(1'b0),.input_number(t),.dec_points(decimal_points),.cathode(cathode),.anode(anode));
    
   
    
//Instantiate leaderboard

   leaderboard tl_leaderboard(.time_in(t), .stopwatch_mode(stopwatch_mode), .display_mode(display_mode), .signal_sound_1(sound1),. signal_sound_2(sound2), .signal_sound_3(sound3), .leaderboard_LED(rank), .slow_or_fast(lb_mode), .fast_1(down1), .fast_2(down2), .fast_3(down3), .slow_1(up1), .slow_2(up2), .slow_3(up3));

// Instantiate sound module

 beep make_sound(.clk(clock),.speaker(speaker), .value(sound1), .value_2(zero), .value_3(sound2), .value_4(sound3));
        
endmodule
