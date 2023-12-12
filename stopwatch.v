`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Cole Shaigec, Alex Melnick, Henry Bega, Macy Bryer-Charette
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
    reg [18:0] present_state, next_state;   // used in the finite state machine in this module
    
    // parameter declarations for FSM states
    // 17 states, using one hot encoding
    
    parameter S0 = 19'b0000000000000000001;
    parameter S1 = 19'b0000000000000000010;
    parameter S2 = 19'b0000000000000000100;
    parameter S3 = 19'b0000000000000001000;
    parameter S4 = 19'b0000000000000010000;
    parameter S5 = 19'b0000000000000100000;
    parameter S6 = 19'b0000000000001000000;
    parameter S7 = 19'b0000000000010000000;
    parameter S8 = 19'b0000000000100000000;
    parameter S9 = 19'b0000000001000000000;
    parameter S10 = 19'b0000000010000000000;
    parameter S11 = 19'b0000000100000000000;
    parameter S12 = 19'b0000001000000000000;
    parameter S13 = 19'b0000010000000000000;
    parameter S14 = 19'b0000100000000000000;
    parameter S15 = 19'b0001000000000000000;
    parameter S16 = 19'b0010000000000000000;
    parameter S17 = 19'b0100000000000000000;
    parameter S18 = 19'b1000000000000000000;
    
    // initialize FSM
    
    initial begin
        present_state = S0;                                          // machine will stay in start state for one clock cycle
        next_state = S0;                                             // machine will stay in start state for one clock cycle
        HCT = 39'b000000101100101101000001011110000000000;           // hard coded time initially set at one minute
//        HCT = 4;
        maxtime = 0;                                                 // initialize all count registers at zero
        u_count = 0;                                                 // initialize all count registers at zero
        d_count = 0;                                                 // initialize all count registers at zero
        fix_d_count = 0;                                             // initialize all count registers at zero
        zero = 0;
    end
        
    // implement finite state machine
    
    // NOTE TO SELF: CHECK S5 AND S9; IT MAY BE NECESSARY TO ADJUST THE INCREMENTS DEPENDING ON HOW THE CLOCK IS STRUCTURED
    
    // NOTE TO SELF: THE ARITHMETIC IN S12 HARDLY INSPIRES CONFIDENCE AND COULD BE A SOURCE OF ERROR - KEEP AN EYE ON IT!
     
     // NOTE TO SELF: STATES S15 AND S16 REQUIRE ATTENTION TO ENSURE CORRECT INCREMENTING
     
    always @(posedge clk) begin
        if (zero == 1) begin
         zero = 0;
        end
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
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S3;
            end
            else if (~p && ~u && rst) begin     
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
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t=0;
          end
          else if (~p && u && rst) begin
           next_state = S3;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
          end
          else if (~p && ~u && rst) begin
           next_state = S11;     
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
           if (t == 0) begin
            next_state = S17; 
           end  
           else begin
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
        if (t == 0) begin
            next_state = S18;
            t = 0;
        end
        else begin
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
          maxtime = maxtime + 39'b000000101100101101000001011110000000000;
         end
         else if (~rst && ~p) begin
          next_state = S0;
          maxtime = maxtime + 39'b000000101100101101000001011110000000000;
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
          maxtime = maxtime + 39'b000000000000101111101011110000100000000; 
         end
         else if (~rst && ~p) begin
          next_state = S0;
          maxtime = maxtime + 39'b000000000000101111101011110000100000000; 
         end
        end
       S17:
        begin
         if (rst && p) begin
          t = 0;
          next_state = S1;
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          zero = 1;
         end
         else if (~rst && p) begin
          t = 0;
          next_state = S1;
          zero = 1;
         end
        else if (~p && u && rst) begin
          t = 0;
          zero = 1;
          next_state = S0;
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
        end
        else if (~p && u && ~rst) begin
         t = 0;
         zero = 1;
         next_state = S17;
        end
       else if (~p && ~u && ~rst) begin
         t = 0;
         zero = 1;
         next_state = S17;
       end
       else if (~p && ~u && rst) begin
         t = 0;
         zero = 1;
         next_state = S7;
         u_count = 0;      
         d_count = 0;     
         fix_d_count = 0;
       end   
       end
       
       S18:
        begin
         if (p && ~rst) begin
            t = 0;
            zero = 1;
            next_state = S1;
        end
        else if (p && rst) begin
            t = 0;
            zero = 1;
            next_state = S1;
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
        end
        else if (~p && u && ~rst) begin
            next_state = S0;
            t = 0;
            zero = 1;
        end
        else if (~p && u && rst) begin
            t = 0;
            zero = 1;
            next_state = S0;
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
        end
        else if (~p && ~u && ~rst) begin
            t = 0;
            zero = 1;
            next_state = S18;
        end
        else if (~p && ~u && rst) begin
            t = 0;
            zero = 1;
            next_state = S11;
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
        end
        end
       endcase
       present_state = next_state;
       
    end   
        
endmodule
