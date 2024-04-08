module crc_req_process
  (
    input wire i_clk,
    input wire i_nreset,
    input wire i_req_valid,
    input wire [CRC_REQ_WITDH-1:0] i_req_data,
    output wire o_req_ready,
    output wire o_crc_params_valid,
    output wire [CRC_PARAM_REQ_WITDH-1:0] o_crc_params_data,
    input wire i_crc_params_ready,
    input wire [15:0] i_cfg_16bit_poly,
    input wire [31:0] i_cfg_32bit_poly,
    input wire [63:0] i_cfg_64bit_poly,
    input wire [31:0] i_cfg_data_ba,
    input wire [31:0] i_cfg_crc_ba,
    input wire [2:0] i_cfg_rpt_num,
    input wire i_outsdand_dec,
    output wire o_no_outstand_cmd
  );
  
  wire req_fifo_push;
  wire req_fifo_pop;
  wire req_fifo_full;
  wire req_fifo_empty;
  crc_req_t req;
  reg crc_params_fifo_push_q;
  
  reg [$clog2(CRC_REQ_MAX_OUTSTAND)-1:0] req_outstand_cnt;
  
  assign o_req_ready = ~req_fifo_full & ~(&req_outstand_cnt);
  
  assign req_fifo_push = i_req_valid & o_req_ready;
  assign req_fifo_pop = crc_params_fifo_push_q; 
 
  
  basic_fifo#($bits(crc_req_t), 1) 
  req_fifo_i (
                      .i_par_fifo_clk(i_clk),
                      .i_par_fifo_reset_b(i_nreset),
                      .i_par_fifo_clr(1'b0),
                      .i_par_fifo_spush(req_fifo_push),
                      .i_par_fifo_swdata(i_req_data),
                      .o_par_fifo_sfull(req_fifo_full),
                      .i_par_fifo_dpop(req_fifo_pop),
    				          .o_par_fifo_drdata(req),    
                      .o_par_fifo_dempty(req_fifo_empty)
  					);
  
  wire crc_params_fifo_push;
  wire crc_params_fifo_pop;
  wire crc_params_fifo_full;
  wire crc_params_fifo_empty;
  crc_param_req_t crc_param_data;
  wire [63:0] crc_params_crc_poly;
  wire [2:0] crc_params_rpt_num;
  
  always @(posedge i_clk or negedge i_nreset)
    if (!i_nreset)
       crc_params_fifo_push_q <= '0;
    else
       crc_params_fifo_push_q <= crc_params_fifo_push;
  
  assign crc_params_crc_poly = (~req.crc_poly_size_sel[0])?{32'h0, i_cfg_32bit_poly}:
    														((~req.crc_poly_size_sel[1])?{48'h0, i_cfg_16bit_poly}:i_cfg_64bit_poly);
  
  assign crc_params_rpt_num = (req.req_rpt_en)?i_cfg_rpt_num:'0;
  
  assign crc_param_data = {
    						crc_params_crc_poly,
 							req.crc_poly_size_sel,
    						{i_cfg_data_ba + req.data_addr_offset},
    						{i_cfg_crc_ba + req.crc_addr_offset},
  							crc_params_rpt_num,
  							req.req_id
  						  };
  
  reg req_fifo_empty_q;
  
  always @(posedge i_clk or negedge i_nreset)
    if (!i_nreset)
       req_fifo_empty_q <= '0;
    else
       req_fifo_empty_q <= req_fifo_empty;
  
  
  assign crc_params_fifo_push_pulse = ~req_fifo_empty & req_fifo_empty_q;
  
  assign crc_params_fifo_push = crc_params_fifo_push_pulse;
  assign crc_params_fifo_pop = o_crc_params_valid & i_crc_params_ready;
  
  basic_fifo#($bits(crc_param_req_t), 1) 
  crc_params_fifo_i (
                        .i_par_fifo_clk(i_clk),
                        .i_par_fifo_reset_b(i_nreset),
                        .i_par_fifo_clr(1'b0),
                        .i_par_fifo_spush(crc_params_fifo_push),
                        .i_par_fifo_swdata(crc_param_data),
                        .o_par_fifo_sfull(crc_params_fifo_full),
                        .i_par_fifo_dpop(crc_params_fifo_pop),
                        .o_par_fifo_drdata(o_crc_params_data),    
                        .o_par_fifo_dempty(crc_params_fifo_empty)
  					);
  
  assign o_crc_params_valid = ~crc_params_fifo_empty;
  
  
  wire outstand_cnt_dec;
  
  assign outstand_cnt_dec = i_outsdand_dec;
  assign o_no_outstand_cmd = ~(|req_outstand_cnt);
  
  always @(posedge i_clk or negedge i_nreset)
    if (!i_nreset)
       req_outstand_cnt <= '0;
  else if(req_fifo_push)
       req_outstand_cnt <= req_outstand_cnt + 1'b1;
  else if(outstand_cnt_dec)
    	req_outstand_cnt <= req_outstand_cnt - 1'b1;
  
endmodule
