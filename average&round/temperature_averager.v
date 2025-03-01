`timescale 1ns / 1ps



module temp_avg(
    input clk,
    input rst,
    input shift_en,
    input signed [9:0] tempvalue, 
    output reg signed [9:0] truncated
    );
    
    reg signed [9:0] Ra; 
    reg signed [9:0] Rb; 
    reg signed [9:0] Rc; 
    reg signed [9:0] Rd; 
    
    reg signed [11:0] sum; 
    reg signed [9:0] average; 
    reg signed [10:0] rounded;  
    
    always@(posedge clk) begin
        if(rst == 1'b1) begin
            Ra <= {10{1'b0}};
            Rb <= {10{1'b0}};
            Rc <= {10{1'b0}};
            Rd <= {10{1'b0}};
            average <= 'd0;
            truncated <='d0;
        end else begin
            Rd <= Rc;
            Rc <= Rb;
            Rb <= Ra;
            Ra <= tempvalue;
        end
    end
    
    
    
    always@(*) begin
        if(shift_en == 1'b1) begin
        
            sum = Ra+ Rb + Rc+ Rd;        
            average = sum >>> 2;
            rounded = {average[9],(average + average[0])};
            
            
        end else begin
            average = average;
        end
    end
    
   always@(posedge clk) begin
      truncated = rounded[10:1];
    end
endmodule