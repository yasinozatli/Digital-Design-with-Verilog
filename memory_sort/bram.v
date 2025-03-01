`timescale 1ns / 1ps

module bram #(
    parameter ADDR_WIDTH = 3,    
    parameter DATA_WIDTH = 4     
)(
    input clk, we,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] di,
    output reg [DATA_WIDTH-1:0] do );
    
    reg [3:0] bram [0:7];
    
    initial begin
        $readmemb ("C:/Users/yasin/Desktop/new.txt", bram);
    end
    
    always @(posedge clk) begin
    
        if (we)
            bram[addr] <= di;
        else
            do <= bram[addr];
    end
endmodule
