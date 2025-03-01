`timescale 1ns / 1ps

module week6_exc3(
    input clk,
    input rst,
    input ld_en,
    input shift_en,
    input [31:0] seed,
    output [31:0] lfsr_out
);

    genvar i;

    // Generate block to instantiate the LFSR module 32 times
    generate
        for (i = 0; i < 32; i = i + 1) begin : lfsr_instances
            
            week6_exerc lfsr_inst (
                .clk(clk),
                .rst(rst),
                .ld_en(ld_en),
                .shift_en(shift_en),
                .seed(seed*(i+1)),       // Connect each bit of the seed
                .lfsr_out(lfsr_out[i]) // Connect each output bit
            );
        end
    endgenerate

endmodule
