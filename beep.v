`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2023 04:31:15 PM
// Design Name: 
// Module Name: sound_
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



module beep(clk, value, value_2, value_3, value_4, speaker);
input clk;
input  value;//Corresponds to signal for 1st high score for any mode from leaderboard when it changes
input value_2;//Corresponds to signal from alarm clock that will turn on to indicate to play sound when it reaches 0 time (since alarm clock counts down to 0)
input value_3;//Corresponds to signal for 2nd high score for any mode from leaderboard when it changes
input value_4;//Corresponds to signal for 3rd high score for any mode from leaderboard when it changes
output reg speaker;//Output to audio jack where we connect a speaker 

reg current_value, current_value_2, current_value_3, current_value_4;

wire Clock;
clock_divider c1(.clk(clk),.new_clk(Clock)); // used to divide 100mHz clock from board to 50mHz


reg [15:0] counter1; // counter size detirmines frequency of tone. Different reg sizes allow for different tones to be played since it influences how fast it increments to max value, since MSB is outputed to speaker
reg [14:0] counter2;
reg [13:0] counter3;
reg [16:0] counter4;
reg [24:0] time_lasting;
reg no_begin_beep = 1;

// used to control which counter is used corresponding to specific change in rank signals coming from leaderboard or "zero" signal from alarm clock goes high
reg sound1;
reg sound2;
reg sound3;


always @(posedge Clock)begin 
    if (no_begin_beep) begin
    time_lasting<=25'd25000000;
    no_begin_beep<=0;
    //When value changes, it won't equal its corresponding current_value variable, resetting the time_lasting variable and counter variables so the sound will play again for one second and won't play continously
    end else if (current_value != value || value_2 == 1'b1 && current_value_2 == 1'b0 || value_3!=current_value_3 || value_4!=current_value_4)
    begin
    time_lasting<=0;
    counter1<=0;
    counter2<=0;
        //Sound signals allow to play these different tones depending on which input signal changes so you know when alarm clock finishes, when specifically 1st place score changes, etc
        if (current_value != value)begin
            sound1 = 1;
        end
        if (current_value_3 != value_3)begin
            sound2 = 1;
            sound1 = 0;
        end
        if (current_value_4 != value_4)begin
            sound3 = 1;
            sound1 = 0;
            sound2 = 0;
        end
  
    end
    //Current values are used to check if there was a change in input
    current_value = value;
    current_value_2 = value_2;
    current_value_3 = value_3;
    current_value_4 = value_4;
    
    
    if(time_lasting<25'd25000000)begin // creates a counter that allows sound play for 1 second(in combination with clock frequency makes it one second)
        time_lasting<=time_lasting+1;

        counter1<=counter1+1;
        counter2<=counter2+1;
        counter3<=counter3+1;
        counter4<=counter4+1;
        
        //select counter (different frequency of MSB toggling) based off previous logic conditions and assign to speaker 
        if(value_2 == 1'b1)begin 
        speaker = counter2[14];
        end
        else
        if (sound1)begin
        speaker=counter1[15];
        end
        if (sound2 && !sound1 && value_2 == 0)begin
        speaker = counter3[13];
        end
        if (sound3 && !sound1 && !sound2 && value_2 == 0)begin
            speaker = counter4[16];//MSB is outputed to speaker
        end
     end
        
        else
        speaker<=0;
    end



endmodule
