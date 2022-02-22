// alarm_controller_tb.v

// The Verilog Tutorial Project Test Bench
// METU EE314 Digital Electronics Laboratory

`timescale 1 ns / 1 ps


module alarm_controller_tb();


reg CLK, start_stop_button, set_button, snooze_button;

wire [3:0] ssd_led_out; // seven segment display output
wire [8:0] led_out; // led output

alarm_controller dut ( .CLK(CLK), .start_stop_button(start_stop_button),
							  .set_button(set_button), .snooze_button(snooze_button),
							  .ssd_led_out(ssd_led_out), .led_out(led_out)) ;
							  
initial begin
CLK = 0;
start_stop_button = 1;
set_button = 1;
snooze_button = 1;
end
							  
							  
// Clock setup							  
always begin
 CLK <= 0; #5 ;  CLK <= 1; #5 ;
end

always begin
	# 100 ;
	set_button <= 0;
	#  50 ;
	set_button <= 1;
	# 10 ;
	set_button <= 0;
	# 50;
	set_button <= 1;
	# 10 ;
	set_button <= 0;
	# 50 ;
	set_button <= 1;
	# 10 ;
	set_button <= 0;
	# 50 ;
	set_button <= 1;
	# 20 ;
	start_stop_button <= 0;
	# 50 ;
	start_stop_button <= 1;
	# 2000 ;
	snooze_button <= 0;
	# 50 ;
	snooze_button <= 1;
	# 2000 ;
	start_stop_button <= 0;
	#  50 ;
	start_stop_button <= 1;
	# 10 ;
	set_button <= 0;
	# 50 ;
	set_button <= 1;
	# 20 ;
	set_button <= 0;
	#  50 ;
	set_button <= 1;
	# 20 ;
	set_button <= 0;
	# 50 ;
	set_button <= 1;
	# 20 ;
	set_button <= 0;
	# 50 ;
	set_button <= 1;
	# 20 ;
	set_button <= 0;
	# 50 ;
	set_button <= 1;
	# 50 ;
	start_stop_button <= 0;
	#  50 ;
	start_stop_button <= 1;
	# 2000 ;
	start_stop_button <= 0;
	#  50 ;
	start_stop_button <= 1;
	# 20000;

end
endmodule 

