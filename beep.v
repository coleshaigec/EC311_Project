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



module beep(clk, value ,value_2,speaker);
input clk;
input  value;
input value_2;
output reg speaker;

reg current_value, current_value_2;

wire Clock;
clock_divider c1(.clk(clk),.new_clk(Clock));


reg [15:0] counter;
reg [24:0] time_lasting;
reg no_begin_beep = 1;


always @(posedge Clock)begin 
    if (no_begin_beep) begin
    time_lasting<=25'd25000000;
    no_begin_beep<=0;
    end else if (current_value != value || value_2 == 1'b1 && current_value_2 == 1'b0)
    begin
    time_lasting<=0;
    counter<=0;
    end
    
    current_value = value;
    current_value_2 = value_2;
    
    
    if(time_lasting<25'd25000000)begin
        time_lasting<=time_lasting+1;

        counter<=counter+1;
        speaker=counter[15];
    end
    else
    speaker<=0;
    end





endmodule
