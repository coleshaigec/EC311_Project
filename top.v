module top (
    //IO inputs
    input [15:0] sw,
    input BTNC,
    input BTNU,
    input BTND,
    input BTNL,
    input BTNR,
    //Clock input
    input clock,
    //IO outputs
    output [7:0] cathode,
    output [7:0] anode
    );

    //Declare wires and regs
    reg display_mode;
    wire [15:0] debounced_sw;
    wire debounced_BTNC;
    wire debounced_BTNU;
    wire debounced_BTND;
    wire debounced_BTL;
    wire debounced_BTNR;
    reg [31:0] number_to_display;
    reg [7:0] decimal_points;
    
    //Instantiate display
    seven_seg_fsm disp(clock,display_mode,number_to_display,decimal_points,cathode,anode);
    
    //Instantiate debouncers
    button_debounce BTNC_debouncer(BTNC,clock,debounced_BTNC);
    button_debounce BTNU_debouncer(BTNU,clock,debounced_BTNU);
    button_debounce BTND_debouncer(BTND,clock,debounced_BTND);
    button_debounce BTNL_debouncer(BTNL,clock,debounced_BTL);
    button_debounce BTNR_debouncer(BTNR,clock,debounced_BTNR);
    
    button_debounce sw0_debouncer(sw[0],clock,debounced_sw[0]);
    button_debounce sw1_debouncer(sw[1],clock,debounced_sw[1]);
    button_debounce sw2_debouncer(sw[2],clock,debounced_sw[2]);
    button_debounce sw3_debouncer(sw[3],clock,debounced_sw[3]);
    button_debounce sw4_debouncer(sw[4],clock,debounced_sw[4]);
    button_debounce sw5_debouncer(sw[5],clock,debounced_sw[5]);
    button_debounce sw6_debouncer(sw[6],clock,debounced_sw[6]);
    button_debounce sw7_debouncer(sw[7],clock,debounced_sw[7]);
    button_debounce sw8_debouncer(sw[8],clock,debounced_sw[8]);
    button_debounce sw9_debouncer(sw[9],clock,debounced_sw[9]);
    button_debounce sw10_debouncer(sw[10],clock,debounced_sw[10]);
    button_debounce sw11_debouncer(sw[11],clock,debounced_sw[11]);
    button_debounce sw12_debouncer(sw[12],clock,debounced_sw[12]);
    button_debounce sw13_debouncer(sw[13],clock,debounced_sw[13]);
    button_debounce sw14_debouncer(sw[14],clock,debounced_sw[14]);
    button_debounce sw15_debouncer(sw[15],clock,debounced_sw[15]);
        
    //Set initial values
    initial begin
        display_mode = 1;
        number_to_display = 0;
        decimal_points = 0;
    end
    
    

endmodule