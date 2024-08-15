module Write_Pointer #(
	parameter ADDR_SIZE = 6
) (
	input CLK_w, RST_n_w, EN_w,
	input [ADDR_SIZE:0] G_R_address,
	output Full,
	output [ADDR_SIZE:0] G_W_address, B_W_address
);

	reg [ADDR_SIZE:0] wr_ptr;
	wire [ADDR_SIZE:0] rd_ptr_bin;

	// Write Operation
	always @(posedge CLK_w or negedge RST_n_w) begin
		if(!RST_n_w) begin
			wr_ptr <= 0;
		end
		else begin
			if(EN_w && !Full)				// Successful Write Operation
				wr_ptr <= wr_ptr + {{(ADDR_SIZE){1'b0}}, 1'b1};
		end
	end

	// Binary to Gray Conversion for wr_ptr
	assign B_W_address = wr_ptr;
	bin_2_gray #(ADDR_SIZE+1) WR_B2G (.b(wr_ptr), .g(G_W_address));

	// Comparison between wr_ptr and rd_ptr for Full Flag Assertion
	gray_2_bin #(ADDR_SIZE+1) WR_G2B (.g(G_R_address), .b(rd_ptr_bin));
	assign Full = ({~wr_ptr[ADDR_SIZE], wr_ptr[ADDR_SIZE-1:0]} == rd_ptr_bin) ? 1'b1 : 1'b0;		// Write Pointer Catches up with Read Pointer

endmodule