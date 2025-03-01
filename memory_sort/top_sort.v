module top_sort (
    input wire clk, rst,
    input wire start_sort,       
    output reg done              
);
    parameter ADDR_WIDTH = 3;    
    parameter DATA_WIDTH = 4;    

    reg [ADDR_WIDTH:0] addr = 0, count = 0;        
    reg [DATA_WIDTH-1:0] data_a, data_b;  
    reg we = 0;                          
    reg [ADDR_WIDTH-1:0] sort_index; 
                   
   // reg [DATA_WIDTH-1:0] ram [0:7];  
    reg [DATA_WIDTH-1:0] temp;       
    reg [3:0] di; 
    wire [3:0] do;
    reg [2:0] state; 
    bram  #(.ADDR_WIDTH(ADDR_WIDTH),.DATA_WIDTH(DATA_WIDTH)) bram(.we(we), .clk(clk), .addr(addr), .di(di),.do(do));

    localparam IDLE        = 4'd0;
    localparam LOAD_A      = 4'd1;
    localparam READ_A      = 4'd2;
    localparam LOAD_B      = 4'd3;
    localparam READ_B      = 4'd4;
    localparam COMPARE     = 4'd5;
    localparam WRITE_SMALL = 4'd6;
    localparam WRITE_BIG   = 4'd7;
    
    
    always @(posedge clk) begin
        if(rst) state <= IDLE;     
        case (state)
                      
            IDLE: begin
                if (start_sort) begin
                    sort_index <= 0;
                    done <= 0;
                    state <= LOAD_A;
                    we <= 0;
                    addr <= 0;
                end
            end
            
            LOAD_A: begin
            if(sort_index == 7) begin
            done <= 1;
            state <= IDLE;
            end else 
            state <= READ_A;     
            end
            
            READ_A: begin
                data_a <= do;
                addr <= addr + 1; 
                state <= LOAD_B;   
                if (addr == 7) begin
                 addr <= 0;              
                 sort_index <= sort_index + 1;
                 state <= LOAD_A;
                 end         
            end
            
            LOAD_B: begin
            state <= READ_B;
            end
            
            READ_B: begin
                data_b <= do;   
                state <= COMPARE;                  
            end
            
            COMPARE: begin
                if (data_a > data_b) begin
                    temp <= data_a;                                 
                    state <= WRITE_SMALL;
                    di <= data_b;
                    addr <= addr - 1;
                    we <= 1; 
                    
                end  else begin
                    state <= LOAD_A; 
                    we <= 0;
                    //addr <= addr + 1;
                    end
                
            end
            
            WRITE_SMALL: begin       
            di <= temp;
            addr <= addr +1; 
            state <= WRITE_BIG;      
           end           
           
           WRITE_BIG: begin
           di <= temp;
           we <= 0;
                if (addr == 7) begin
                    addr <= 0; 
                    data_a <= 0;
                    data_b <= 0;
                    temp <= 0;             
                    sort_index <= sort_index + 1;
        
                    if (sort_index == 7) begin
                        done <= 1;
                        state <= IDLE;
                    end else begin
                        state <= LOAD_A;
                    end
                end else begin
                    state <= LOAD_A;
                end
            end
               
        endcase
    end
endmodule
