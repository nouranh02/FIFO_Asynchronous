module Fifo_Asynchronous_Top #(
	parameter WIDTH = 32,
	parameter DEPTH = 64
) (
	input CLK_w, CLK_r, RST_n_w, RST_n_r, EN_w, EN_r,
	input [WIDTH-1:0] data_in,
	output [WIDTH-1:0] data_out,
	output Full, Empty
);

	//////// Internal Wires
	// Enable Signals for FIFO
	wire W_EN, R_EN;
	wire Full_w, Empty_w;

	// Write and Read Pointers
	wire [$clog2(DEPTH):0] B_R_address, B_W_address;
	wire [$clog2(DEPTH):0] G_R_address, G_W_address;
	wire [$clog2(DEPTH):0] G_R_address_sync, G_W_address_sync;


	//////// FIFO Instantiation
	assign W_EN = EN_w & ~Full_w;
	assign R_EN = EN_r & ~Empty_w;
	Fifo_Asynchronous #(.WIDTH(WIDTH), .DEPTH(DEPTH)) FIFO_64 (.CLK_w(CLK_w), .CLK_r(CLK_r), .RST_n_w(RST_n_w), .RST_n_r(RST_n_r),
													   .W_EN(W_EN), .R_EN(R_EN), .data_in(data_in),
													   .B_W_address(B_W_address), .B_R_address(B_R_address), .data_out(data_out));
	
	//////// Synchronizing Write and Read Pointers

	// Write and Read Pointers Modules
	Write_Pointer #(.ADDR_SIZE($clog2(DEPTH))) WP (.CLK_w(CLK_w), .RST_n_w(RST_n_w), .EN_w(EN_w), .G_R_address(G_R_address_sync),
												   .Full(Full_w), .G_W_address(G_W_address), .B_W_address(B_W_address));

	Read_Pointer #(.ADDR_SIZE($clog2(DEPTH))) RP (.CLK_r(CLK_r), .RST_n_r(RST_n_r), .EN_r(EN_r), .G_W_address(G_W_address_sync),
												  .Empty(Empty_w), .G_R_address(G_R_address), .B_R_address(B_R_address));

	assign Full = Full_w;
	assign Empty = Empty_w;

	// 2-Flop Synchronizer
	sync2flop #(.ADDR_SIZE($clog2(DEPTH))) FF_RAddress (.CLK(CLK_w), .RST_n(RST_n_w), .IN_Address(G_R_address), .OUT_Address(G_R_address_sync));
	sync2flop #(.ADDR_SIZE($clog2(DEPTH))) FF_WAddress (.CLK(CLK_r), .RST_n(RST_n_r), .IN_Address(G_W_address), .OUT_Address(G_W_address_sync));

endmodule