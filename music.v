module music(
    input clk_100mHz,
    input [2:0] mode,        // New 3-bit input for selecting the mode
    input beep_trigger,      // New one-bit input for triggering the beep state
    output reg speaker
);

    wire clk_50mHz;
    clock_divider u1(.in_clk(clk_100mHz), .out_clk(clk_50mHz));

    reg [25:0] main_clk_counter;
    reg clk_1Hz; // 1 Hz clock

    // Clock divider to generate a 1 Hz clock
    always @(posedge clk_50mHz) begin
        if (main_clk_counter == 50_000_000) begin
            main_clk_counter <= 0;
            clk_1Hz <= ~clk_1Hz;
        end else begin
            main_clk_counter <= main_clk_counter + 1;
        end
    end

    reg [30:0] tone;
    reg [2:0] scale_index;
    reg [2:0] state;
    reg [2:0] beep_counter;

    // Define states
    // State Encoding
    localparam IDLE_STATE = 3'b000,
               ASCENDING_STATE = 3'b001,
               DESCENDING_STATE = 3'b100,
               ASC_DESC_STATE = 3'b010,
               BEEP_STATE = 3'b101;

    // Output logic based on state

    always @(posedge clk_100mHz) begin
        case(state)
            ASCENDING_STATE: tone <= tone + 31'd1;
            DESCENDING_STATE: tone <= tone - 31'd1;
            ASC_DESC_STATE: begin
                if (tone[0] == 0) // Check the LSB of tone
                    tone <= tone + 31'd1;
                else
                    tone <= tone - 31'd1;
            end
            // Add cases for other states if needed
            default: tone <= tone;
        endcase
    end

    wire [7:0] full_note; 
    
    music_ROM get_fullnote(
        .clk(clk_50mHz),
        .address(tone[29:22]),
        .note(full_note)
    );

    wire [2:0] octave;
    wire [3:0] note;
    divide_by12 get_octave_and_note(
        .numerator(get_fullnote.note[5:0]),
        .quotient(octave),
        .remainder(note)
    );

    reg [8:0] clkdivider;
    always @* begin
        case(note)
            0: clkdivider = 9'd511; // A
            1: clkdivider = 9'd482; // A#/Bb
            2: clkdivider = 9'd455; // B
            3: clkdivider = 9'd430; // C
            4: clkdivider = 9'd405; // C#/Db
            5: clkdivider = 9'd383; // D
            6: clkdivider = 9'd361; // D#/Eb
            7: clkdivider = 9'd341; // E
            8: clkdivider = 9'd322; // F
            9: clkdivider = 9'd303; // F#/Gb
            10: clkdivider = 9'd286; // G
            11: clkdivider = 9'd270; // G#/Ab
            default: clkdivider = 9'd0;
        endcase
    end

    reg [8:0] counter_note;
    reg [7:0] counter_octave;
    always @(posedge clk_100mHz) begin
        counter_note <= (counter_note == 0) ? clkdivider : counter_note - 9'd1;
        if (counter_note == 0) begin
            counter_octave <= (counter_octave == 0) ? 8'd255 >> octave : counter_octave - 8'd1;
        end
        if (counter_note == 0 && counter_octave == 0 && get_fullnote.note != 0 && tone[21:18] != 0) begin
            speaker <= ~speaker;
        end
    end

    wire [7:0] beep_note;

    music_ROM get_beep_note(
        .clk(clk_50mHz),
        .address(8'd50),
        .note(beep_note)
    );

    reg [24:0] delay_counter = 0;
    // Output logic for beep state
    always @(posedge clk_1Hz) begin
        if (beep_counter < 4'd4) begin

            beep_counter <= beep_counter + 1;
        end else begin
            // Increment delay counter
            delay_counter <= delay_counter + 1;

            // Check if 1-second delay is reached
            if (delay_counter == 25_000_000) begin
                // Reset beep counter and delay counter
                beep_counter <= 0;
                delay_counter <= 0;

                // Transition to IDLE_STATE after each beep
                state <= IDLE_STATE;
            end
        end
    end

    // Stay in BEEP_STATE until the delay is complete
    if (delay_counter < 25000000) begin
        state <= BEEP_STATE;
    end else begin
        state <= IDLE_STATE;
    end

    // Directly transition to corresponding states based on mode
    // Reset other triggers and modes since they are mutually exclusive
    case ({mode, beep_trigger})
        {3'b001, 1'b?}: state <= ASCENDING_STATE;
        {3'b010, 1'b?}: state <= DESCENDING_STATE;
        {3'b011, 1'b?}: state <= ASC_DESC_STATE;
        {1'b?, 1'b1}: state <= BEEP_STATE;
        default: state <= IDLE_STATE;
    endcase
endmodule

module music_ROM(
	input clk,
	input [7:0] address,
	output reg [7:0] note
);

always @(posedge clk)
case(address)
	  0: note<= 8'd48;
	  1: note<= 8'd50;
	  2: note<= 8'd52;
	  3: note<= 8'd53;
	  4: note<= 8'd55;
	  5: note<= 8'd57;
	  6: note<= 8'd59;
	  7: note<= 8'd60;
	  8: note<= 8'd0;
	default: note <= 8'd0;
endcase
endmodule

module divide_by12(
	input [5:0] numerator,  // value to be divided by 12
	output reg [2:0] quotient, 
	output [3:0] remainder
);

	reg [1:0] remainder3to2;
	always @(numerator[5:2])
	case(numerator[5:2])
		0: begin quotient=0; remainder3to2=0; end
		1: begin quotient=0; remainder3to2=1; end
		2: begin quotient=0; remainder3to2=2; end
		3: begin quotient=1; remainder3to2=0; end
		4: begin quotient=1; remainder3to2=1; end
		5: begin quotient=1; remainder3to2=2; end
		6: begin quotient=2; remainder3to2=0; end
		7: begin quotient=2; remainder3to2=1; end
		8: begin quotient=2; remainder3to2=2; end
		9: begin quotient=3; remainder3to2=0; end
		10: begin quotient=3; remainder3to2=1; end
		11: begin quotient=3; remainder3to2=2; end
		12: begin quotient=4; remainder3to2=0; end
		13: begin quotient=4; remainder3to2=1; end
		14: begin quotient=4; remainder3to2=2; end
		15: begin quotient=5; remainder3to2=0; end
	endcase

	assign remainder[1:0] = numerator[1:0];  // the first 2 bits are copied through
	assign remainder[3:2] = remainder3to2;  // and the last 2 bits come from the case statement
endmodule
/////////////////////////////////////////////////////
//module clock_divider(
//	input in_clk,
//	output reg out_clk
//);
	
//	reg[32:0] count;

//	initial begin
//		count = 0;
//		out_clk = 0;
//	end
	
//	always @(posedge in_clk)
//	begin
//		count = count + 1;
//		if (count == 2) begin
//			out_clk <= ~out_clk;
//			count <= 0;
//		end
//	end


//endmodule