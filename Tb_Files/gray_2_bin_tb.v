module gray_2_bin_tb();
	reg [2:0] g_tb;
	wire [2:0] b_dut;

	// DUT Instantiation
	gray_2_bin #(3) DUT (g_tb, b_dut);

	// Stimulus Generation
	integer i;
	initial begin
		g_tb = 3'b0;
		#1;
		for(i = 0; i <= 7; i = i + 1) begin
			g_tb = i;
			#1;
		end
		$stop;
	end
endmodule