`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 11:26:07 AM
// Design Name: 
// Module Name: top
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

// NEW SIGNAL ASSIGNMENTS

// BUTTONS
// startstop        |  starts and stops stopwatch count when in run mode
// reset            |  resets count
// inc              |  increment signal for program mode

// SWITCHES
// prog             |  sets stopwatch to program mode
// up               |  stopwatch counts up when this signal is high and counts down when it is low
// min              |  increment signal adds minutes to maxtime register when this is high; adds seconds when it is low
// [2:0] disp_mode  |  determines which leaderboard value is shown on the 7-segment display


// OUTPUTS
// [7:0] anode      |  anode signal for 7SD
// [7:0] cathode    |  cathode signal for 7SD
// speaker          |

module top_level_module(
    //IO inputs
    input startstop,
    input reset,
    input inc,
    input prog,
    input up,
    input min,
    input [2:0] disp_mode,
    //Clock input
    input clock,
    //IO outputs
    output [7:0] cathode,
    output [7:0] anode,
    output speaker
);

// Wire and register declarations

    // For 7-segment display
    reg display_number_format;
    reg [31:0] number_to_display;
    reg [7:0] decimal_points;

    // For debouncer
    wire ;
    wire debounced_BTNC;
    wire debounced_BTNU;
    wire debounced_BTND;
    wire debounced_BTNL;
    wire debounced_BTNR;

    //For leaderboard - Some of these may need to registers
    wire [21:0] leaderboard_time_in;
    wire [1:0] leaderboard_stopwatch_mode;
    wire [2:0] leaderboard_display_mode;
    wire [21:0] leaderboard_number;
    wire signal_sound_1;
    wire signal_sound_2;
    wire signal_sound_3;
    wire [2:0] leaderboard_LED;
    wire [1:0] leaderboard_slow_or_fast;

//Instantiate display
    seven_seg_fsm disp(clock,display_number_format,number_to_display,decimal_points,cathode,anode);
    
//Instantiate debouncers --> may need to change nomenclature and switch to dot assignments
    debouncer BTNC_debouncer(BTNC,clock,debounced_BTNC);
    debouncer BTNU_debouncer(BTNU,clock,debounced_BTNU);
    debouncer BTND_debouncer(BTND,clock,debounced_BTND);
    debouncer BTNL_debouncer(BTNL,clock,debounced_BTNL);
    debouncer BTNR_debouncer(BTNR,clock,debounced_BTNR);
    
    debouncer sw0_debouncer(sw[0],clock,debounced_sw[0]);
    debouncer sw1_debouncer(sw[1],clock,debounced_sw[1]);
    debouncer sw2_debouncer(sw[2],clock,debounced_sw[2]);
    debouncer sw3_debouncer(sw[3],clock,debounced_sw[3]);
    debouncer sw4_debouncer(sw[4],clock,debounced_sw[4]);
    debouncer sw5_debouncer(sw[5],clock,debounced_sw[5]);
    debouncer sw6_debouncer(sw[6],clock,debounced_sw[6]);
    debouncer sw7_debouncer(sw[7],clock,debounced_sw[7]);
    debouncer sw8_debouncer(sw[8],clock,debounced_sw[8]);
    debouncer sw9_debouncer(sw[9],clock,debounced_sw[9]);
    debouncer sw10_debouncer(sw[10],clock,debounced_sw[10]);
    debouncer sw11_debouncer(sw[11],clock,debounced_sw[11]);
    debouncer sw12_debouncer(sw[12],clock,debounced_sw[12]);
    debouncer sw13_debouncer(sw[13],clock,debounced_sw[13]);
    debouncer sw14_debouncer(sw[14],clock,debounced_sw[14]);
    debouncer sw15_debouncer(sw[15],clock,debounced_sw[15]);
    
//Instantiate leaderboard
    leaderboard leaderboard_instance (
        .time_in(leaderboard_time_in),
        .stopwatch_mode(leaderboard_stopwatch_mode),
        .display_mode(leaderboard_display_mode),
        .leaderboard_number(leaderboard_number),
        .signal_sound_1(signal_sound_1),
        .signal_sound_2(signal_sound_2),
        .signal_sound_3(signal_sound_3),
        .leaderboard_LED(leaderboard_LED),
        .slow_or_fast(leaderboard_slow_or_fast)
    );

//Set initial values
    initial begin
        display_number_format = 0; //Default to decimal mode
        number_to_display = 0;
        decimal_points = 0;
    end
    
    

endmodule
