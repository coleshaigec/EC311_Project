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


module decoder2(
        input [3:0] number,
        output reg [6:0] cathode
    );
    
    initial begin
        cathode = 7'b1000000;
    end
    
    always @(number)
    begin
        case(number)
            0:cathode<=7'b1000000;
            1:cathode<=7'b1111001;
            2:cathode<=7'b0100100;
            3:cathode<=7'b0110000;
            4:cathode<=7'b0011001;
            5:cathode<=7'b0010010;
            6:cathode<=7'b0000010;
            7:cathode<=7'b1111000;
            8:cathode<=7'b0000000;
            9: cathode<=7'b0010000;
            10:cathode<=7'b0001000;
            11:cathode<=7'b0000011;
            12:cathode<=7'b0100111;
            13:cathode<=7'b0100001;
            14:cathode<=7'b0000110;
            15:cathode<=7'b0001110;
            
            default: cathode<=7'b1111111;
        endcase
    end
    
endmodule
