`timescale 1ns / 1ps
module time_conversion(
    input [38:0] time_in,
    //output reg [5:0] min,
    //output reg [5:0] sec,
    //output reg [9:0] ms
    output reg [31:0] time_out
);

    reg [33:0] total_ms;
    reg [7:0] min;
    reg [7:0] sec;
    reg [11:0] ms;
    wire [7:0] BCD_minutes;
	wire [7:0] BCD_seconds;
	wire [11:0] BCD_milliseconds;

    binary_to_BCD b2BCD_min(min,BCD_minutes);
	binary_to_BCD b2BCD_sec(sec,BCD_seconds);
	binary_to_BCD b2BCD_ms(ms,BCD_milliseconds);

    always @(time_in) begin
        // Convert 10 nanoseconds to milliseconds
        total_ms = time_in / 100000;

        // Extract minutes
        min = total_ms / 60000;
        total_ms = total_ms % 60000;        

        // Extract seconds from the remaining milliseconds
        sec = total_ms / 1000;
        total_ms = total_ms % 1000;
        
        // Extract milliseconds (remaining after subtracting seconds)
        ms = total_ms;
        
		time_out = {4'b0000,BCD_minutes,BCD_seconds,BCD_milliseconds};
    end
    
    initial begin
        total_ms <= 0;
        min <= 0;
        sec <= 0;
        ms <= 0;
        time_out <= 0;
    end
        
    
endmodule