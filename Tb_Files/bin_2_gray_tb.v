module bin_2_gray_tb();
	reg [2:0] b_tb;
	wire [2:0] g_dut;

	// DUT Instantiation
	bin_2_gray #(3) DUT (b_tb, g_dut);

	// Stimulus Generation
	integer i;
	initial begin
		b_tb = 3'b0;
		#1;
		for(i = 0; i <= 7; i = i + 1) begin
			b_tb = i;
			#1;
		end
		$stop;
	end
endmodule