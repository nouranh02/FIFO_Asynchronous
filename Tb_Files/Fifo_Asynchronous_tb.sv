module Fifo_Asynchronous_tb;
	parameter WIDTH = 32;
	parameter DEPTH = 64;
	parameter TESTS1 = 120;
	parameter TESTS2 = 200;

  	// Inputs to DUT
  	reg CLK_w_tb, CLK_r_tb, RST_n_w_tb, RST_n_r_tb, EN_w_tb, EN_r_tb;
  	reg [WIDTH-1:0] data_in_tb;

	// Outputs of DUT
	wire [WIDTH-1:0] data_out_dut;
	wire Full_dut, Empty_dut;

	// Checking data using queue
	reg [WIDTH-1:0] write_queue_t1[$], write_queue_t2[$];
	reg [WIDTH-1:0] data_out_queue_t1[$], data_out_queue_t2[$];

	// DUT Instantiation
	Fifo_Asynchronous_Top #(.WIDTH(WIDTH), .DEPTH(DEPTH)) DUT (.CLK_w(CLK_w_tb), .CLK_r(CLK_r_tb),
	                        .RST_n_w(RST_n_w_tb), .RST_n_r(RST_n_r_tb),
	                        .EN_w(EN_w_tb), .EN_r(EN_r_tb),
	                        .data_in(data_in_tb), .data_out(data_out_dut),
	                        .Full(Full_dut), .Empty(Empty_dut));


  	initial begin
    	CLK_w_tb = 1'b0;
    	CLK_r_tb = 1'b0;

	    fork
	      forever #5 CLK_w_tb = ~CLK_w_tb;
	      forever #8 CLK_r_tb = ~CLK_r_tb;
	    join
  	end

  	initial begin
    	RST_n_w_tb = 1'b0; EN_w_tb = 1'b0; data_in_tb = 0;
    	repeat(8) @(negedge CLK_w_tb);

    	//////////////// Test1: Writing 120 Values -- FIFO is not full until end of transmission
    	RST_n_w_tb = 1'b1;
    	for (int i=0; i<TESTS1; i++) begin
    		if(Full_dut)
    			EN_w_tb = 1'b0;
    		else begin
    			EN_w_tb = 1'b1;
    			data_in_tb = $random;
    		end
    		if(!Full_dut) write_queue_t1.push_front(data_in_tb);
      		@(negedge CLK_w_tb);
  		end
  		EN_w_tb = 1'b0;

		repeat(160) @(negedge CLK_w_tb);

  		//////////////// Test2: Writing 200 Values -- FIFO is full before end of transmission (EN is inactive when FIFO is full)
    	for (int i=0; i<TESTS2; i++) begin
    		if(Full_dut)
    			EN_w_tb = 1'b0;
    		else begin
    			EN_w_tb = 1'b1;
    			data_in_tb = $random;
    		end
      		if(!Full_dut) write_queue_t2.push_front(data_in_tb);
      		@(negedge CLK_w_tb);
  		end
  		EN_w_tb = 1'b0;
  	end

  	initial begin
    	RST_n_r_tb = 1'b0; EN_r_tb = 1'b0;
		repeat(5) @(negedge CLK_r_tb);
    	
    	//////////////// Test1: Reading 120 Values -- Should Stop Reading after 120
    	RST_n_r_tb = 1'b1;
    	repeat(2) @(negedge CLK_r_tb);

      	if(!Empty_dut) EN_r_tb = 1'b1;
      	while(!Empty_dut) begin
      		@(negedge CLK_r_tb);
      		data_out_queue_t1.push_front(data_out_dut);
      	end
      	EN_r_tb = 1'b0;

      	@(negedge CLK_r_tb);
      	/*
      	$display(data_out_queue_t1);
      	$display(write_queue_t1);
      	*/
      	assert(data_out_queue_t1 === write_queue_t1) $display("Test1: Succeeded");
		else $error("Test 1: Data is lost in transmission.");
  		
		repeat(100) @(negedge CLK_r_tb);

  		//////////////// Test2: Reading 200 Values -- Should Stop Reading after 200
  		repeat(2) @(negedge CLK_r_tb);

    	if(!Empty_dut) EN_r_tb = 1'b1;
      	while(!Empty_dut) begin
      		@(negedge CLK_r_tb);
      		data_out_queue_t2.push_front(data_out_dut);
      	end
      	EN_r_tb = 1'b0;

      	@(negedge CLK_r_tb);
      	/*
  		$display(data_out_queue_t2);
  		$display(write_queue_t2);
  		*/
      	assert(data_out_queue_t2 === write_queue_t2) $display("Test2: Succeeded");
		else $error("Test 2: Data is lost in transmission.");

    	$stop;
  	end

endmodule