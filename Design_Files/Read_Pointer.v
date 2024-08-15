module Read_Pointer #(
	parameter ADDR_SIZE = 6
) (
	input CLK_r, RST_n_r, EN_r,
	input [ADDR_SIZE:0] G_W_address,
	output Empty,
	output [ADDR_SIZE:0] G_R_address, B_R_address
);
	
	reg [ADDR_SIZE:0] rd_ptr;
	wire [ADDR_SIZE:0] wr_ptr_bin;

	// Read Operation
	always @(posedge CLK_r or negedge RST_n_r) begin
		if(!RST_n_r) begin
			rd_ptr <= 0;
		end
		else begin
			if(EN_r && !Empty)	 			// Successful Read Operation
				rd_ptr <= rd_ptr + {{(ADDR_SIZE){1'b0}}, 1'b1};
		end
	end

	// Binary to Gray Conversion for rd_ptr
	assign B_R_address = rd_ptr;
	bin_2_gray #(ADDR_SIZE+1) RD_B2G (.b(rd_ptr), .g(G_R_address));

	// Comparison between wr_ptr and rd_ptr for Empty Flag Assertion
	gray_2_bin #(ADDR_SIZE+1) RD_G2B (.g(G_W_address), .b(wr_ptr_bin));
	assign Empty = (wr_ptr_bin == rd_ptr) ? 1'b1 : 1'b0;		// Read Pointer reached last written address

endmodule