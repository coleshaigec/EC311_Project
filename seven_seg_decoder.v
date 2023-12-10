`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 08:38:09 AM
// Design Name: 
// Module Name: decoder
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


module seven_seg_decoder(
        input [3:0] number,
        input dec_point,
        output reg [7:0] cathode
    );
    
    initial begin
        cathode = 8'b11000000;
    end
    
    always @(number) begin
        if (dec_point == 1) 
            case(number)
                0:cathode<=8'b01000000;
                1:cathode<=8'b01111001;
                2:cathode<=8'b00100100;
                3:cathode<=8'b00110000;
                4:cathode<=8'b00011001;
                5:cathode<=8'b00010010;
                6:cathode<=8'b00000010;
                7:cathode<=8'b01111000;
                8:cathode<=8'b00000000;
                9: cathode<=8'b00010000;
                10:cathode<=8'b00001000;
                11:cathode<=8'b00000011;
                12:cathode<=8'b00100111;
                13:cathode<=8'b00100001;
                14:cathode<=8'b00000110;
                15:cathode<=8'b00001110;
                
                default: cathode<=8'b01111111;
            endcase
        else
            case(number)
                0:cathode<=8'b11000000;
                1:cathode<=8'b11111001;
                2:cathode<=8'b10100100;
                3:cathode<=8'b10110000;
                4:cathode<=8'b10011001;
                5:cathode<=8'b10010010;
                6:cathode<=8'b10000010;
                7:cathode<=8'b11111000;
                8:cathode<=8'b10000000;
                9: cathode<=8'b10010000;
                10:cathode<=8'b10001000;
                11:cathode<=8'b10000011;
                12:cathode<=8'b10100111;
                13:cathode<=8'b10100001;
                14:cathode<=8'b10000110;
                15:cathode<=8'b10001110;
                
                default: cathode<=8'b11111111;
            endcase
    end
    
endmodule
