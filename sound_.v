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



module sound_(clk, value ,value_2,speaker);
input clk;
input  value;
input value_2;
output reg speaker;

reg current_value, current_value_2;

// first create a 16bit binary counter
wire Clock;
//clock_slow_period new_clock(.clk(clk),.adjusted_clock(Clock));
reg [15:0] counter;
reg [5:0] counter_2;
reg[10:0] counter_3;
reg last_value=0;
reg last_value_2=1;
reg last_value_3;
reg value_3;
reg start_sound;
reg [26:0] time_lasting=0;
reg previous_value;
always @(posedge clk)begin 

if (current_value != value || current_value_2 != value_2)
begin
time_lasting<=0;
counter<=0;
end

current_value = value;
current_value_2 = value_2;


if(time_lasting<27'd100000000)begin
time_lasting<=time_lasting+1;
//if (value_2==last_value_2 )begin
//if(counter==47822)
//counter<=0;
//else
//counter<=counter+1;
//end
//else if(value!=last_value)
//begin
//counter <= counter+1;
//end
//else if(value==last_value)begin
//if(counter==56817) begin
//counter<=0;
//end
//else
counter<=counter+1;
speaker=counter[15];
end
else
speaker<=0;
end


//always @(value or value_2)
//begin
//time_lasting<=0;
//end



// and use the most significant bit (MSB) of the counter to drive the speaker




endmodule
