`timescale 1ns / 1ps

module tb_uart_tx();

reg clk = 0, start;
reg [7:0] di;
wire out, done;
always #5 clk = ~clk;

uart_tx inst_uart (.clk(clk), .start(start), .di(di), .out(out), .done(done));

initial begin
    di <= 8'b00000000;
    start <= 0;
    #10;
    start <= 1;
    di <= 8'b00110011;
    #10;
    start <= 0;
    @(posedge done)
    #20;
    start <= 1;
    di <= 8'b11100011;
    #10;
    start <= 0;
    //#1500;
    //$finish;
    @(posedge done) 
    #50 $finish;
   
end
endmodule
