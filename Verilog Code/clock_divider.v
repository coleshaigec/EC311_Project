module clock_divider(
    input clk, 
    output reg new_clk);
	
	reg[32:0] count;

	initial begin
		count = 0;
		new_clk = 0;
	end
	
	always @(posedge clk)
	begin
		count = count + 1;
		if (count == 2) begin
		  new_clk <= ~new_clk;
		  count <= 0;
		  end
	end


endmodule