`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 08:43:13 AM
// Design Name: 
// Module Name: fsm
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


module fsm(
        input clock,
        input [31:0] thirtytwo_bit_number,
        output [6:0] cathode,
        output reg [7:0] anode
    );
    
    reg [3:0] four_bit_number;
    // instantiate decoder that decodes the four bit number into the cathode
    reg [2:0] state; // stores state of 
    decoder2 dec2(four_bit_number,cathode);
    clock_divider clock_div(clock,ms_clock);
    
    initial begin
		state = 0;
		anode = 8'b11111111;
	end
    
    always @(posedge ms_clock)
	begin
		// increment state
		// set anode (which display do you want to set?)
		//   hint: if state == 0, then set only the LSB of anode to zero,
		//         if state == 1, then set only the second to LSB to zero.
		// set the four bit number to be the approprate slice of the 16-bit number
		case (state)
		  0: begin
		      anode <= 8'b11111110;
		      four_bit_number[3:0] <= thirtytwo_bit_number[3:0];
		      state <= 1;
		  end
		  1: begin
		      anode <= 8'b11111101;
		      four_bit_number[3:0] <= thirtytwo_bit_number[7:4];
		      state <= 2;
		  end
		  2: begin
		      anode <= 8'b11111011;
		      four_bit_number[3:0] <= thirtytwo_bit_number[11:8];
		      state <= 3;
		  end
		  3: begin
		      anode <= 8'b11110111;
		      four_bit_number[3:0] <= thirtytwo_bit_number[15:12];
		      state <= 4;
		  end
		  4: begin
		      anode <= 8'b11101111;
		      four_bit_number[3:0] <= thirtytwo_bit_number[19:16];
		      state <= 5;
		  end
		  5: begin
		      anode <= 8'b11011111;
		      four_bit_number[3:0] <= thirtytwo_bit_number[23:20];
		      state <= 6;
		  end
		  6: begin
		      anode <= 8'b10111111;
		      four_bit_number[3:0] <= thirtytwo_bit_number[27:24];
		      state <= 7;
		  end
		  7: begin
		      anode <= 8'b01111111;
		      four_bit_number[3:0] <= thirtytwo_bit_number[31:28];
		      state <= 0;
		  end		  

	   endcase    
		
	end
    
endmodule
