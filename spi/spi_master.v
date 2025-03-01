`timescale 1ns / 1ps

module spi_master #(
	parameter clkPolarity = 0, // mode 0 (commonly used mode)
	parameter clkPhase = 0,	// mode 0 (commonly used mode)
	parameter clkFrequency  = 100_000_000, // 100 MHz - 10 ns
	parameter spiClkFrequency = 1_000_000 // 1 MHz - 1 ms
)
( 
	input clk_i,
	input en_i, 	
    input miso_i, // slave to master 	
	input [7:0] mosi_data_i, // internal signal for ease of analyse
	output reg [7:0] miso_data_o, // internal signal for ease of analyse
	output reg data_ready_o, 	
	output reg cs_o, // master to slave	, default value is 1
	output reg spiClk_o, // master to slave	
	output reg mosi_o // master to slave			
				
);
  
localparam c_edgecntrlimdiv2 = clkFrequency/(spiClkFrequency*2); // div2 because we need edges not whole cycle

// internal signals 
reg [7:0] write_reg	= 8'b0;	
reg [7:0] read_reg	= 8'b0;	

reg spiClk_en   = 1'b0;
reg spiClk	  = 1'b0;
reg spiClk_preceding = 1'b0;
reg spiClk_rise = 1'b0;
reg spiClk_fall = 1'b0;
 
reg write_new_bit 	= 1'b0;
reg read_new_bit		= 1'b0;

reg [($clog2(c_edgecntrlimdiv2))-1:0] edgecntr = 0; // $clog2() calculates the required bit no to store edgecntr
 
reg [3:0] bit_counter = 0;

localparam READY = 1'b0, SEND = 1'b1; // states
reg state = READY; // default state

localparam zero_zero = 2'd0, zero_one = 2'd1, one_zero = 2'd2, one_one = 2'd3;
reg [1:0] spi_config	= 2'b0;
initial spi_config = {clkPolarity, clkPhase}; // concatanated
 

// generation of internal spiClk signal 
always @(posedge clk_i) begin
 
	if (spiClk_en == 1) begin
		if (edgecntr == c_edgecntrlimdiv2-1) begin
			spiClk 		<= ~spiClk;
			edgecntr	<= 0;
		end else
			edgecntr	<= edgecntr + 1;
	
	end else begin
			edgecntr	<= 0;
			if (clkPolarity == 0) 
				spiClk	<= 0;
			else
				spiClk	<= 1;
		end
end 


//  determination of spiClk rises or falls
 always @(spiClk, spiClk_preceding ) begin
 
	if (spiClk == 1 && spiClk_preceding == 0) 
		spiClk_rise <= 1;
	else
		spiClk_rise <= 0;

	if (spiClk == 0 && spiClk_preceding == 1) 
		spiClk_fall <= 1;
	else
		spiClk_fall <= 0;	
end


// determination of when to write or read bit
 always @(spi_config, spiClk_fall, spiClk_rise) begin
 
	case (spi_config)
 
		zero_zero: begin
 
			write_new_bit   <= spiClk_fall;
			read_new_bit	<= spiClk_rise;
        end 
		
		zero_one: begin
 
			write_new_bit   <= spiClk_rise;
			read_new_bit	<= spiClk_fall;		
        end 
		
		one_zero: begin
 
			write_new_bit   <= spiClk_rise;
			read_new_bit	<= spiClk_fall;			
        end 
		
		one_one: begin
 
			write_new_bit   <= spiClk_fall;
			read_new_bit	<= spiClk_rise;	
        end
 
	endcase
 
end 
 
// MAIN block
 always @(posedge clk_i) begin
 
    data_ready_o <= 0;
	spiClk_preceding	<= spiClk;
 
	case (state)
 	
		READY: begin	
 
			cs_o			<= 1;
			mosi_o			<= 0;
			data_ready_o	<= 0;			
			spiClk_en			<= 0;
			bit_counter			<= 0; 
 
			if (clkPolarity == 0) 
				spiClk_o	<= 0;
			else
				spiClk_o	<= 1;
			
 
			if (en_i == 1) begin
				state		<= SEND;
				spiClk_en		<= 1;
				write_reg	<= mosi_data_i;
				mosi_o		<= mosi_data_i[7];
				read_reg	<= 8'h0;
			end 
        end
			
		SEND: begin		
            spiClk_o <= spiClk;           
			cs_o	<= 0;
			mosi_o	<= write_reg[7];
            
			// clkPhase == 1
			if (clkPhase == 1) begin	
            
				if (bit_counter == 0) begin
				
					if (read_new_bit == 1) begin
						read_reg[0]			<= miso_i;
						read_reg[7:1] 	    <= read_reg[6:0];
						bit_counter				<= bit_counter + 1;
					end 			
				end else if (bit_counter == 8) begin
					
							data_ready_o	<= 1;				      						
						    miso_data_o		<= read_reg;
							state	<= READY;
						    cs_o	<= 1;
							
						if (write_new_bit == 1) begin
							if (en_i == 1) begin
								write_reg	<= mosi_data_i;
								mosi_o		<= mosi_data_i[7];				
								bit_counter		<= 0;
							end else begin
								state	<= READY;
								cs_o	<= 1;								
							    end 
						end 
					end  else begin
						
								if (read_new_bit == 1) begin
									read_reg[0]	 	 <= miso_i;
									read_reg[7:1]    <= read_reg[6:0];
									bit_counter             <= bit_counter + 1;
								end 
								if (write_new_bit == 1) begin
									mosi_o	<= write_reg[7];
									write_reg[7:1] 	<= write_reg[6:0];
								end 
					        end 
            // clkPhase == 0        
			end else begin	
 
					if (bit_counter == 0) begin
									
						if (read_new_bit == 1) begin
							read_reg[0]		<= miso_i;
							read_reg[7:1] 	<= read_reg[6:0];
							bit_counter				<= bit_counter + 1;
						end 
						//buradan
						if (write_new_bit == 1) begin
										write_reg[7:1] 	<= write_reg[6:0];
										mosi_o	<= write_reg[7]; end //buraya kadar
						
					end else if (bit_counter == 8) begin				
								
							    data_ready_o    <= 1; 
							    miso_data_o		<= read_reg;
								if(read_new_bit) state <= READY;
												
							if (write_new_bit == 1) begin
								if (en_i == 1) begin
									//write_reg	<= mosi_data_i;
									//mosi_o		<= mosi_data_i[7];		
									//bit_counter		<= 0;
									state	<= READY;
								end 
																
								if (read_new_bit == 1) begin
									state	<= READY;
									//cs_o	<= 1;							
								end 
							end 		
						end else begin
						
									if (read_new_bit == 1) begin
										read_reg[0]		<= miso_i;
										read_reg[7:1] 	<= read_reg[6:0];
										bit_counter			<= bit_counter + 1;
									end 
									if (write_new_bit == 1) 
										write_reg[7:1] 	<= write_reg[6:0];
										mosi_o	<= write_reg[7];
									 
								end 
				end	
				
		end		
		
	endcase
    
end

 



 
endmodule