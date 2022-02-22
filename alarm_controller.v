// alarm_controller.v

// The Verilog Tutorial Project
// METU EE314 Digital Electronics Laboratory

module alarm_controller ( CLK, start_stop_button, set_button, snooze_button, ssd_led_out, led_out) ;

input CLK, start_stop_button, set_button, snooze_button;

output reg [3:0] ssd_led_out; // seven segment display output
output reg [8:0] led_out; // led output

// state parameter definiton, in total 5 states represented with three bits

reg [2:0] alarm_state;
 
parameter st00_idle = 'd0;
parameter st01_set = 'd1;
parameter st02_start = 'd2;
parameter st03_alarm = 'd3;
parameter st04_snooze_start ='d4;

// internal registers
reg clk_en, set_en;

integer start_stop_counter, set_button_counter, counter_clk, rem_time, set_time;

// initial setup of the system
initial begin 
	alarm_state = st00_idle;
	clk_en = 0;
	set_en = 0;
	
	start_stop_counter = 0;
	set_button_counter = 0;
	counter_clk = 0;
	rem_time = 0;
	set_time = 0;
	
	ssd_led_out = 3'b0;
	led_out = 9'b0;
end



// Process 1:  enabling the FPGA clock during operation
// In this state pulse rate is adjusted such that we divide FPGA clock speed by 10
// Note that we do not create another clock, we just create a clock enable signal
// We only use posedge of LK in always blocks
always @(posedge CLK) 
begin
 if (alarm_state == st02_start || alarm_state == st03_alarm) begin
	if(counter_clk == 'd9) begin
		counter_clk <= 'd0;
		clk_en <= 1;
	end else begin
		counter_clk <= counter_clk +1;
		clk_en <= 0;
	end

 end else begin
   counter_clk <= 'd0;
   clk_en <= 0; 
 end
 
end


// Process 2:  set and start/stop counters
// In this process buttons are read via counters in order to
// prevent debouncing problem
// For more information refer : https://www.fpga4student.com/2017/04/simple-debouncing-verilog-code-for.html
// Buttons are active low, signals become low when it is pressed
always @(posedge CLK) begin
	if (set_button == 0 && set_button_counter < 'd3) begin
			set_button_counter <= set_button_counter + 'd1;
	end else if (set_button == 1) begin
			set_button_counter <= 0;
	end
		
	if (start_stop_button == 0 && start_stop_counter < 'd3 ) begin
		start_stop_counter <= start_stop_counter + 'd1;
	end else if (start_stop_button == 1) begin
		start_stop_counter <= 'd0;
	end	
end
 
// Process 3: state machine
always @(posedge CLK) begin
	case (alarm_state)
	
	// This state is idle, it resets the signals
	st00_idle : begin 
					alarm_state <= st01_set;
					led_out <= 9'b0;
					set_time <= 0;
					set_en <= 0;
					end
	// In this state timer is adjusted
	// Each times set button is pressed counter a is increased by 1
	// Also LED's are switched on
	st01_set :  begin
				   if (set_button_counter == 'd2 && set_time < 'd9) begin
						set_time <= set_time+'d1;
						set_en <= 1;  // This is ann indicator that at least one second is set
						led_out <= {led_out[7:0],1'b1}; // shifting left with 1, i.e. swithcing on the MSB led
					end else if (start_stop_counter == 'd2 && set_en == 1) begin // When start button is pressed state transition occurs
						alarm_state <= st02_start;
						end
				   end
	// In this state alarm clock starts to count down
	st02_start : begin
					if (rem_time == 0 ) begin // When remaining time is zero state becomes alarm state
						alarm_state <= st03_alarm;
					end else if (clk_en == 1) begin // At each time "clk_en" is 1 one switch becomes off
						led_out <= {1'b0, led_out[8:1]}; // shifting right with 0, i.e. swithcing off the MSB led
						end
					end
					
	// In this state alarm procedure is done
	st03_alarm : begin
					if(snooze_button == 0) begin // If snooze_button button is pressed, snooze operation is started
						alarm_state <= st04_snooze_start;
					end else if (start_stop_button == 0 && start_stop_counter == 'd2) begin // If start_stop_button button is pressed, alarm clock is resetted
						alarm_state <= st00_idle;
						end else if (clk_en == 1) begin // At each time "clk_en" is 1 one on-off operation ia performed
						led_out <= ~(led_out); // blinking during alarm
						end
					end
	// In this state snooze parameters are set
	st04_snooze_start :  begin
						alarm_state <= st02_start;
						led_out<= 9'b000011111;
						end
						
	default : begin // optional default case
				 alarm_state <= st00_idle;
				 end
				 
	endcase
end

//Process 4: remaining time setup
// In this process, timing operations are performed
always @(posedge CLK) begin
		if (alarm_state == st01_set) begin
			rem_time <= set_time; // In set state remaming time is assigned as set time
			if (set_button_counter == 'd2 && set_time < 'd9) begin
				ssd_led_out <= ssd_led_out + 1'b1;	// In addition seven segment display values are assigned
			end
		end else if (alarm_state == st02_start ) begin 
				if (clk_en == 1 && rem_time > 'd0 )begin // In alarm state at each time clk_en is 1 and remaining time is greter than zero remaining time is decreased by 1
					rem_time <= rem_time-'d1;
					ssd_led_out <= ssd_led_out - 1'b1;
				end
			end else if (alarm_state == st04_snooze_start) begin // For snoozing remaining time is adjusted
			rem_time <= 'd5;
			ssd_led_out <= 4'b0101;
		end
end


endmodule 

