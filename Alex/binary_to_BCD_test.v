module binary_to_BCD_test(

);

    reg [26:0] twentyseven_bit_number;
    wire [31:0] BCD_number;

    binary_to_BCD DUT (
        .twentyseven_bit_number(twentyseven_bit_number),
        .BCD_number(BCD_number)
    );

    always
        #10 twentyseven_bit_number = twentyseven_bit_number + 1;

    initial begin
        twentyseven_bit_number = 0;
    end

endmodule