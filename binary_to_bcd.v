`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Alex Melnick
// 
// Create Date: 
// Design Name: 
// Module Name: binary_to_BCD
// Project Name: EC311 Logic Design Final Project
// Target Devices: NEXYS A7-100t with ARTIX-7 FPGA
// Tool Versions: Vivado 2022.2
// Description: Takes binary numerical input and converts it to BCD using Double Dabble algorithm
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Code adapted from https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d
// 
//////////////////////////////////////////////////////////////////////////////////

module binary_to_BCD(
    input [26:0] twentyseven_bit_number, // Takes max 27-bit number as input 
                                         // (the minimum bit required to hold "99,999,999", 
                                         // which is the largest decimal value our board can display on the 7-segment displays
    output reg [31:0] BCD_number //Output contains all the values BCD to be pushed to the display
);
    // using Double Dabble algorithm as explained here: 
    // https://en.wikipedia.org/wiki/Double_dabble
    // https://www.youtube.com/watch?v=Q-hOCVVd7Lk 
    // https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d 

    //Code adapted from https://www.realdigital.org/doc/6dae6583570fd816d1d675b93578203d
    integer i;

    always @(twentyseven_bit_number) begin
        BCD_number = 0;
        for (i = 0; i < 27; i = i + 1) begin    //Iterate once for each bit in input number
            if (BCD_number[3:0] >= 5) BCD_number[3:0] = BCD_number[3:0] + 3;    //If any BCD digit is >= 5, add three
	        if (BCD_number[7:4] >= 5) BCD_number[7:4] = BCD_number[7:4] + 3;
	        if (BCD_number[11:8] >= 5) BCD_number[11:8] = BCD_number[11:8] + 3;
	        if (BCD_number[15:12] >= 5) BCD_number[15:12] = BCD_number[15:12] + 3;
            if (BCD_number[19:16] >= 5) BCD_number[19:16] = BCD_number[19:16] + 3;
            if (BCD_number[23:20] >= 5) BCD_number[23:20] = BCD_number[23:20] + 3;
            if (BCD_number[27:24] >= 5) BCD_number[27:24] = BCD_number[27:24] + 3;
            if (BCD_number[31:28] >= 5) BCD_number[31:28] = BCD_number[31:28] + 3;

            BCD_number = {BCD_number[30:0],twentyseven_bit_number[26-i]};   //Shift one bit, and shift in proper bit from input 
        end
    end


endmodule