`timescale 1 ns / 1 ps

module design3_tb();


reg clk, fill, consume;
wire error;
wire [7:0] height;

design3 dut (.clk(clk), .fill(fill), .consume(consume), .error(error),.height(height));


initial begin
  clk = 0;
  fill = 0;
  consume = 0;
end
// Clock setup                
always begin
  clk <= 0; #5 ;  clk <= 1; #5 ;
end
always begin
  #10;
  fill <= 0;
  consume <= 0;
  #10;
  fill <=1;
  consume <=0;
  #10;
  fill <=1;
  consume <=1;
  #10
  fill <=1;
  consume <=0;
  #10
  fill <=1;
  consume <=0;
  #10
  fill <=1;
  consume <=0;
  #10
  fill <= 0;
  consume <= 1;
  #10
  fill <=1;
  consume <=0;
  #10
  fill <=1;
  consume <=0;
  #10
  fill <=1;
  consume <=0;
  #10
  fill <=1;
  consume <=0;
  #10;
  
end

endmodule