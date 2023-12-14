`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// Create Date: 10/23/2023 08:43:13 AM
// Design Name: 
// Module Name: seven_seg_fsm
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Logic for driving all 8 7-segment displays from an inputted number
// 
// Dependencies: one_ms_clock_divider.v
//               seven_seg_decoder.v
//               time_conversion.v
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_fsm(
        input clock,
        input [38:0] input_number, //Input time to be processed and sent to displays
		input [7:0] dec_points, //Input which decimal points on 7-seg displays are lit up
		output [7:0] cathode, //Output which lights on an individual 7-seg display are lit up
        output reg [7:0] anode //Output which 7-segment display is being driven
    );
    
	//reg [31:0] input_number; // FOR TESTING ONLY
	
	wire [31:0] disp_number; //Final number being pushed to all displays
    reg [3:0] four_bit_number; //Final number being push to an individual display
    reg [2:0] state; //Represents which 7-seg is being driven at the moment
    wire ms_clock; 
	reg cur_point; //Represents the decimal point of the current individual display

    one_ms_clock_divider one_ms_clk_div(clock,ms_clock);
    seven_seg_decoder dec7(four_bit_number,cur_point,cathode); //Sends the final number for the display to decoder 
                                                               //to be translated into individual LEDs on the display
    
	time_conversion t_conv(input_number,disp_number);  //Convers input time in 10 ns increments into minutes, seconds, and milliseconds

		
    initial begin
		state = 0;
		anode = 8'b11111111; //Initialize all LEDs to off (0 is on, 1 is off)
		four_bit_number = 0;
		cur_point = 0;
	end
    
    always @(posedge ms_clock) //Updates every millesecond
	begin
	   //input_number[14:0] = swt[14:0]; // FOR TESTING ONLY
       //mode = swt[15]; //FOR TESTING ONLY
		
		case (state) //Case statement switches between each individual 7-seg display
		  0: begin
		      anode = 8'b11111110; //Selects the right-most display
		      four_bit_number[3:0] = disp_number[3:0]; //Sets the output number to be displayed to the least significant 4 bits
			  cur_point = dec_points[0]; //Sets the decimal point to the least significant bit
			  #5; //Wait 5ns
		      state = 1; //Go to next state (i.e., switch to the display to the left)
		  end //All of the following states work the same as State 0 unless otherwise noted
		  1: begin
		      anode = 8'b11111101;
		      four_bit_number[3:0] = disp_number[7:4];
			  cur_point = dec_points[1];
			  #5;
		      state = 2;
		  end
		  2: begin
		      anode = 8'b11111011;
		      four_bit_number[3:0] = disp_number[11:8];
			  cur_point = dec_points[2];	
			  #5;
		      state = 3;
		  end
		  3: begin
		      anode = 8'b11110111;
		      four_bit_number[3:0] = disp_number[15:12];
			  cur_point = dec_points[3];
			  #5;
		      state = 4;
		  end
		  4: begin
		      anode = 8'b11101111;
		      four_bit_number[3:0] = disp_number[19:16];
			  cur_point = dec_points[4];
			  #5;
		      state = 5;
		  end
		  5: begin
		      anode = 8'b11011111;
		      four_bit_number[3:0] = disp_number[23:20];
			  cur_point = dec_points[5];
			  #5;
		      state = 6;
		  end
		  6: begin
		      anode = 8'b10111111;
		      four_bit_number[3:0] = disp_number[27:24];
			  cur_point = dec_points[6];
			  #5;
		      state = 7;
		  end
		  7: begin
		      anode = 8'b01111111;
		      four_bit_number[3:0] = disp_number[31:28];
			  cur_point = dec_points[7];
			  #5;
		      state = 0; //Reset to state 0
		  end		  

	   endcase    
		
	end
    
endmodule