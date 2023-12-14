`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Cole Shaigec
// 
// Create Date: 12/06/2023 04:33:05 PM
// Design Name: 
// Module Name: stopwatch
// Project Name: ENG EC 311 Introduction to Digital Logic Design Final Project
// Target Devices: NEXYS A7-100t with XILINX ARTIX-7 FPGA 
// Tool Versions: Vivado 2019.1
// Description: This module serves as a programmable stopwatch with count up and count down modes triggered by user inputs
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
    input clk,                  // CLOCK: stopwatch is connected to 100MHz (10ns period) system clock on Artix-7 FPGA
    input u,                    // UP: if 1, the stopwatch counts up; if 0, the stopwatch counts down
    input rst,                  // RESET: resets the time during stopwatch operation
    input inc,                  // INCREMENT: used in the programming mode to increase the maxtime
    input min,                  // MINUTE: used in the programming mode
    output reg [38:0] t,        // TIME: this is the main output of the module
    output reg zero             // ZERO: if the countdown mode is active and the time runs out, this signal goes to sound module to tell it to beep
    );
    
    // s, rst, and inc are buttons
    // p, u, and min are switches
    
    // stopwatch time count increments every clock cycle (10ns)

    // register declarations
    // time count is 39 bits in size - maximum time that can be processed by this design is 59 minutes and 59 seconds
    
    reg [38:0] HCT;                         // Hard Coded Time - if the user doesn't program a time, this holds a preset countdown time for that mode
    reg [38:0] maxtime;                     // captures the time programmed by the user; configured to allow up to 59 minutes 59 seconds
    reg [38:0] u_count;                     // register used to hold time elapsed in count-up mode
    reg [38:0] d_count;                     // register used to hold time elapsed in count-down mode
    reg [38:0] fix_d_count;                 // register used to hold time elapsed in hard coded time count-down mode
    reg [18:0] present_state, next_state;   // these store the states for the stopwatch finite state machine
    
    // parameter declarations for FSM states
    // 19 states, using one hot encoding
    
    parameter S0 = 19'b0000000000000000001;     // START state
    parameter S1 = 19'b0000000000000000010;     // PROGRAM state
    parameter S2 = 19'b0000000000000000100;     // TRANSITION BUFFER state
    parameter S3 = 19'b0000000000000001000;     // COUNT UP START state
    parameter S4 = 19'b0000000000000010000;     // ACTIVE COUNT UP state
    parameter S5 = 19'b0000000000000100000;     // COUNT UP INCREMENT state
    parameter S6 = 19'b0000000000001000000;     // COUNT UP PAUSED state
    parameter S7 = 19'b0000000000010000000;     // PROGRAMMED COUNT DOWN START state
    parameter S8 = 19'b0000000000100000000;     // PROGRAMMED ACTIVE COUNT DOWN state
    parameter S9 = 19'b0000000001000000000;     // PROGRAMMED COUNT DOWN DECREMENT state
    parameter S10 = 19'b0000000010000000000;    // PROGRAMMED COUNT DOWN PAUSED state
    parameter S11 = 19'b0000000100000000000;    // HARD CODED COUNT DOWN START state
    parameter S12 = 19'b0000001000000000000;    // HARD CODED ACTIVE COUNT DOWN state
    parameter S13 = 19'b0000010000000000000;    // HARD CODED COUNT DOWN DECREMENT state
    parameter S14 = 19'b0000100000000000000;    // HARD CODED COUNT DOWN PAUSED state
    parameter S15 = 19'b0001000000000000000;    // PROGRAM ADD MINUTES state
    parameter S16 = 19'b0010000000000000000;    // PROGRAM ADD SECONDS state
    parameter S17 = 19'b0100000000000000000;    // PROGRAMMED COUNT DOWN ZERO state
    parameter S18 = 19'b1000000000000000000;    // HARD CODED COUNT DOWN ZERO state
    
    // initialize stopwatch state machine
    
    initial begin
        present_state = S0;                                          // machine will stay in start state for one clock cycle
        next_state = S0;                                             // machine will stay in start state for one clock cycle
        HCT = 39'b000000101100101101000001011110000000000;           // hard coded time initially set at one minute
        maxtime = 0;                                                 // initialize all count registers at zero
        u_count = 0;                                                 // initialize all count registers at zero
        d_count = 0;                                                 // initialize all count registers at zero
        fix_d_count = 0;                                             // initialize all count registers at zero
        zero = 0;
    end
     
     // Always block below implements stopwatch as hybrid Moore-Mealy machine
     // All state transitions are synchronous and occur on positive clock edge
     // However, many outputs are a function of the inputs, and the outputs can change asynchronously  
     
    always @(posedge clk) begin
        if (zero == 1) begin        // this block sets the ZERO output signal -- when the countdown time signal reaches zero, this signal goes high
         zero = 0;
        end
        case(present_state)
        S0:      // START state ==> all count registers and outputs are zero
           begin
            if (p && rst) begin     // if PROGRAM and RESET are high, all count registers are set to zero and the machine transitions to the program state S1
              maxtime = 0;      
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S1;
            end
            if (~p && rst) begin    // if PROGRAM is low and RESET is high, all count registers are set to zero and the machine returns to the START state
              maxtime = 0;      
              u_count = 0;      
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S0;
            end
            if (p && ~rst) begin    // if PROGRAM is high and RESET is low, the machine transitions to the PROGRAM state S1
                t = 0;
                next_state = S1;
            end
            else if (~p && ~rst) begin  // if PROGRAM and RESET are both low, the machine transitions into RUN mode through state S2
                t = 0;
                next_state = S2;
            end
           end
       S1:     // PROGRAM state ==> this is the starting state for programming the machine
           begin    
            if (~p && u && rst) begin    // if PROGRAM is zero and UP is high, the machine exits the PROGRAM state and transitions to the starting COUNT UP state 
              u_count = 0;              // RESET signal sets output and all count registers to zero
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S3;
            end
            else if (~p && ~u && rst) begin   // if PROGRAM and UP are low and RESET is high, the machine transitions into the starting COUNT DOWN (PROGRAMMED) state  
              u_count = 0;                    // RESET signal sets output and all count registers to zero 
              d_count = 0;     
              fix_d_count = 0;
              t = 0;
              next_state = S7;
            end
            else if (~p && ~u && ~rst) begin      // if PROGRAM, UP, and RESET are low, the machine transitions into the starting COUNT DOWN (PROGRAMMED) state
                next_state = S7;
                t = maxtime;
            end
            else if (~p && u && ~rst) begin       // if PROGRAM and RESET are low and UP is high, the machine transitions into the starting COUNT UP state
                next_state = S3;
                t = maxtime;
            end
            else if (p && inc && min && ~rst) begin     // if PROGRAM and INCREMENT and MINUTE are high, the machine transitions to increment the time by one minute (see S15)
                next_state = S15;
                t = maxtime;
            end
            else if (p && inc && min && rst) begin      // same as above but with reset zeroing count registers
                next_state = S15;     
                u_count = 0;      
                d_count = 0;     
                fix_d_count = 0;
                t = 0;
            end
            else if (p && inc && ~min) begin      // if PROGRAM and INCREMENT are high and MINUTE is low, machine transitions to increment the time by one second (see S16) 
                next_state = S16;
                t = maxtime;
            end
            else if (p && ~inc) begin       // if PROGRAM is high and INCREMENT is low, the machine sits idle in the PROGRAM state
                next_state = S1;
                t = maxtime;
            end
           end 
       S2:      // TRANSITION BUFFER STATE ==> this is a redundant buffer state. It was not removed owing to time constraints.
        begin
          if (p && ~rst) begin      // if the PROGRAM signal is high and RESET is low, the machine transitions to the PROGRAM state leaving output unchanged.
            next_state = S1;
          end
          else if (p && rst) begin  // if PROGRAM and RESET are both high, the machine transitions to the PROGRAM state and zeros all count registers
            next_state = S1;    
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t=0;
          end
          else if (~p && u && rst) begin    // if PROGRAM is low and RESET and UP are high, the machine transitions to the starting COUNT UP state and zeros all registers
           next_state = S3;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
          end
          else if (~p && ~u && rst) begin // if PROGRAM and UP are low and RESET is high, the machine transitions to the starting COUNT DOWN (HARD CODED TIME) state and zeros all registers
           next_state = S11;     
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
          end
          else if (~p && ~u && ~rst) begin   // if PROGRAM and UP and RESET are all low, the machine transitions to the starting COUNT DOWN (HARD CODED TIME) state
            next_state = S11;
          end
          else if (~p && u && ~rst) begin   // if PROGRAM and RESET are low and UP is high, machine transitions to starting COUNT UP state
            next_state = S3;
          end
        end
       S3:      // COUNT UP START state ==> in COUNT UP mode, machine sits idle here until it the STARTSTOP signal goes high
        begin
         if (p && ~rst) begin  // if PROGRAM is high and RESET is low, machine transitions to PROGRAM state S1
          next_state = S1;
          t = 0;
         end
         else if (p && rst) begin   // same as above but registers are zeroed
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && rst) begin  // if PROGRAM and UP are low and RESET is high, machine transitions back to S2 and then subsequently to a COUNT DOWN state
          next_state = S2;                // RESET signal zeros registers
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && ~rst) begin   // same as above but with RESET signal low
          next_state = S2;
          t = 0;
         end
         else if (~p && u && s && rst) begin    // if PROGRAM is low and STARTSTOP, UP, and RESET are high, all registers are zeroed and machine transitions to ACTIVE COUNT UP state
          next_state = S4;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end 
         else if (~p && u && s && ~rst) begin   // same as above but with RESET signal low
          next_state = S4;
          t = 0;
         end
         else if (~p && u && ~s && ~rst) begin  // if PROGRAM and STARTSTOP and RESET are low and UP is high, the machine sits in the idle COUNT UP state waiting for a start input
           next_state = S3;
           t = 0;
         end
         else if (~p && u && ~s && rst) begin // same as above but with RESET signal to zero registers
           next_state = S3;
           maxtime = 0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
         end
        end
       S4:  // ACTIVE COUNT UP state ==> machine is running in count-up mode in this state
        begin
         if (p && ~rst) begin   // if PROGRAM and not RESET, the machine transitions to the PROGRAM state
          next_state = S1;  
          t = u_count;
         end
         else if (p && rst) begin // if PROGRAM and RESET, the machine transitions to the PROGRAM state and zeros all registers
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && ~rst) begin   // if PROGRAM, RESET, and UP are all low, machine transitions back to START state and then to COUNT DOWN mode
          next_state = S0;
          t = u_count;
         end
         else if (~p && ~u && rst) begin    // same as above but high RESET signal sets registers to zero
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && u && ~rst && ~s) begin  // if all signals except UP are low, machine transitions to INCREMENT state
          next_state = S5;
          t = u_count;
         end             
         else if (~p && u && rst) begin // if PROGRAM is low and UP and RESET are high, machine transitions back to COUNT UP start state
          next_state = S3;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && u && ~rst && s) begin // if PROGRAM and RESET are low, UP is high, and STARTSTOP goes low, the machine transitions to the COUNT UP PAUSED state
          next_state = S6;
          t = u_count;   
         end
        end
       S5:  // COUNT UP INCREMENT state ==> the elapsed time count in COUNT UP mode is incremented each time the machine reaches this state
        begin
          if (p && ~rst) begin  //if PROGRAM is high and RESET is low, the machine transitions to the PROGRAM state. The COUNT UP elapsed time is incremented in this state unless RESET is high
            next_state = S1;
            u_count = u_count + 39'b000000000000000000000000000000000000010;    // the count is incremented by TWO because the increment state is only reached every second clock cycle while the machine is active
          end
          else if (p && rst) begin  // same as above but high RESET signal zeroes count registers
            next_state = S1;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = 0;
          end
          else if (~p && ~u && ~rst) begin  // if UP goes low, the machine returns to the START state
            next_state = S0;
            u_count = u_count + 39'b000000000000000000000000000000000000010;    // the elapsed time count is incremented by two
          end
          else if (~p && ~u && rst) begin   // same as above but all registers (including elapsed time count) are zeroed
            next_state = S0;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = 0;
          end
          else if (~p && u && rst) begin    // if PROGRAM is low and UP and RESET are high, the machine transitions back to the COUNT UP START state. RESET zeros registers
            next_state = S3;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = 0;
          end
          else if (~p && u && ~rst && s) begin  // high STARTSTOP signal sends stopwatch to COUNT UP PAUSED state. Elapsed time still incremented
            next_state = S6;
            u_count = u_count + 39'b000000000000000000000000000000000000010;
          end 
          else if (~p && u && ~rst && ~s) begin // same as above but STARTSTOP signal is low so machine returns to ACTIVE COUNT UP state
          next_state = S4;
          u_count = u_count + 39'b000000000000000000000000000000000000010;
          end
        end
       S6:  // COUNT UP PAUSED state ==> machine stores elapsed time count, returns constant output, and sits idle in anticipation of STARTSTOP signal to resume operation or other signal to transition to the starting state for a different mode
        begin 
         if (p && ~rst) begin // high PROGRAM signal sends machine to PROGRAM state
          next_state = S1;
         end
         else if (p && rst) begin   // same as above but high RESET signal zeros registers
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && ~u && ~rst) begin   // low UP signal sends machine to START state
          next_state = S0;
         end 
         else if (~p && ~u && rst) begin    // same as above but high RESET signal zeros registers
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~p && u && rst) begin // PROGRAM low and UP and RESET high. Sends machine to COUNT UP START state and zeros all registers
            next_state = S3;
           maxtime = 0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = 0;
         end
         else if (~p && u && ~rst && ~s) begin // PROGRAM low, UP high, and RESET and STARTSTOP low. Machine remains in idle state awaiting a different signal 
          next_state = S6;
         end
         else if (~p && u && ~rst && s) begin   // high STARTSTOP signal sends machine back to ACTIVE COUNT UP state
          next_state = S4;
         end
        end
       S7:      // PROGRAMMED COUNT DOWN START state ==> the machine sits in this state after being programmed in COUNT DOWN mode and waits for input signal
        begin
         if (p && ~rst) begin // high PROGRAM signal sends machine back to PROGRAM state
          next_state = S1;
          t = maxtime;
         end
         else if (p && rst) begin   // same as above but RESET signal zeros registers
          next_state = S1;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = maxtime;
         end
         else if (~p && u && ~rst) begin    // high UP signal sends machine to START state and then on to COUNT UP mode
          next_state = S0;
          t = maxtime;
         end
         else if (~p && u && rst) begin // same as aboive but RESET zeros registers
          next_state = S0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = maxtime;
         end
         else if (~p && ~u && ~s && ~rst) begin // all input signals low; machine remains in idle state and waits for input signal
          next_state = S7;
          t = maxtime;
         end
         else if (~p && ~u && ~s && rst) begin  // same as above but RESET zeros registers
          next_state = S7;     
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = maxtime;
         end
         else if (~p && ~u && s && ~rst) begin  // high STARTSTOP signal with all others low sends machine to PROGRAMMED ACTIVE COUNT DOWN state
           next_state = S8;
           t = maxtime;
         end
         else if (~p && ~u && s && rst) begin   // same as above but high RESET signal sends machine to PROGRAMMED ACTIVE COUNT DOWN state
           next_state = S8;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
         end
        end
       S8: // PROGRAMMED ACTIVE COUNT DOWN state ==> in this state, the machine actively counts down from the programmed time
        begin
           if (t == 0) begin    // if the countdown is complete and the output time reaches zero, the machine transitions to the PROGRAMMED COUNT DOWN ZERO state
            next_state = S17; 
           end  
           else begin
              if (p && ~rst) begin  // high PROGRAM signal sends machine to PROGRAM state
               next_state = S1;
               t = maxtime;
              end
              else if (p && rst) begin  // same as above but high RESET signal zeros registers
               next_state = S1;      
               u_count = 0;      
               d_count = 0;     
               fix_d_count = 0;
               t = maxtime;
              end
              else if (~p && u && ~rst) begin   // high UP signal and low PROGRAM signal send machine to START state and then to COUNT UP
                next_state = S0;
                t = d_count;
              end
              else if (~p && u && rst) begin   // same as above but high RESET signal zeros registers
                next_state = S0;     
                u_count = 0;      
                d_count = 0;     
                fix_d_count = 0;
                t = maxtime;
              end
              else if (~p && ~u && ~rst && ~s) begin    // all input signals low -- machine transitions to PROGRAMMED COUNT DOWN DECREMENT state
                next_state = S9;
                t = d_count;
              end
              else if (~p && ~u && ~rst && s) begin // high STARTSTOP signal causes machine to transition to PROGRAMMED COUNT DOWN PAUSED state
                next_state = S10;
                t = d_count;
              end
              else if (~p && ~u && rst) begin   // high RESET signal causes machine to transition to PROGRAMMED COUNT DOWN START state and zeros registers and outputs
                next_state = S7;      
                u_count = 0;      
                d_count = 0;     
                fix_d_count = 0;
                t = maxtime;
              end
           end
        end
       S9:      // PROGRAMMED COUNT DOWN DECREMENT state
         begin
          if (p && ~rst) begin  // high PROGRAM signal causes machine to transition to PROGRAM state
           next_state = S1;
           d_count = d_count + 39'b000000000000000000000000000000000000010;  // elapsed time count incremented by two
          end 
          if (p && rst) begin   // high RESET signal zeros registers and PROGRAM signal causes machine to transition to PROGRAM state
           next_state = S1;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;
          end
          else if (~p && u && ~rst) begin   // high UP signal causes machine to transition back to START state and then to COUNT UP mode
           next_state = S0;
           d_count = d_count + 39'b000000000000000000000000000000000000010;
          end
          else if (~p && u && rst) begin    // same as above but RESET zeros registers
           next_state = S0;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;     // RESET signal resets time back to programmed countdown time
          end
          else if (~p && ~u && rst) begin   // RESET signal sends machine back to PROGRAMMED COUNT DOWN START state
           next_state = S7;      
           u_count = 0;      
           d_count = 0;     
           fix_d_count = 0;
           t = maxtime;     // RESET signal resets time back to programmed countdown time
          end
          else if (~p && ~u && ~rst && s) begin     // high STARTSTOP signal with all other signals low causes machine to transition to PROGRAMMED COUNT DOWN PAUSED state
           next_state = S10;
           d_count = d_count + 39'b000000000000000000000000000000000000010;
          end
          else if (~p && ~u && ~rst && ~s) begin    // all signals low; machine transitions back to PROGRAMMED ACTIVE COUNT DOWN 
           next_state = S8;
           d_count = d_count + 39'b000000000000000000000000000000000000010;
          end
         end       
       S10:     // PROGRAMMED COUNT DOWN PAUSED state ==> machine stores elapsed time count, returns constant output, and sits idle in anticipation of STARTSTOP signal to resume operation or other signal to transition to the starting state for a different mode
         begin
          if (p && ~rst) begin   // high PROGRAM signal sends machine to PROGRAM state
            next_state = S1;
          end 
          if (p && rst) begin   // same as above but RESET signal zeroes registers
            next_state = S1;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
          else if (~p && u && ~rst) begin   // UP signal high and other signals low -- machine transitions to START state and then to COUNT UP mode
            next_state = S0;
          end
          else if (~p && u && rst) begin    // same as above but RESET signal zeros registers
            next_state = S0;     
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
          else if (~p && ~u && ~rst && ~s) begin    // all signals low -- machine remains in PAUSED state awaiting a high input signal
            next_state = S10;
          end
          else if (~p && ~u && ~rst && s) begin     // high STARTSTOP signal with all others low causes machine to resume operation; it transitions back to PROGRAMMED ACTIVE COUNT DOWN state
            next_state = S8;
          end
          else if (~p && ~u && rst) begin   // high RESET signal sends machine back to PROGRAMMED COUNT DOWN START state and zeros all registers
            next_state = S7;     
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = maxtime;
          end
         end
       S11:     // HARD CODED COUNT DOWN START state ==> if the machine has not been programmed and is directed to COUNT DOWN mode, it transitions to this state and awaits an input signal
        begin
         if (p && ~rst) begin   // PROGRAM signal sends machine  to PROGRAM state
            next_state = S1;
            t = HCT;
         end
         if (p && rst) begin    // same as above but RESET signal zeros registers
            next_state = S1;
            maxtime = 0;      
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
            t = HCT;
         end
         else if (~p && u && ~rst) begin   // high UP signal sends machine back to START state and then to COUNT UP mode
          next_state = S0;
          t = HCT;
         end
         else if (~p && u && rst) begin   // same as above but RESET signal zeros all registers
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && ~s) begin // all signals low; machine does not transition to another state and output does not change
          next_state = S11;
          t = HCT;
         end
         else if (~p && ~u && rst && ~s) begin  // machine does not transition but all registers zeroed by RESET signal
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && s) begin   // high STARTSTOP signal with all others low sends machine to HARD CODED ACTIVE COUNT DOWN state
          next_state = S12;
          t = HCT;
         end
         else if (~p && ~u && rst && s) begin  // same as above but high RESET signal zeros registers
          next_state = S12;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
        end
       S12:     // HARD CODED ACTIVE COUNT DOWN STATE ==> in this state, the machine actively counts down from the programmed time
       begin
        if (t == 0) begin   // if countdown is completed (i.e., the machine has counted for the entire hard coded time and the countdown time reaches zero), this sends the machine to the HARD CODED COUNT DOWN ZERO state
            next_state = S18;
            t = 0;
        end
        else begin
         if (p && ~rst) begin   // high PROGRAM signal sends machine to PROGRAM state
          next_state = S1;
          t = HCT - fix_d_count;    // subtract the elapsed time from the hard coded time to compute remaining countdown time
         end
         if (p && rst) begin    // same as above but high RESET signal zeros registers
          next_state = S1;
          t = HCT;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end 
         else if (~p && u && ~rst) begin    // high UP signal with others low causes machine to transition to START state and then to COUNT UP mode
          next_state = S0;
          t = HCT - fix_d_count;
         end
         else if (~p && u && rst) begin // same as above but high RESET signal zeros registers
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && s) begin  // high STARTSTOP signal with others low; machine transitions to HARD CODED COUNT DOWN PAUSED state
          next_state = S14;
          t = HCT - fix_d_count;    
         end
         else if (~p && ~u && rst) begin    // high RESET signal sends machine to HARD CODED COUNT DOWN START state and zeros registers
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && ~s) begin // all signals low -- machine transitions to HARD CODED COUNT DOWN DECREMENT state
          next_state = S13;
          t = HCT - fix_d_count;
         end
        end
       end
       S13: // HARD CODED COUNT DOWN DECREMENT STATE
        begin
         if (p && ~rst) begin   // high PROGRAM signal sends machine back to PROGRAM state; elapsed time register increments by 2
          next_state = S1;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
         if (p && rst) begin    // same as above except high RESET signal zeros all registers
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && u && ~rst) begin    // high UP signal with others low causes machine to transition back to START state and then to COUNT DOWN mode
          next_state = S0;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
         else if (~p && u && rst) begin     // same as above except high RESET signal zeros all registers
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && rst) begin    // high RESET signal with others low sends machine back to HARD CODED COUNT DOWN START state; all registers zeroed
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && s) begin  // high STARTSTOP signal with others low; machine transitions to HARD CODED COUNT DOWN PAUSED state
          next_state = S14;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
         else if (~p && ~u && ~rst && ~s) begin // all signals low; machine transitions back to HARD CODED ACTIVE COUNT DOWN state
          next_state = S12;
          fix_d_count = fix_d_count + 39'b000000000000000000000000000000000000010;
         end
        end
       S14: // HARD CODED COUNT DOWN PAUSED state ==> machine stores elapsed time count, returns constant output, and sits idle in anticipation of STARTSTOP signal to resume operation or other signal to transition to the starting state for a different mode
        begin
         if (p && ~rst) begin   // high PROGRAM signal sends machine to PROGRAM state
          next_state = S1;
         end
         if (p && rst) begin    // same as above but high RESET signal zeros all registers
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
          t = 0;
         end
         else if (~p && u && ~rst) begin    // high UP signal with others low sends machine to START state and then to COUNT UP mode
          next_state = S0;
         end
         else if (~p && u && rst) begin // same as above except high RESET signal zeros all registers
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && rst) begin    // high RESET signal with others low sends machne back to HARD CODED COUNT DOWN START state
          next_state = S11;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = HCT;
         end
         else if (~p && ~u && ~rst && ~s) begin // all signals low; machine does not transition to a different state
          next_state = S14;
         end
         else if (~p && ~u && ~rst && s) begin  // high STARTSTOP signal with others low; machine transitions to HARD CODED ACTIVE COUNT DOWN state
          next_state = S12;
         end
        end
       S15:     // PROGRAM ADD MINUTES state ==> the machine arrives at this state after receiving a high INCREMENT signal while in PROGRAM mode, and the action of this mode is to increment the MAXTIME count by 1 minute
        begin
         if (rst && p) begin    // high PROGRAM signal keeps machine in PROGRAM mode; high RESET signal zeros all registers
          next_state = S1;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (rst && ~p) begin  // high RESET signal zeros all registers; low PROGRAM signal causes machine to transition back to START state
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~rst && p) begin  // high PROGRAM signal keeps machine in PROGRAM mode; machine returns to base PROGRAM state on next clock cycle
          next_state = S1;
          maxtime = maxtime + 39'b000000101100101101000001011110000000000;  // MAXTIME incremented by 1 minute / 10 nanoseconds  = 6 000 000 000
         end
         else if (~rst && ~p) begin   // low PROGRAM signal sends machine back to START state
          next_state = S0;
          maxtime = maxtime + 39'b000000101100101101000001011110000000000; // MAXTIME incremented by 1 minute / 10 nanoseconds  = 6 000 000 000
         end
        end
       S16:     // PROGRAM ADD SECONDS state ==> the machine arrives at this state after receiving a high INCREMENT signal while in PROGRAM mode, and the action of this mode is to increment the MAXTIME count by 1 minute
        begin
         if (rst && p) begin   // high PROGRAM signal keeps the machine in PROGRAM mode; it transitions back to the PROGRAM state on the next positive clock edge
          next_state = S1;
          maxtime = 0;      // high RESET signal zeros all registers
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (rst && ~p) begin  // high RESET signal zeros all registers; low PROGRAM signal causes machine to transition back to START state
          next_state = S0;
          maxtime = 0;      
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          t = 0;
         end
         else if (~rst && p) begin  // high PROGRAM signal keeps machine in PROGRAM mode
          next_state = S1;
          maxtime = maxtime + 39'b000000000000101111101011110000100000000;  // MAXTIME incremented by 1 second / 10 nanoseconds = 1 000 000 000
         end
         else if (~rst && ~p) begin
          next_state = S0;
          maxtime = maxtime + 39'b000000000000101111101011110000100000000; 
         end
        end
       S17: // PROGRAMMED COUNT DOWN ZERO state ==> the machine reaches this state when it has finished counting down from the programmed MAXTIME
        begin
         if (rst && p) begin    // high PROGRAM signal sends machine back to PROGRAM state on next posedge of clock. RESET signal zeroes all outputs and resets time output to MAXTIME
          t = 0;
          next_state = S1;
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
          zero = 1; // zero signal goes high in this state -- this prompts the SOUND module to play a sound to indicate that the countdown has finished
         end
         else if (~rst && p) begin  // same as above but without RESET
          t = 0;
          next_state = S1;
          zero = 1;
         end
        else if (~p && u && rst) begin  // high RESET signal zeros all registers; high UP signal sends machine back to START state and then to COUNT UP mode
          t = 0;
          zero = 1;
          next_state = S0;
          u_count = 0;      
          d_count = 0;     
          fix_d_count = 0;
        end
        else if (~p && u && ~rst) begin  // high UP signal sends machine back to START state 
         t = 0;
         zero = 1;
         next_state = S0;
        end
       else if (~p && ~u && ~rst) begin // all signals low; machine remains in PROGRAMMED COUNT DOWN ZERO state and awaits input signals
         t = 0;
         zero = 1;
         next_state = S17;
       end
       else if (~p && ~u && rst) begin  // high RESET signal sends machine back to PROGRAMMED COUNT UP START state and zeros all registers
         t = 0;
         zero = 1;
         next_state = S7;
         u_count = 0;      
         d_count = 0;     
         fix_d_count = 0;
       end   
       end
       
       S18:   // HARD CODED COUNT DOWN ZERO state ==> the machine reaches this state when it has finished counting down from the HARD CODED TIME
        begin
         if (p && ~rst) begin   // PROGRAM signal sends machine back to PROGRAM state
            t = 0;
            zero = 1;           // ZERO signal is high in this state, telling the SOUND module to produce an output
            next_state = S1;
        end
        else if (p && rst) begin        // high PROGRAM signal sends machine back to PROGRAM state; high RESET signal zeros all registers
            t = 0;
            zero = 1;
            next_state = S1;
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
        end
        else if (~p && u && ~rst) begin     // high UP signal sends machine back to START state
            next_state = S0;
            t = 0;
            zero = 1;
        end
        else if (~p && u && rst) begin      // high UP signal sends machine back to START state; high RESET signal zeros all registers
            t = 0;
            zero = 1;
            next_state = S0;
            u_count = 0;      
            d_count = 0;     
            fix_d_count = 0;
        end
        else if (~p && ~u && ~rst) begin    // all signals low; machine remains in HARD CODED COUNT DOWN ZERO state and awaits input signals
            t = 0;
            zero = 1;
            next_state = S18;
        end
        else if (~p && ~u && rst) begin // high RESET signal sends machine back to HARD CODED COUNT DOWN START state and zeros all registers
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