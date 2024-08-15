module sync2flop #(
	parameter ADDR_SIZE = 6
) (
	input CLK, RST_n,
	input [ADDR_SIZE:0] IN_Address,
	output [ADDR_SIZE:0] OUT_Address
);

	wire [ADDR_SIZE:0] OUT_Address_i;

	Nbit_d_ff #(.WIDTH(ADDR_SIZE+1)) FF0 (.CLK(CLK), .RST_n(RST_n), .d(IN_Address), .q(OUT_Address_i));
	Nbit_d_ff #(.WIDTH(ADDR_SIZE+1)) FF1 (.CLK(CLK), .RST_n(RST_n), .d(OUT_Address_i), .q(OUT_Address));

endmodule