`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// Create Date: 
// Design Name: 
// Module Name: time_conversion
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Converts a time in 10ns increments into an output BCD number consisting of minutes, seconds, and milliseconds
// 
// Dependencies: binary_to_BCD.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module time_conversion(
    input [38:0] time_in, //Time in unsigned binary in 10ns increments
    output reg [31:0] time_out //Output time in minutes, seconds, and milliseconds encoded in BCD
);

    //Registers used for calculations
    reg [33:0] total_ms;
    reg [33:0] total_ms_after_min;
	reg [33:0] total_ms_after_sec;
	
	//Registers used for storing calculated values before converting them to BCD
    reg [7:0] min;
    reg [7:0] sec;
    reg [11:0] ms;
    
    //Wires for connecting the BCD values of the calculated values to the output register
    wire [7:0] BCD_minutes;
	wire [7:0] BCD_seconds;
	wire [11:0] BCD_milliseconds;
	
	//Converts the calculated numbers into BCD for driving the display in decimal
    binary_to_BCD b2BCD_min(min,BCD_minutes);
	binary_to_BCD b2BCD_sec(sec,BCD_seconds);
	binary_to_BCD b2BCD_ms(ms,BCD_milliseconds);

    always @(time_in) begin //Changes whenever the input number changesa
        
        total_ms = time_in / 100000; // Convert 10 nanoseconds to milliseconds

        min = total_ms / 60000; // Extract minutes
        total_ms_after_min = total_ms % 60000;    //Remove the time from the minutes from the total time    

        
        sec = total_ms_after_min / 1000; // Extract seconds from the remaining time
        total_ms_after_sec = total_ms_after_min % 1000; //Remove the time from the seconds from the total time
        

        ms = total_ms_after_sec; // Extract milliseconds (remaining after subtracting seconds)
        
		time_out = {4'b0000,BCD_minutes,BCD_seconds,BCD_milliseconds}; // Combines values into final output
		                                                              // First display is set to "0" since we are not using it
    end
    
    initial begin // Set initial values
        total_ms <= 0;
        min <= 0;
        sec <= 0;
        ms <= 0;
        time_out <= 0;
    end
        
    
endmodule