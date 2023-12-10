`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 10:50:48 AM
// Design Name: 
// Module Name: leaderboard
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


module leaderboard(
 input wire[21:0] time_in,
 input [1:0] stopwatch_mode,
 input wire [2:0] display_mode,
 output reg [21:0] leaderboard_number,
 output reg signal_sound_1,
 output reg signal_sound_2,
 output reg signal_sound_3
    );

reg [21:0] fast_1=0;
reg [21:0] fast_2=0;
reg [21:0] fast_3=0;
reg [21:0] slow_1=0;
reg [21:0] slow_2=0;
reg [21:0] slow_3=0;
reg [21:0] time_in_wire;
wire [21:0] time_in_reg;
always @* begin
assign time_in_wire=time_in;
end
always @(time_in)
begin
case (stopwatch_mode)
2'b01: begin
if (time_in>=slow_1) begin
slow_3<=slow_2;
slow_2<=slow_1;
slow_1<=time_in;
if (signal_sound_1!=1)
signal_sound_1=1;
else
signal_sound_1=0;
end
else if (time_in>=slow_2)begin
slow_3<=slow_2;
slow_2<=time_in;
if (signal_sound_2!=1)
signal_sound_2=1;
else
signal_sound_2=0;
end
else if(time_in>=slow_3)begin
slow_3<=time_in;
if (signal_sound_3!=1)
signal_sound_3=1;
else
signal_sound_3=0;
end
end
2'b10: begin
if (time_in<=fast_1) begin
fast_3<=fast_2;
fast_2<=fast_1;
fast_1<=time_in;
if (signal_sound_1!=1)
signal_sound_1=1;
else
signal_sound_1=0;
end
else if (time_in<=fast_2)begin
fast_3<=fast_2;
fast_2<=time_in;
if (signal_sound_2!=1)
signal_sound_2=1;
else
signal_sound_2=0;
end
else if(time_in>=fast_3)begin
fast_3<=time_in;
if (signal_sound_3!=1)
signal_sound_3=1;
else
signal_sound_3=0;
end
end
endcase
case(display_mode)
3'b001: assign leaderboard_number=fast_1;
3'b010: assign leaderboard_number=fast_2;
3'b011: assign leaderboard_number=fast_3;
3'b100: assign leaderboard_number=slow_1;
3'b101: assign leaderboard_number=slow_2;
3'b110: assign leaderboard_number=slow_3;
endcase

end




endmodule
