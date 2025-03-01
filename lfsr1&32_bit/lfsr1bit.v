`timescale 1ns / 1ps

module week6_exerc(
    input clk,
    input rst,
    input ld_en,
    input shift_en,
    input [31:0] seed,
    output  lfsr_out
    );

    wire feedback;
    reg [31:0] lfsr_reg;



    always@(posedge clk) begin
        if (rst) begin
            lfsr_reg <= {32{1'b0}};
        end
           else begin
            if(ld_en)begin
                lfsr_reg<=seed;
            end
            else if(shift_en) begin 
                lfsr_reg<={feedback,lfsr_reg[31:1]};
            end         
        end
    end

    assign    feedback=lfsr_reg[31]^(lfsr_reg[30]^(lfsr_reg[11]^lfsr_reg[0]));
    assign    lfsr_out=lfsr_reg[0];


endmodule