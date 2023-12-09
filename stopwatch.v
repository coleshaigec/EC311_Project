`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 04:33:05 PM
// Design Name: 
// Module Name: stopwatch
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

module stopwatch(
    input s,                    // START/STOP signal for the stopwatch 
    input p,                    // PROGRAM: if 0, the stopwatch runs; if 1, the stopwatch enters programming mode
    input clk,
    input u,                    // UP: if 1, the stopwatch counts up; if 0, the stopwatch counts down
    input rst,                  // RESET: resets the time during stopwatch operation
    input inc,                  // INCREMENT: used in the programming mode to increase the maxtime
    input min,                  // MINUTE: used in the programming mode
    output reg [22:0] t_out,    // TIME (in milliseconds): this is the main output of the module
    output zero                 // if the countdown mode is active and the time runs out, this signal goes to sound module to tell it to beep
    );
    
    // stopwatch time count increments every millisecond
    // code below instantiates external clock divider module 
    
//    reg ms_clk; here if needed for clock divider

    // register declarations

    reg [22:0] t;                           // intermediate time register
    reg [21:0] HCT;                         // Hard Coded Time - if the user doesn't program a time, this holds a preset countdown time for that mode
    reg [21:0] maxtime;                     // captures the time programmed by the user; configured to allow up to 59 minutes 59 seconds
    reg [21:0] u_count;                     // supports the counter in count-up mode
    reg [21:0] d_count;                     // supports the counter in count-down mode
    reg [21:0] fix_d_count;                 // supports the counter in hard coded time count-down mode
    reg [16:0] present_state, next_state;   // used in the finite state machine in this module
    
    // parameter declarations for FSM states
    // 17 states, using one hot encoding
    
    parameter S0 = 17'b00000000000000001;
    parameter S1 = 17'b00000000000000010;
    parameter S2 = 17'b00000000000000100;
    parameter S3 = 17'b00000000000001000;
    parameter S4 = 17'b00000000000010000;
    parameter S5 = 17'b00000000000100000;
    parameter S6 = 17'b00000000001000000;
    parameter S7 = 17'b00000000010000000;
    parameter S8 = 17'b00000000100000000;
    parameter S9 = 17'b00000001000000000;
    parameter S10 = 17'b00000010000000000;
    parameter S11 = 17'b00000100000000000;
    parameter S12 = 17'b00001000000000000;
    parameter S13 = 17'b00010000000000000;
    parameter S14 = 17'b00100000000000000;
    parameter S15 = 17'b01000000000000000;
    parameter S16 = 17'b10000000000000000;
    
    // initialize FSM
    
    initial begin
        present_state <= S0;                        // machine will stay in start state for one clock cycle
        next_state <= S0;                           // machine will stay in start state for one clock cycle
        HCT <= 22'b0000001110101001100000;           // hard coded time initially set at one minute
        maxtime <= 22'b0000000000000000000000;      // initialize all count registers at zero
        u_count <= 22'b0000000000000000000000;      // initialize all count registers at zero
        d_count <= 22'b0000000000000000000000;      // initialize all count registers at zero
        fix_d_count <= 22'b0000000000000000000000;  // initialize all count registers at zero
    end
        
    // implement finite state machine
    
    // NOTE TO SELF: HOW DO WE PUT THE PROGRAMMED VALUE INTO MAXTIME?
    // ONE POSSIBILITY IS TO TAKE MAXTIME AS AN INPUT FROM THE PROGRAMMER MODULE INSIDE THE TLM AND THEN ALWAYS REFRESH IT AT POSEDGE CLK
    // UPDATE: I THINK WHAT I HAVE WORKS; JUST KEEPING THIS NOTE HERE FOR REFERENCE
    
    // NOTE TO SELF: CHECK S5 AND S9; IT MAY BE NECESSARY TO ADJUST THE INCREMENTS DEPENDING ON HOW THE CLOCK IS STRUCTURED
    
    // NOTE TO SELF: WILL NEED A WAY TO TURN A COUNT IN NS INTO AN OUTPUT IN MS - PERHAPS BY USING AN ASSIGN STATEMENT AND DIVIDING BY N AT THE END OF THE MODULE?
    
    // NOTE TO SELF: THE ARITHMETIC IN S12 HARDLY INSPIRES CONFIDENCE AND COULD BE A SOURCE OF ERROR - KEEP AN EYE ON IT!
     
     // NOTE TO SELF: I SCREWED THE POOCH WITH THE NS/MS CONVERSIONS IN DESIGNING THE ORIGINAL FSM
     // MODIFICATION IS NEEDED TO PRODUCE MS OUTPUT AND ENSURE CORRECT INCREMENTING
     // STATES S15 AND S16 REQUIRE PARTICULAR ATTENTION IN THIS RESPECT
     
    always @(posedge clk) begin
        case(present_state)
        S0:
           begin
            if (p) begin
                t = 22'b0000000000000000000000;
                next_state = S1;
            end
            else if (~p) begin
                t = 22'b0000000000000000000000;
                next_state = S2;
            end
           end
       S1:
           begin    
            if (~p && ~u) begin      // note to self: this state logic may require some reconfiguration depending on how the debouncers are used - presumably we would want a switch for program mode so that our signal stays high
                next_state = S7;
                t = maxtime;
            end
            else if (~p && u) begin
                next_state = S3;
                t = maxtime;
            end
            else if (p && inc && min) begin
                next_state = S15;
                t = maxtime;
            end
            else if (p && inc && ~min) begin
                next_state = S16;
                t = maxtime;
            end
            else if (p && ~inc) begin
                next_state = S1;
                t = maxtime;
            end
           end 
       S2:
        begin
          if (p) begin
            next_state = S1;
          end
          else if (~p && ~u) begin
            next_state = S11;
          end
          else if (~p && u) begin
            next_state = S3;
          end
        end
       S3:
        begin
         if (p) begin
          next_state = S1;
          t = 0;
         end
         else if (~p && ~u) begin
          next_state = S2;
          t = 0;
         end
         else if (~p && u && s) begin
          next_state = S4;
          t = 0;
         end
         else if (~p && u && ~s) begin
           next_state = S3;
           t = 0;
         end
        end
       S4:
        begin
         if (p) begin
          next_state = S1;
          t = u_count;
         end
         else if (~p && ~u) begin
          next_state = S0;
          t = u_count;
         end
         else if (~p && u && ~rst && ~s) begin
          next_state = S5;
          t = u_count;
         end             
         else if (~p && u && rst) begin
          next_state = S3;
          t = u_count; 
         end
         else if (~p && u && ~rst && s) begin
          next_state = S6;
          t = u_count;   
         end
        end
       S5:
        begin
          next_state = S4;
          u_count = u_count + 22'b0000000000000000000001;
        end
       S6:
        begin 
         if (p) begin
          next_state = S1;
         end
         else if (~p && ~u) begin
          next_state = S0;
         end
         else if (~p && u && ~rst && ~s) begin 
          next_state = S6;
         end
         else if (~p && u && ~rst && s) begin
          next_state = S4;
         end
        end
       S7:
        begin
         if (p) begin
          next_state = S1;
          t = maxtime;
         end
         else if (~p && u) begin
          next_state = S0;
          t = maxtime;
         end
         else if (~p && ~u && ~s) begin
          next_state = S7;
          t = maxtime;
         end
         else if (~p && ~u && s) begin
           next_state = S8;
           t = maxtime;
         end
        end
       S8:
        begin
          if (p) begin
           next_state = S1;
           t = d_count;
          end
          else if (~p && u) begin
            next_state = S0;
            t = d_count;
          end
          else if (~p && ~u && ~rst && ~s) begin
            next_state = S9;
            t = d_count;
          end
          else if (~p && ~u && ~rst && s) begin
            next_state = S10;
            t = d_count;
          end
          else if (~p && ~u && rst) begin
            next_state = S7;
            t = d_count;
          end
        end
       S9:
         begin
            next_state = S8;
            d_count = d_count - 22'b0000000000000000000001;
         end       
       S10:
         begin
          if (p) begin
            next_state = S1;
          end
          else if (~p && u) begin
            next_state = S0;
          end
          else if (~p && ~u && ~rst && ~s) begin
            next_state = S10;
          end
          else if (~p && ~u && ~rst && s) begin
            next_state = S8;
          end
          else if (~p && ~u && rst) begin
            next_state = S7;
          end
         end
       S11:
        begin
         if (p) begin
            next_state = S1;
            t = HCT;
         end
         else if (~p && u) begin   
          next_state = S0;
          t = HCT;
         end
         else if (~p && ~u && ~s) begin
          next_state = S11;
          t = HCT;
         end
         else if (~p && ~u && s) begin
          next_state = S12;
          t = HCT;
         end
        end
       S12:
        begin
         if (p) begin
          next_state = S1;
          t = HCT - fix_d_count;
         end 
         else if (~p && u) begin
          next_state = S0;
          t = HCT - fix_d_count;
         end
         else if (~p && ~u && ~rst && s) begin
          next_state = S14;
          t = HCT - fix_d_count;
         end
         else if (~p && ~u && rst) begin
          next_state = S11;
          t = HCT - fix_d_count;
         end
         else if (~p && ~u && ~rst && ~s) begin
          next_state = S13;
          t = HCT - fix_d_count;
         end
        end
       S13:
        begin
         next_state = S12;
         fix_d_count = fix_d_count + 22'b0000000000000000000001;
        end
       S14: 
        begin
         if (p) begin
          next_state = S1;
         end
         else if (~p && u) begin
          next_state = S0;
         end
         else if (~p && ~u && rst) begin
          next_state = S11;
         end
         else if (~p && ~u && ~rst && ~s) begin
          next_state = S14;
         end
         else if (~p && ~u && ~rst && s) begin
          next_state = S12;
         end
        end
       S15:
        begin
         next_state = S1;
         maxtime = maxtime + 22'b0000001110101001100000;
        end
       S16:
        begin
        next_state = S1;
        maxtime = maxtime + 22'b0000000000001111101000; 
        end         
       endcase
       present_state = next_state;
    end   
    
//    programmer program_clock(.clk(clk), .minute(minute), .button(increment), .maxtime(u_tlim));
    
//    clock_divider millisecondclock(.clk_in(clk), .clk_out(ms_clk));
    
    // if count_up == 1, stopwatch counts up
    // if count_up == 0, stopwatch counts down from the time set in the decoder
    // if countdown_game == 1, the stopwatch starts at maxtime
    // the difference between count_up == 0 (countdown mode) and the countdown game is that the countdown game involves stopping the clock near zero 
    // the countdown mode, by contrast, just outputs a sound when timecount hits zero
    
    // this one is FSM
    // if the mode is program, the machine needs to sit in the program state until that signal goes low
    // if the mode is count_up, the timecount needs to be zeroed and then the machine sits in an idle state
    // countdown game switch is going to dominate - if you want the countdown game, you get it, no matter what else is high
    // countdown game: start at maxtime and count down --> will just pass the results to Henry and let him decide what to do with them; need to talk with him about it
    // need to be passing time_count signal to 7SD every BOARD clock cycle -- will be up to Alex to convert ms time count to be usable in his decoder
    // once in the start state:
    //      if in count_up, need to increment count every clock cycle (ns or ms?) - need a built-in overflow protection here
    //      if in count_down, need to decrement count every clock cycle (ns or ms?) - there's also a conditional on us being above zero
    //      if in countdown game, decrement every clock cycle as long as we're above zero
    //      continue cycling through three-state incrementing process unless user presses stop or program
    // this is a damn big state machine!
    
endmodule
