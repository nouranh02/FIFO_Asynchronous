vlog bin_2_gray.v gray_2_bin.v Nbit_d_ff.v sync2flop.v Read_Pointer.v Write_Pointer.v Fifo_Asynchronous.v Fifo_Asynchronous_Top.v Fifo_Asynchronous_tb.sv
vsim -gui work.Fifo_Asynchronous_tb -voptargs=+acc
add wave -position insertpoint sim:/Fifo_Asynchronous_tb/* \
sim:/Fifo_Asynchronous_tb/DUT/FIFO_64/fifo \
sim:/Fifo_Asynchronous_tb/DUT/WP/B_W_address \
sim:/Fifo_Asynchronous_tb/DUT/WP/rd_ptr_bin \
sim:/Fifo_Asynchronous_tb/DUT/RP/B_R_address \
sim:/Fifo_Asynchronous_tb/DUT/RP/wr_ptr_bin
run -all