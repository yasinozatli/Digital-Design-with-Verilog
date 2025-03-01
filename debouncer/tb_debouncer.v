`timescale 1ns / 1ps


module tb_debouncer();

reg clk, dbInp;
wire dbOut;

debouncer #(.init_val(0)) inst (.clk(clk), .dbInp(dbInp),.dbOut(dbOut));

always begin
 #5 clk = ~clk;
end


initial begin
clk = 0;

#20;
dbInp = 0;
#20
dbInp = 1;
#20;
dbInp = 0;
#20;
dbInp = 1;
#1_500_000;
#20;
dbInp = 0;
#20;
dbInp = 1;
#20;
dbInp = 0;
#1_500_000;
#20;
$finish;

end

endmodule
