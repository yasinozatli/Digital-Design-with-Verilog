 `timescale 1 ns / 1 ps
 module debouncer #(parameter init_val = 0)(input clk, dbInp, output reg dbOut);
 localparam [2:0] IDLE = 3'b000, BTN0=3'b001, ZERO_SWITCH_ONE=3'b010, BTN1=3'b011, ONE_SWITCH_ZERO=3'b100;
 
 reg [19:0] timer;
 reg ms1tick;
 reg timer_en;
 reg [2:0] p_state;

 initial p_state <= IDLE;
 
 always @(posedge clk) begin

 case(p_state)
 IDLE: begin
          if(init_val) p_state = BTN1;
          else p_state = BTN0;
          end
 BTN0: begin 
       dbOut = 0;
       if (dbInp) p_state <= ZERO_SWITCH_ONE;
       end
 ZERO_SWITCH_ONE: begin
              timer_en <= 1;
              if(ms1tick) begin
                   p_state <= BTN1;
                   timer_en <= 0;
                   dbOut <=1;
                   end
              if(dbInp == 0) begin
                   p_state <= BTN0;
                   timer_en <= 0;
                   end
              end
       
 ONE_SWITCH_ZERO: begin
              timer_en <= 1;             
              if(ms1tick)begin
                   p_state <= BTN0;
                   timer_en <= 0;
                   dbOut <= 0;
                   end
                   
              if(dbInp == 1) begin
                   p_state <= BTN1;
                   timer_en <= 0;
                   end
              end
                   
 BTN1: begin
       dbOut = 1;
       if (~dbInp) p_state = ONE_SWITCH_ZERO; 
       end
 endcase
 end
 
 always @ (posedge clk) // counter state memory
 if (timer_en) begin
               if(timer == 99999) begin
                   ms1tick <= 1;
                   timer <=0; 
                   timer_en <= 0;            
               end else begin
                   ms1tick <=0;
                   timer <= timer +1;
               end
  end  else begin
        ms1tick <=0;
        timer <=0;
       end
 
 endmodule
