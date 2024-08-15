module Fifo_Asynchronous #(
	parameter WIDTH = 32,
	parameter DEPTH = 64,
	parameter ADDR_SIZE = 6
) (
	input CLK_w, CLK_r, RST_n_w, RST_n_r, W_EN, R_EN,
	input [WIDTH-1:0] data_in,
	input [ADDR_SIZE:0] B_W_address, B_R_address,
	output reg [WIDTH-1:0] data_out
);

	// FIFO
	reg [WIDTH-1:0] fifo [0:DEPTH-1];

	//////////////////////////////// Main Logic ////////////////////////////////
	// Write Operation
	always @(posedge CLK_w) begin
		if(RST_n_w && W_EN) begin 		// Successful Write Operation 	 			
			fifo[B_W_address[ADDR_SIZE-1:0]] <= data_in;
		end
	end

	// Read Operation
	always @(posedge CLK_r or negedge RST_n_r) begin
		if(!RST_n_r)
			data_out <= 0;
		else begin
			if(R_EN) begin 			// Successful Read Operation
				data_out <= fifo[B_R_address[ADDR_SIZE-1:0]];
			end
		end
	end

endmodule