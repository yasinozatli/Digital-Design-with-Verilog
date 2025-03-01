`timescale 1ns / 1ps

module tb_week66();
    reg clk;
    reg rst;
    reg [31:0] seed;
    reg ld_en;
    reg shift_en;
    wire [31:0]lfsr_out; //1bite d ? r



    integer i, fileout;

    week6_exc3 uut (
        .clk(clk),
        .rst(rst),
        .seed(seed),
        .ld_en(ld_en),
        .shift_en(shift_en),
        .lfsr_out(lfsr_out)
    );


always #10 clk = ~clk;
    initial begin
        fileout = $fopen("vivad2.txt", "w");
        clk = 1;
        seed =32'h00003039;
        ld_en = 1;
        shift_en = 0;
        rst = 0; 
        #20;
        ld_en = 0;
        shift_en = 1;
        #20;

        for(i=0;i<200;i=i+1)begin
           
           
           @(posedge clk)
              $fwrite(fileout,"%032b\n", lfsr_out);
        end
     $fclose(fileout);
     $finish;
     end



endmodule