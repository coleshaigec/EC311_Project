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
    output reg [38:0] t,        // TIME: this is the main output of the module
    output reg zero             // if the countdown mode is active and the time runs out, this signal goes to sound module to tell it to beep
    );
    
    // s, rst, and inc are buttons
    // p, u, and min are switches
    
    // stopwatch time count increments every clock cycle (10ns)
    // code below instantiates external clock divider module 
    
//    reg ms_clk; here if needed for clock divider

    // register declarations
    // time count is 39 bits in size - maximum time that can be processed by this design is 59 minutes and 59 seconds
    
    reg [38:0] HCT;                         // Hard Coded Time - if the user doesn't program a time, this holds a preset countdown time for that mode
    reg [38:0] maxtime;                     // captures the time programmed by the user; configured to allow up to 59 minutes 59 seconds
    reg [38:0] u_count;                     // supports the counter in count-up mode
    reg [38:0] d_count;                     // supports the counter in count-down mode
    reg [38:0] fix_d_count;                 // supports the counter in hard coded time count-down mode
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
        present_state = S0;                                          // machine will stay in start state for one clock cycle
        next_state = S0;                                             // machine will stay in start state for one clock cycle
        HCT = 39'b000000000000000000000001110101001100000;           // hard coded time initially set at one minute
        maxtime = 0;                                                 // initialize all count registers at zero
        u_count = 0;                                                 // initialize all count registers at zero
        d_count = 0;                                                 // initialize all count registers at zero
        fix_d_count = 0;                                             // initialize all count registers at zero
    end
        
    // implement finite state machine
    
    // NOTE TO SELF: CHANGE BITWIDTH OF OUTPUT TO TOP OUT AT 59 MINUTES 59 SECONDS
    //  Also modify logic to include a reset provision at max
    
    // NOTE TO SELF: CHECK S5 AND S9; IT MAY BE NECESSARY TO ADJUST THE INCREMENTS DEPENDING ON HOW THE CLOCK IS STRUCTURED
    
    // NOTE TO SELF: WILL NEED A WAY TO TURN A COUNT IN NS INTO AN OUTPUT IN MS - PERHAPS BY USING AN ASSIGN STATEMENT AND DIVIDING BY N AT THE END OF THE MODULE?
    
    // NOTE TO SELF: THE ARITHMETIC IN S12 HARDLY INSPIRES CONFIDENCE AND COULD BE A SOURCE OF ERROR - KEEP AN EYE ON IT!
     
     // NOTE TO SELF: STATES S15 AND S16 REQUIRE ATTENTION TO ENSURE CORRECT INCREMENTING
     
    always @(posedge clk) begin
        case(present_state)
        S0:
           begin
            if (p && rst) begin
              maxtime = 0;      
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S1;
            end
            if (~p && rst) begin
              maxtime = 0;      
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S0;
            end
            if (p && ~rst) begin
                t = 0;
                next_state = S1;
            end
            else if (~p && ~rst) begin
                t = 0;
                next_state = S2;
            end
           end
       S1:
           begin    
            if (~p && u && rst) begin
              maxtime = 0;      
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S3;
            end
            else if (~p && ~u && rst) begin
              maxtime = 0;      
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S7;
            end
            else if (~p && ~u && ~rst) begin      // note to self: this state logic may require some reconfiguration depending on how the debouncers are used - presumably we would want a switch for program mode so that our signal stays high
                next_state = S7;
                t = maxtime;
            end
            else if (~p && u && ~rst) begin
                next_state = S3;
                t = maxtime;
            end
            else if (p && inc && min && ~rst) begin
                next_state = S15;
                t = maxtime;
            end
            else if (p && inc && min && rst) begin
                next_state = S15;
                maxtime = 0;      
                u_count = 0;      
                d_count = 0;     
                fix_d_count = 0;
                t = 0;
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
          if (p && ~rst) begin
            next_state = S1;
          end
          else if (p && rst) begin
            next_state = S1;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t=0;
          end
          else if (~p && u && rst) begin
           next_state = S3;
           maxtime = 0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
          end
          else if (~p && ~u && rst) begin
           next_state = S11;
           maxtime = 0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
          end
          else if (~p && ~u && ~rst) begin
            next_state = S11;
          end
          else if (~p && u && ~rst) begin
            next_state = S3;
          end
        end
       S3:
        begin
         if (p && ~rst) begin
          next_state = S1;
          t = 0;
         end
         else if (p && rst) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && rst) begin
          next_state = S2;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && ~rst) begin
          next_state = S2;
          t = 0;
         end
         else if (~p && u && s && rst) begin
          next_state = S4;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end 
         else if (~p && u && s && ~rst) begin
          next_state = S4;
          t = 0;
         end
         else if (~p && u && ~s && ~rst) begin
           next_state = S3;
           t = 0;
         end
         else if (~p && u && ~s && rst) begin
           next_state = S3;
           maxtime = 0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
         end
        end
       S4:
        begin
         if (p && ~rst) begin
          next_state = S1;
          t = u_count;
         end
         else if (p && rst) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && ~rst) begin
          next_state = S0;
          t = u_count;
         end
         else if (~p && ~u && rst) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && u && ~rst && ~s) begin
          next_state = S5;
          t = u_count;
         end             
         else if (~p && u && rst) begin
          next_state = S3;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && u && ~rst && s) begin
          next_state = S6;
          t = u_count;   
         end
        end
       S5:
        begin
          if (p && ~rst) begin
            next_state = S1;
            u_count = u_count + 39'b000000000000000000000000000000000000010;
          end
          else if (p && rst) begin
            next_state = S1;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = 0;
          end
          else if (~p && ~u && ~rst) begin
            next_state = S0;
            u_count = u_count + 39'b000000000000000000000000000000000000010;
          end
          else if (~p && ~u && rst) begin
            next_state = S0;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = 0;
          end
          else if (~p && u && rst) begin
            next_state = S3;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = 0;
          end
          else if (~p && u && ~rst && s) begin
            next_state = S6;
            u_count = u_count + 39'b000000000000000000000000000000000000010;
          end 
          else if (~p && u && ~rst && ~s) begin
          next_state = S4;
          u_count = u_count + 39'b000000000000000000000000000000000000010;
          end
        end
       S6:
        begin 
         if (p && ~rst) begin
          next_state = S1;
         end
         else if (p && rst) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && ~rst) begin
          next_state = S0;
         end 
         else if (~p && ~u && rst) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && u && rst) begin
            next_state = S3;
           maxtime = 0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
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
         if (p && ~rst) begin
          next_state = S1;
          t = maxtime;
         end
         else if (p && rst) begin
          next_state = S1;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = maxtime;
         end
         else if (~p && u && ~rst) begin
          next_state = S0;
          t = maxtime;
         end
         else if (~p && u && rst) begin
          next_state = S0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = maxtime;
         end
         else if (~p && ~u && ~s && ~rst) begin
          next_state = S7;
          t = maxtime;
         end
         else if (~p && ~u && ~s && rst) begin
          next_state = S7;     
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = maxtime;
         end
         else if (~p && ~u && s && ~rst) begin
           next_state = S8;
           t = maxtime;
         end
         else if (~p && ~u && s && rst) begin
           next_state = S8;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
         end
        end
       S8:
        begin
          if (p && ~rst) begin
           next_state = S1;
           t = d_count;
          end
          else if (p && rst) begin
           next_state = S1;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
          end
          else if (~p && u && ~rst) begin
            next_state = S0;
            t = d_count;
          end
          else if (~p && u && rst) begin
            next_state = S0;     
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
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
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
        end
       S9:
         begin
          if (p && ~rst) begin
           next_state = S1;
           d_count = d_count - 39'b000000000000000000000000000000000000010;
          end 
          if (p && rst) begin
           next_state = S1;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
          end
          else if (~p && u && ~rst) begin
           next_state = S0;
           d_count = d_count - 39'b000000000000000000000000000000000000010;
          end
          else if (~p && u && rst) begin
           next_state = S0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
          end
          else if (~p && ~u && rst) begin
           next_state = S7;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
          end
          else if (~p && ~u && ~rst && s) begin
           next_state = S10;
           d_count = d_count - 39'b000000000000000000000000000000000000010;
          end
          else if (~p && ~u && ~rst && ~s) begin
           next_state = S8;
           d_count = d_count - 39'b000000000000000000000000000000000000010;
          end
         end       
       S10:
         begin
          if (p && ~rst) begin
            next_state = S1;
          end 
          if (p && rst) begin
            next_state = S1;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
          else if (~p && u && ~rst) begin
            next_state = S0;
          end
          else if (~p && u && rst) begin
            next_state = S0;     
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
          else if (~p && ~u && ~rst && ~s) begin
            next_state = S10;
          end
          else if (~p && ~u && ~rst && s) begin
            next_state = S8;
          end
          else if (~p && ~u && rst) begin
            next_state = S7;     
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
         end
       S11:
        begin
         if (p && ~rst) begin
            next_state = S1;
            t = HCT;
         end
         if (p && rst) begin
            next_state = S1;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = HCT;
         end
         else if (~p && u && ~rst) begin   
          next_state = S0;
          t = HCT;
         end
         else if (~p && u && rst) begin   
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && ~s) begin
          next_state = S11;
          t = HCT;
         end
         else if (~p && ~u && rst && ~s) begin
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && s) begin
          next_state = S12;
          t = HCT;
         end
         else if (~p && ~u && rst && s) begin
          next_state = S12;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
        end
       S12:
        begin
         if (p && ~rst) begin
          next_state = S1;
          t = HCT - fix_d_count;
         end
         if (p && rst) begin
          next_state = S1;
          t = HCT;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end 
         else if (~p && u && ~rst) begin
          next_state = S0;
          t = HCT - fix_d_count;
         end
         else if (~p && u && rst) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && s) begin
          next_state = S14;
          t = HCT - fix_d_count;
         end
         else if (~p && ~u && rst) begin
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && ~s) begin
          next_state = S13;
          t = HCT - fix_d_count;
         end
        end
       S13:
        begin
         if (p && ~rst) begin
          next_state = S1;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
         if (p && rst) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && u && ~rst) begin
          next_state = S0;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
         else if (~p && u && rst) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && rst) begin
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && s) begin
          next_state = S14;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
         else if (~p && ~u && ~rst && ~s) begin
          next_state = S12;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
        end
       S14: 
        begin
         if (p && ~rst) begin
          next_state = S1;
         end
         if (p && rst) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
          t = 0;
         end
         else if (~p && u && ~rst) begin
          next_state = S0;
         end
         else if (~p && u && rst) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && rst) begin
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
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
         if (rst && p) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (rst && ~p) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~rst && p) begin
          next_state = S1;
          maxtime = maxtime + 39'b000000000000000000000001110101001100000;
         end
         else if (~rst && ~p) begin
          next_state = S0;
          maxtime = maxtime + 39'b000000000000000000000001110101001100000;
         end
        end
       S16:
        begin
         if (rst && p) begin
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (rst && ~p) begin
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~rst && p) begin
          next_state = S1;
          maxtime = maxtime + 22'b0000000000001111101000; 
         end
         else if (~rst && ~p) begin
          next_state = S0;
          maxtime = maxtime + 22'b0000000000001111101000; 
         end
        end
       endcase
       present_state = next_state;
       if (t == 0) begin
        zero = 1;
       end
       else begin
        zero = 0;
       end
    end   
    
//    programmer program_clock(.clk(clk), .minute(minute), .button(increment), .maxtime(u_tlim));
    
//    clock_divider millisecondclock(.clk_in(clk), .clk_out(ms_clk));
        
endmodule
