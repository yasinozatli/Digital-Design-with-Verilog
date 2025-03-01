`timescale 1ns / 1ps

module tb_seq101det();

    reg clk, data_inp, rst;
    wire out;

    seq101det uut (.clk(clk), .data_in(data_inp), .rstn(rst), .data_out(out));

    always #5 clk = ~clk;
    
    initial begin
    
    clk = 0;
    rst = 0;
    #10
rst =1;
#10
data_inp =0;
#10;
data_inp =1;
#10;
data_inp =1;
#10;
data_inp =0;
#10;
data_inp =0;
#10;
data_inp =1;
#10;
data_inp =0;
#10;
data_inp =1; //
#10;
data_inp =1;
#10;
data_inp =0;
#10;
data_inp =1; 
#10;
data_inp =0;
#10;
data_inp =0;
#10;
data_inp =1;
#10;
data_inp =0;
#10;
data_inp =1;
#20;
$finish;


    end 
  
endmodule
