module bin_2_gray #(
	parameter N = 3
) (
	input [N-1:0] b, 	// Binary Input
	output reg [N-1:0] g 	// Gray Output
);

	integer i;
	always @(*) begin

		g[N-1] = b[N-1];

		for (i=N-2; i>=0; i=i-1)
			g[i] = b[i] ^ b[i+1];
			
	end

endmodule