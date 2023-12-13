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
input  value;
input value_2;
input value_3;
input value_4;
output reg speaker;

reg current_value, current_value_2, current_value_3, current_value_4;

wire Clock;
clock_divider c1(.clk(clk),.new_clk(Clock)); // used to divide 100mHz clock from board to 50mHz


reg [15:0] counter1; // counter size detirmines frequency of tone (tone freq = clkfreq/2^n)
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
    end else if (current_value != value || value_2 == 1'b1 && current_value_2 == 1'b0 || value_3!=current_value_3 || value_4!=current_value_4)
    begin
    time_lasting<=0;
    counter1<=0;
    counter2<=0;
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
    
    current_value = value;
    current_value_2 = value_2;
    current_value_3 = value_3;
    current_value_4 = value_4;
    
    
    if(time_lasting<25'd25000000)begin // creates a counter that allows sound play for 1 second
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
        speaker = counter4[16];
        end
     end
        
        else
        speaker<=0;
    end



endmodule
