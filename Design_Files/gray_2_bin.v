module gray_2_bin #(
	parameter N = 3
) (
	input [N-1:0] g,	// Gray Input
	output reg [N-1:0] b 	// Binary Output
);

	integer i;
	always @(*) begin

		b[N-1] = g[N-1];

		for (i=N-2; i>=0; i=i-1)
			b[i] = g[i] ^ b[i+1];
			
	end

endmodule