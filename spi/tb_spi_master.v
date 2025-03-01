`timescale 1ns / 1ps

module tb_spi_master;

 
reg clk_i;
initial clk_i = 0;
reg en_i;
initial en_i = 0;
reg [7:0] mosi_data_i;
initial mosi_data_i = 8'b0;
reg miso_i;
initial miso_i = 0;


wire [7:0] miso_data_o;
wire data_ready_o;
wire cs_o;
wire spiClk_o;
wire mosi_o;
 
 
reg [7:0] slave_to_master_data;
initial slave_to_master_data = 0;
reg write;
initial write = 0;
reg writeDone; 
initial writeDone = 0; 
 

spi_master #(.clkPolarity(0), .clkPhase(0)) master (.clk_i(clk_i), 
             .en_i(en_i), .miso_i(miso_i), .mosi_data_i(mosi_data_i),
			 .miso_data_o(miso_data_o), .data_ready_o(data_ready_o),
			 .cs_o(cs_o), .spiClk_o(spiClk_o), .mosi_o(mosi_o));

 
always #5 clk_i = ~clk_i;
 
always begin
    
	@(posedge write);
	miso_i = slave_to_master_data[7];
	@(negedge spiClk_o);
	miso_i = slave_to_master_data[6];
	@(negedge spiClk_o); 
	miso_i = slave_to_master_data[5];
	@(negedge spiClk_o); 
	miso_i = slave_to_master_data[4];
	@(negedge spiClk_o); 
	miso_i = slave_to_master_data[3];
	@(negedge spiClk_o); 
	miso_i = slave_to_master_data[2];
	@(negedge spiClk_o); 
	miso_i = slave_to_master_data[1];
	@(negedge spiClk_o); 
	miso_i = slave_to_master_data[0];

	writeDone    = 1;
	 #1;
	writeDone    = 0;
 
end 
 

initial begin		
  
    #200;
	en_i 		= 1;  
 
	// write 0xA7, read 0xB2
	mosi_data_i	= 8'hB6;
	@(negedge cs_o);
	slave_to_master_data   = 8'hA1;
	write    = 1;
	@(negedge writeDone);
	write    = 0;
 
	// write 0xB8, read 0xC3
	@(posedge data_ready_o);
	mosi_data_i	= 8'hA2;	
	@(negedge spiClk_o);
	slave_to_master_data   = 8'hC4;
	write    = 1;
	@(posedge writeDone);
	write    = 0;
	en_i 		= 0;  

    #10000;
 
	$finish;
	
end 
 
endmodule