`timescale 1ns / 1ps

module uart_tx #(parameter baudrate = 10_000_000) //9600, 19200, 57600, 115200
(input clk, start,
input [7:0] di,
output reg out, done);


localparam IDLE = 2'd0, BE_READY = 2'd1, SEND = 2'd2, DONE = 2'd3;
reg [1:0] state = IDLE;
integer one_bit_time = 100_000_000 / baudrate; //clk is 100MHz. 
integer timer = 0;                   //Clock count for 1 bit to be sent
reg [7:0] shifter;
reg [2:0] num_of_sent_bits = 0;

always @(posedge clk) begin
    case(state)
        IDLE: begin
        
              out <= 1;
              done <= 0;
              num_of_sent_bits <= 0;
             if(start) begin
                 shifter <= di;
                 out <= 0;
                 state <= BE_READY;
              end
  

              end
        BE_READY: if(one_bit_time-1 == timer) begin
                     timer <= 0;
                     shifter <= (shifter >> 1) | (shifter << 7);
                     out <= shifter[0];
                     state <= SEND;
                  end else 
                     timer <= timer +1;
        
        SEND: if(num_of_sent_bits == 7) begin
                 if(one_bit_time-1 == timer) begin
                    timer <= 0;
                    out <= 1;
                    state <= DONE;
                    num_of_sent_bits <= 0;
                 end else
                    timer <= timer +1;
              end else if(one_bit_time-1 == timer) begin
                     timer <= 0;
                     num_of_sent_bits <= num_of_sent_bits +1;
                     out <= shifter[0];
                     shifter <= (shifter >> 1) | (shifter << 7);  
                  end else timer <= timer +1;
                 
        DONE: if(one_bit_time-1 == timer) begin //one_bit_time for 1 stop bit
                 timer <= 0;
                 done <= 1;
                 state <= IDLE;
              end else timer <= timer +1;
                        
        endcase
end
endmodule
