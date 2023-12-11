module time_conversion(
    input [38:0] time_in,
    output reg [5:0] min,
    output reg [5:0] sec,
    output reg [9:0] ms
);
    
    assign min = time_in % 6000000000;
    assign sec = time_in % 100000000;
    assign ms = time_in % 100000;
    
endmodule