module Nbit_d_ff #(
	parameter WIDTH = 7
) (
	input CLK, RST_n,
	input [WIDTH-1:0] d,
	output reg [WIDTH-1:0] q
);

	always @(posedge CLK or negedge RST_n) begin
		if(!RST_n)
			q <= 0;
		else
			q <= d;
	end


endmodule