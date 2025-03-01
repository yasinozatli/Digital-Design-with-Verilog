`timescale 1ns / 1ps

module tb();

reg clk, rst;
reg start_sort;
wire done; 
top_sort topsort(.clk(clk), .start_sort(start_sort), .done(done), .rst(rst)); 

initial begin
clk = 1;
forever #5 clk = ~clk;
end

    initial begin
        rst =1;
        #20;
        rst =0;
        #10;
      //  #25;
    start_sort = 1; 
    #10;
    start_sort =0;      
        
        @(posedge done) $finish;
    end

endmodule
