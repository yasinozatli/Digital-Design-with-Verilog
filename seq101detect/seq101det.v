`timescale 1ns / 1ps
module seq101det(
    input clk, data_in, rstn,
    output reg data_out
    );
    
localparam [1:0] S0 = 2'b00, S1 = 2'b01, S10 = 2'b10, S101 = 2'b11;

reg [1:0] p_state, n_state;

always @(posedge clk) begin
    if(!rstn) p_state <= S0;
    else p_state <= n_state;
    end
    
always @(data_in, p_state) begin
    n_state = p_state;
    data_out = 0;
    case(p_state)
        S0:   if(data_in == 1) n_state = S1;
        S1:   if(data_in == 0) n_state = S10;
        S10:  if(data_in == 1) n_state = S101;
              else n_state = S0;
        S101: begin
              if(data_in == 1) n_state = S1;
              else n_state = S10;
              data_out = 1;
              end
    endcase
end    
endmodule
