`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/09/2023 06:21:38 PM
// Design Name: 
// Module Name: debounced_switch_counter
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

//For testing button and switch debouncing
//May require this line in constraints file: set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets BTNC_IBUF]


module debounced_switch_counter(
    //input [15:0]sw,
    //input BTNC,
    input clock,
    input [38:0] time_in,
    //output reg [7:0]led
    output [7:0] cathode,
    output [7:0] anode
    );
    
    //reg mode = 2;
    wire debounced_sw;
    reg [38:0]count;
    reg [7:0] decs = 8'b00101000;
    wire ms_clock;
    
    //counter ct(debounced_swt,count);
    seven_seg_fsm disp(clock,count,decs,cathode,anode);
    //button_debounce switch(sw[0],clock,debounced_sw);
    one_ms_clock_divider one_ms_clk_div(clock,ms_clock);

    
//    initial begin
//        count = 0;
//    end
    
//    always @(posedge ms_clock) begin
//       // if (count <= 3600000)
//		   count = time_in;
//	//   else begin
//		//   count = 0;
//		  //out_clk <= ~out_clk;
//	//	end

    initial begin
        count = 0;
    end
    
    always @(posedge ms_clock) begin
       // if (count <= 3600000)
		   count = count +100000;
	//   else begin
		//   count = 0;
		  //out_clk <= ~out_clk;
	//	end
    end    
    
    
endmodule


