module crc_activity_filter #(parameter ACT_FILT_W = 16)
        (
            input wire i_clk,
            input wire i_nreset,
            input wire i_crc_req_process_active,
            input wire i_crc_req_done_active,
            input wire i_err_fifo_pop_active,
            output wire o_crc_idle,
            output wire o_activation_pulse
        );
localparam ACT_FILT_W_MAX = 32;

initial begin
    assert (ACT_FILT_W <= ACT_FILT_W_MAX) else $display("ACT_FILT_W larger than 32, which is not allowed");
end

reg crc_idle_q;

reg [ACT_FILT_W-1:0] crc_req_process_active_filtered;
reg [ACT_FILT_W-1:0] crc_req_done_active_filtered;
reg [ACT_FILT_W-1:0] err_fifo_pop_active_filtered;
reg [ACT_FILT_W-1:0] global_active_filtered;

wire crc_req_process_idle;
wire crc_req_done_idle;
wire err_fifo_pop_idle;


always @(posedge i_clk or negedge i_nreset) 
    if(~i_nreset) begin
        crc_req_process_active_filtered <= '0;
    end
    else begin
        crc_req_process_active_filtered <= {crc_req_process_active_filtered[ACT_FILT_W-2:0], i_crc_req_process_active};
    end

assign crc_req_process_idle = ~(|crc_req_process_active_filtered);

always @(posedge i_clk or negedge i_nreset) 
    if(~i_nreset) begin
        crc_req_done_active_filtered <= '0;
    end
    else begin
        crc_req_done_active_filtered <= {crc_req_done_active_filtered[ACT_FILT_W-2:0], i_crc_req_process_active};
    end

assign crc_req_done_idle = ~(|crc_req_done_active_filtered);

always @(posedge i_clk or negedge i_nreset) 
    if(~i_nreset) begin
        err_fifo_pop_active_filtered <= '0;
    end
    else begin
        err_fifo_pop_active_filtered <= {err_fifo_pop_active_filtered[ACT_FILT_W-2:0], i_err_fifo_pop_active};
    end

assign err_fifo_pop_idle = ~(|err_fifo_pop_active_filtered);

assign active_inputs_filtered = ~crc_req_process_idle | ~crc_req_done_idle | ~err_fifo_pop_idle;

always @(posedge i_clk or negedge i_nreset) 
    if(~i_nreset) begin
        global_active_filtered <= '0;
    end
    else begin
        global_active_filtered <= {global_active_filtered[ACT_FILT_W-2:0], active_inputs_filtered};
    end


assign o_crc_idle = ~(|global_active_filtered);


always @(posedge i_clk or negedge i_nreset) 
    if(~i_nreset) begin
        crc_idle_q <= 0;
    end
    else begin
        crc_idle_q <= o_crc_idle;
    end

assign o_activation_pulse = ~o_crc_idle & crc_idle_q;

endmodule
