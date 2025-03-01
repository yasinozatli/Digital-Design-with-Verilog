`timescale 1ns / 1ps

module uart_rx #(parameter baudrate = 1000_000)//9600, 19200, 57600, 115200
(input clk, di,
 output [7:0] do,
 output reg done);
 
localparam IDLE = 2'd0, BE_READY = 2'd1, RECV = 2'd2, DONE = 2'd3;
reg [1:0] state = IDLE;
integer one_bit_time = 100_000_000 / baudrate; //clk is 100MHz. needed limit of clk count to send 1 bit
integer timer = 0;                   //Counter to send 1 bit 
reg [7:0] shifter;
reg [2:0] num_of_sent_bits = 0;

assign do = shifter;

always @(posedge clk) begin

   case(state)

      IDLE: begin
         if (0 == di) state <= BE_READY;
         timer <= 0;
         done <= 0;
      end
      
      BE_READY: begin
         if(((one_bit_time/2)-1) == timer) begin //wait until the middle of the low part of clock
            timer <= 0;
            state <= RECV;
         end else 
            timer <= timer + 1;
      end
      
      RECV: begin  
         if(one_bit_time-1 == timer) begin
            timer <= 0;
            shifter <= {di, shifter[7:1]};
            if(num_of_sent_bits == 7) begin
               num_of_sent_bits <= 0;
               state <= DONE;
            end else
               num_of_sent_bits <= num_of_sent_bits + 1;          
         end else
            timer <= timer + 1;
      end
      
      DONE: begin
         if(one_bit_time-1 == timer) begin
            done <= 1;
            state <= IDLE;
            timer <= 0;
         end else
            timer <= timer + 1;
      end
   endcase
end
endmodule
