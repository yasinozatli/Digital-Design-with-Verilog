`timescale 1ns / 1ps

module tb_uart_rx();

reg clk=1, di = 1;
//reg di = 0;
wire [7:0] do;

reg [9:0] test_inp_1 = {1'b1, 8'b0010_0010, 1'b0};//hex 22
reg [9:0] test_inp_2 = {1'b1, 8'b1000_0111, 1'b0};//hex87
// LSB is 0(signaling start), middle 8 bit paylod, MSB (1) is stop bit

always #5 clk <= ~clk;
uart_rx dut (.clk(clk), .di(di), .do(do), .done(done));

integer i;// for loop
initial begin
   #20;
   for(i=0; i<10; i = i+1) begin
     di <= test_inp_1[i]; 
     #1000;// 1000 * 1ns = 1 microsecond is period of the transfer 1 bit
   end
   
   #20;
   for(i=0; i<10; i = i+1) begin
     di <= test_inp_2[i]; 
     #1000;// 1000 * 1ns = 1 microsecond is period of the transfer 1 bit
   end
      $display("Simulation time: %t ns", $time);
      #1000 
      $display("Simulation time: %t ns", $time);
      $finish; 
end

endmodule
