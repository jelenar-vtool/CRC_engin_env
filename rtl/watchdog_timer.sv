module watchdog_timer #(parameter WD_CNT_W = 16) ( 
                            input wire                  i_clk,
                            input wire                  i_reset_n,
                            input wire                  i_en,       
                            input wire                  i_clear,
                            input wire [WD_CNT_W-1:0]   i_val,
                            output wire                 o_interupt
                        );

    reg           interupt;
    reg [15:0]    cnt; 
    reg           en_q;
    wire          enable_set;
    wire          cnt_underflow_pulse;
  
    always @(posedge i_clk or negedge i_reset_n) 
        if(~i_reset_n) begin
            cnt <= '1;
        end
        else begin
            if(enable_set | i_clear) begin
                cnt <= i_val;
            end
            else if(i_en) begin
                cnt <= cnt - 1;
            end     
        end

    always @(posedge i_clk or negedge i_reset_n) 
        if(~i_reset_n) begin
            interupt <= 0;
        end
        else begin
            if(i_clear) begin
                interupt <= 1'b0;
            end
            else if(cnt_underflow_pulse) begin
                interupt <= 1'b1;
            end
        end
  
    assign o_interupt = interupt;

    always @(posedge i_clk or negedge i_reset_n) 
        if(~i_reset_n) begin
            en_q <= 0;
        end
        else begin
            en_q <= i_en;
        end

    assign enable_set = i_en & ~en_q;

    assign cnt_underflow_pulse = ~(|cnt);  
  
endmodule
