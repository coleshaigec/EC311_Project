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


module seven_seg_fsm(
        input clock,
		input mode, // 0 = Decimal, 1 = Hexadecimal //UNCOMMENT FOR INTEGRATION
        //input [15:0]swt, // FOR TESTING ONLY
        input [31:0] input_number, //UNCOMMENT FOR INTEGRATION
        output [6:0] cathode,
        output reg [7:0] anode
    );
    
	//reg [31:0] input_number; // FOR TESTING ONLY
	//reg mode; //FOR TESTING ONLY
	wire [31:0] BCD_number;
	wire [31:0] disp_number;
    reg [3:0] four_bit_number;
    // instantiate decoder that decodes the four bit number into the cathode
    reg [2:0] state;
    wire ms_clock;
    
    one_ms_clock_divider one_ms_clk_div(clock,ms_clock);
    seven_seg_decoder dec7(four_bit_number,cathode);
    binary_to_BCD b2BCD(input_number[26:0],BCD_number);


    assign disp_number = (mode == 0) ? BCD_number : input_number;
		
    initial begin
		state = 0;
		anode = 8'b11111111;
		four_bit_number = 0;
		//input_number = 0; // FOR TESTING ONLY
	end
    
    always @(posedge ms_clock)
	begin
	   //input_number[14:0] = swt[14:0]; // FOR TESTING ONLY
       //mode = swt[15]; //FOR TESTING ONLY
		
		// increment state
		// set anode (which display do you want to set?)
		//   hint: if state == 0, then set only the LSB of anode to zero,
		//         if state == 1, then set only the second to LSB to zero.
		// set the four bit number to be the approprate slice of the 16-bit number
		case (state)
		  0: begin
		      anode <= 8'b11111110;
		      four_bit_number[3:0] <= disp_number[3:0];
		      state <= 1;
		  end
		  1: begin
		      anode <= 8'b11111101;
		      four_bit_number[3:0] <= disp_number[7:4];
		      state <= 2;
		  end
		  2: begin
		      anode <= 8'b11111011;
		      four_bit_number[3:0] <= disp_number[11:8];
		      state <= 3;
		  end
		  3: begin
		      anode <= 8'b11110111;
		      four_bit_number[3:0] <= disp_number[15:12];
		      state <= 4;
		  end
		  4: begin
		      anode <= 8'b11101111;
		      four_bit_number[3:0] <= disp_number[19:16];
		      state <= 5;
		  end
		  5: begin
		      anode <= 8'b11011111;
		      four_bit_number[3:0] <= disp_number[23:20];
		      state <= 6;
		  end
		  6: begin
		      anode <= 8'b10111111;
		      four_bit_number[3:0] <= disp_number[27:24];
		      state <= 7;
		  end
		  7: begin
		      anode <= 8'b01111111;
		      four_bit_number[3:0] <= disp_number[31:28];
		      state <= 0;
		  end		  

	   endcase    
		
	end
    
endmodule
