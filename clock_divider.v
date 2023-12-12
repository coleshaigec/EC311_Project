module clock_divider(
    input in_clk, 
    output reg out_clk);
	
	reg[32:0] count;

	initial begin
		count = 0;
		out_clk = 0;
	end
	
	always @(posedge in_clk)
	begin
		count = count + 1;
		if (count == 2) begin
		  out_clk <= ~out_clk;
		  count <= 0;
		  end
	end


endmodule