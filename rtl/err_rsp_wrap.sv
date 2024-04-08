module err_rsp_wrap (
	input wire i_clk,
    input wire i_nreset,
    input wire i_fifo_push,
    input wire i_fifo_pop,
    output wire o_fw_rd_done,
    input wire [CRC_PARAM_RSP_WITDH-1:0] i_err_rsp_data,
    output wire [CRC_PARAM_RSP_WITDH-1:0] o_err_rd_data,
    /*Add FW read IF*/
    output wire o_fifo_full,
    output wire o_fifo_empty,
    output wire o_fifo_almost_full
);

wire err_rsp_fifo_pop;
wire err_rsp_fifo_empty;
wire err_rsp_fifo_full;
wire err_rsp_fifo_almost_full;

assign err_rsp_fifo_pop = i_fifo_pop;

basic_fifo#($bits(crc_param_rsp_t), CRC_REQ_MAX_OUTSTAND) 
  err_rsp_fifo_i (
                      .i_par_fifo_clk(i_clk),
                      .i_par_fifo_reset_b(i_nreset),
                      .i_par_fifo_clr(1'b0),
                      .i_par_fifo_spush(i_fifo_push),
                      .i_par_fifo_swdata(i_err_rsp_data),
                      .o_par_fifo_sfull(err_rsp_fifo_full),
                      .o_par_fifo_sfull_next(err_rsp_fifo_almost_full),
                      .i_par_fifo_dpop(err_rsp_fifo_pop),
                      .o_par_fifo_drdata(o_err_rd_data),    
                      .o_par_fifo_dempty(err_rsp_fifo_empty)
                    );

assign o_fifo_full = err_rsp_fifo_full;
assign o_fifo_empty = err_rsp_fifo_empty;
assign o_fw_rd_done = err_rsp_fifo_pop;

assign o_fifo_almost_full = 0;

endmodule
