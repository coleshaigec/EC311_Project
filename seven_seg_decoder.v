`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// Create Date: 10/23/2023 08:38:09 AM
// Design Name: 
// Module Name: seven_seg_decoder
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Takes binary numerical input for a single 7-seg display and decimal point and lights up corresponding 7-seg LEDs
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg_decoder(
        input [3:0] number, //BCD number to display
        input dec_point, //Decimal point to display
        output reg [7:0] cathode //Output LEDs
    );
    
    initial begin
        cathode = 8'b11000000; //Start with displaying "0"
    end
    
    always @(number) begin
        if (dec_point == 1) // If decimal point is on
            case(number)
                0:cathode<=8'b01000000; //LEDs for "0" (1 is off, 0 is on)
                1:cathode<=8'b01111001; //Etc.
                2:cathode<=8'b00100100;
                3:cathode<=8'b00110000;
                4:cathode<=8'b00011001;
                5:cathode<=8'b00010010;
                6:cathode<=8'b00000010;
                7:cathode<=8'b01111000;
                8:cathode<=8'b00000000;
                9: cathode<=8'b00010000;
//                10:cathode<=8'b00001000; //Legacy hexadecimal outputs 
//                11:cathode<=8'b00000011; //(could potentially be used by somebody in the future for additional functuality)
//                12:cathode<=8'b00100111;
//                13:cathode<=8'b00100001;
//                14:cathode<=8'b00000110;
//                15:cathode<=8'b00001110;
                
                default: cathode<=8'b01111111; //Default to all segments off with decimal point on
            endcase
        else // If decimal point is off
            case(number)
                0:cathode<=8'b11000000; //LEDs for "0" (1 is off, 0 is on)
                1:cathode<=8'b11111001; //Etc.
                2:cathode<=8'b10100100;
                3:cathode<=8'b10110000;
                4:cathode<=8'b10011001;
                5:cathode<=8'b10010010;
                6:cathode<=8'b10000010;
                7:cathode<=8'b11111000;
                8:cathode<=8'b10000000;
                9: cathode<=8'b10010000;
//                10:cathode<=8'b10001000;  //Legacy hexadecimal outputs
//                11:cathode<=8'b10000011;  //(could potentially be used by somebody in the future for additional functuality)
//                12:cathode<=8'b10100111;
//                13:cathode<=8'b10100001;
//                14:cathode<=8'b10000110;
//                15:cathode<=8'b10001110;
                
                default: cathode<=8'b11111111; //Default to all segments on with decimal point off
            endcase
    end
    
endmodule