
`timescale 1ns / 1ps

module tb_temp_avg;

  // Declare signals
  reg clk;
  reg rst;
  reg shift_en;
  reg signed [9:0] tempvalue;
  reg signed [9:0] numbers [0:6];
  wire signed [9:0] truncated;
  integer i,f;
  
  // Instantiate the temperature_average module
  temp_avg uut (
    .clk(clk),
    .rst(rst),
    .shift_en(shift_en),
    .tempvalue(tempvalue),
    .truncated(truncated)
  );
    always #10 clk = ~clk;
    always #10 shift_en = ~shift_en;

  
  // Initial block to initialize inputs
  initial begin
  
   numbers[0] = -262;                                               
   numbers[1] = 121;
   numbers[2] = 68;
   numbers[3] = 367;
   numbers[4] = -84;
   numbers[5] = 165;
   numbers[6] = 30;
   
  f = $fopen("temp.txt","w");
    clk=1;
    shift_en = 0;
    rst = 1;
    #20;
    // Apply reset
    rst = 0;
    
    for(i=0; i<7; i=i+1)begin
    @(posedge clk)
    tempvalue = numbers[i];
    $fwrite(f,"%b\n",truncated);
    end
    
    $fclose(f);
    #100;
    $finish;
    end
    
endmodule