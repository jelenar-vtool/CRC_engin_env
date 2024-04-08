// Code your design here
`include "crc_sequencer_pkg.sv"
`include "basic_fifo.v"
`include "err_rsp_wrap.sv"
`include "crc_req_process.sv"
`include "watchdog_timer.sv"
`include "activity_filter.sv"
`include "crc_reg_wrap.sv"

module crc_sequencer (
                        input wire i_clk,
                        input wire i_nreset,
                        
                        input wire i_reg_apb_psel,
                        input wire i_reg_apb_penable,
                        input wire i_reg_apb_pwrite,
                        input wire [9:0] i_reg_apb_paddr,
                        input wire [31:0] i_reg_apb_pwdata,                         
                        output wire o_reg_apb_pready,
                        output wire [31:0] o_reg_apb_prdata,
  
                        input wire i_crc_req_valid,
                        input wire [CRC_REQ_WITDH-1:0] i_crc_req_data,
                        output wire o_crc_req_ready,
  
                        input wire i_crc_done_ready,
                        output wire [CRC_RSP_WITDH-1:0] o_crc_done_data,
                        output wire o_crc_done_valid,
  
                        input wire i_crc_param_done_valid,
                        input wire [CRC_PARAM_RSP_WITDH-1:0] i_crc_param_done_data,
                        output wire o_crc_param_done_ready,  
                        
                        output wire o_crc_param_valid,
                        output wire [CRC_PARAM_REQ_WITDH-1:0] o_crc_param_data,                         
                        input wire i_crc_param_ready,
  
                        output wire o_int
                    );
  
    crc_req_t crc_req;
    wire wdt_ovf_int;
    wire crc_req_process_active;
    wire fw_err_rsp_fifo_rd_done;

    //CRC IN FIFO  

    wire crc_req_in_fifo_push;
    wire crc_req_in_fifo_pop;
    wire crc_req_in_fifo_full;
    wire crc_req_in_fifo_empty;
    wire crc_req_valid;
    wire crc_req_ready;

    assign o_crc_req_ready = ~crc_req_in_fifo_full;

    assign crc_req_in_fifo_push = i_crc_req_valid & o_crc_req_ready;
    assign crc_req_in_fifo_pop = crc_req_valid & crc_req_ready;
  
    basic_fifo#($bits(crc_req_t), 8) 
      crc_req_in_fifo_i (
                          .i_par_fifo_clk(i_clk),
                          .i_par_fifo_reset_b(i_nreset),
                          .i_par_fifo_clr(1'b0),
                          .i_par_fifo_spush(crc_req_in_fifo_push),
                          .i_par_fifo_swdata(i_crc_req_data),
                          .o_par_fifo_sfull(crc_req_in_fifo_full),
                          .i_par_fifo_dpop(crc_req_in_fifo_pop),
                          .o_par_fifo_drdata(crc_req),    
                          .o_par_fifo_dempty(crc_req_in_fifo_empty)
                        );  

  
    assign crc_req_valid = ~crc_req_in_fifo_empty;

    wire outstand_dec;
    wire no_outstand_cmd;

    wire [15:0] cfg_16bit_poly;
    wire [31:0] cfg_32bit_poly;
    wire [31:0] cfg_64bit_poly_l;
    wire [31:0] cfg_64bit_poly_h;
    wire [63:0] cfg_64bit_poly;
    wire [31:0] cfg_data_ba;
    wire [31:0] cfg_crc_ba;
    wire [2:0] cfg_rpt_num;

    assign cfg_64bit_poly = {cfg_64bit_poly_h, cfg_64bit_poly_l};

    crc_req_process
        crc_req_process_i (
            .i_clk(i_clk),
            .i_nreset(i_nreset),
            .i_req_valid(crc_req_valid),
            .i_req_data(crc_req),
            .o_req_ready(crc_req_ready),
            .o_crc_params_valid(o_crc_param_valid),
            .o_crc_params_data(o_crc_param_data),
            .i_crc_params_ready(i_crc_param_ready),
            .i_cfg_16bit_poly(cfg_16bit_poly),
            .i_cfg_32bit_poly(cfg_32bit_poly),
            .i_cfg_64bit_poly(cfg_64bit_poly),
            .i_cfg_data_ba(cfg_data_ba),
            .i_cfg_crc_ba(cfg_crc_ba),
            .i_cfg_rpt_num(cfg_rpt_num),
            .i_outsdand_dec(outstand_dec),
            .o_no_outstand_cmd(no_outstand_cmd)
        );

    assign crc_req_process_active = o_crc_param_valid & i_crc_param_ready;
  
  ///////////// hardwired crc_param_rsp with crc_rsp valid ready. TODO: Add fifos //////////////////////////

    wire crc_rsp_fifo_push;
    wire crc_rsp_fifo_pop;
    wire crc_rsp_fifo_full;
    wire crc_rsp_fifo_empty;
    crc_param_rsp_t crc_param_rsp_data;
    crc_rsp_t crc_rsp_fifo_data;
    wire rsp_push;
    wire rpt_fifo_push_en;
    wire err_rsp_fifo_full;
    wire err_rsp_fifo_empty;
    wire err_rsp_fifo_push;
    wire err_rsp_fifo_pop;

    assign crc_param_rsp_data = i_crc_param_done_data;

    assign rsp_push = i_crc_param_done_valid & o_crc_param_done_ready;
    assign rpt_fifo_push_en = |crc_param_rsp_data.rsp_code & |crc_param_rsp_data.crc_param_req.rpt_num;

    assign o_crc_param_done_ready = (rpt_fifo_push_en)?~err_rsp_fifo_full:~crc_rsp_fifo_full;
    assign o_crc_done_valid = ~crc_rsp_fifo_empty;  

    assign crc_rsp_fifo_data = {crc_param_rsp_data.rsp_code, crc_param_rsp_data.crc_param_req.req_id};

    assign crc_rsp_fifo_push = rsp_push & ~rpt_fifo_push_en;
    assign crc_rsp_fifo_pop = o_crc_done_valid & i_crc_done_ready;

    basic_fifo#($bits(crc_rsp_t), 8) 
    crc_rsp_fifo_i (
                      .i_par_fifo_clk(i_clk),
                      .i_par_fifo_reset_b(i_nreset),
                      .i_par_fifo_clr(1'b0),
                      .i_par_fifo_spush(crc_rsp_fifo_push),
                      .i_par_fifo_swdata(crc_rsp_fifo_data),
                      .o_par_fifo_sfull(crc_rsp_fifo_full),
                      .i_par_fifo_dpop(crc_rsp_fifo_pop),
                      .o_par_fifo_drdata(o_crc_done_data),    
                      .o_par_fifo_dempty(crc_rsp_fifo_empty)
                    );
  
    assign outstand_dec = crc_rsp_fifo_push;

    crc_param_rsp_t err_fifo_rd_data;

    assign err_rsp_fifo_push = rsp_push & rpt_fifo_push_en;

    err_rsp_wrap err_rsp_wrap_i (
                .i_clk(i_clk),
                .i_nreset(i_nreset),
                .i_fifo_push(err_rsp_fifo_push),
                .i_fifo_pop(err_rsp_fifo_pop),
                .o_fw_rd_done(fw_err_rsp_fifo_rd_done),
                .i_err_rsp_data(crc_param_rsp_data),
                .o_err_rd_data(err_fifo_rd_data),
                .o_fifo_full(err_rsp_fifo_full),
                .o_fifo_empty(err_rsp_fifo_empty),
                .o_fifo_almost_full(err_rsp_fifo_almost_full)
    );

    wire wdt_cnt_en;
    wire wdt_cnt_clear;
    wire [CRC_WD_CNT_W-1:0] cfg_wdt_init_val;
    wire crc_idle_filtered;
    wire crc_active_pulse;
    wire cfg_wdt_enable;
    wire fw_clear_signal;
    wire err_fifo_pop_valid;
  
    assign wdt_cnt_en = ~no_outstand_cmd & crc_idle_filtered & cfg_wdt_enable;
    assign wdt_cnt_clear = crc_active_pulse | fw_clear_signal;

    // assign cfg_wdt_init_val = CRC_WD_CNT_W'(100);//TODO: Connect signal to apb_reg_inst

    watchdog_timer#(CRC_WD_CNT_W) watchdog_timer_i 
        (
            .i_clk(i_clk),
            .i_reset_n(i_nreset),
            .i_en(wdt_cnt_en),       
            .i_clear(wdt_cnt_clear),
            .i_val(cfg_wdt_init_val),
            .o_interupt(wdt_ovf_int)
        );


    crc_activity_filter#() crc_activity_filter_i
        (
            .i_clk(i_clk),
            .i_nreset(i_nreset),
            .i_crc_req_process_active(crc_req_process_active),
            .i_crc_req_done_active(rsp_push),
            .i_err_fifo_pop_active(fw_err_rsp_fifo_rd_done),
            .o_crc_idle(crc_idle_filtered),
            .o_activation_pulse(crc_active_pulse)
        );

    wire [7:0] err_rsp_code;
    wire [31:0] data0_poly_lsb;
    wire [31:0] data1_poly_msb;
    wire [31:0] data2_data_addr;
    wire [31:0] data3_crc_addr;
    wire [15:0] data4_crc_req_id;
    wire [1:0] data4_crc_poly_size_sel;
    wire [2:0] data4_crc_rpt_num;

    assign err_rsp_code = err_fifo_rd_data.rsp_code;
    assign data0_poly_lsb = err_fifo_rd_data.crc_param_req.crc_poly[31:0];
    assign data1_poly_msb = err_fifo_rd_data.crc_param_req.crc_poly[63:32];
    assign data2_data_addr = err_fifo_rd_data.crc_param_req.data_addr;
    assign data3_crc_addr = err_fifo_rd_data.crc_param_req.crc_addr;
    assign data4_crc_req_id = err_fifo_rd_data.crc_param_req.req_id;
    assign data4_crc_poly_size_sel = err_fifo_rd_data.crc_param_req.crc_poly_size_sel;
    assign data4_crc_rpt_num = err_fifo_rd_data.crc_param_req.rpt_num;

    assign err_fifo_pop_valid = ~err_rsp_fifo_empty;

    crc_reg_wrap crc_reg_wrap_i
    (
        .i_sys_clk(i_clk),
        .i_sys_arstn(i_nreset),
        ////////////////////////////////////
        .o_crc_gen_ctrl_rpt_num(cfg_rpt_num),        
        .o_crc_gen_poly_16_val(cfg_16bit_poly),       
        .o_crc_gen_poly_32_val(cfg_32bit_poly),     
        .o_crc_gen_poly_64l_val(cfg_64bit_poly_l),     
        .o_crc_gen_poly_64h_val(cfg_64bit_poly_h),
        ////////////////////////////////////   
        .o_crc_gen_wdt_ctrl_wdt_init_cnt(cfg_wdt_init_val),
        .o_crc_gen_wdt_ctrl_wdt_en(cfg_wdt_enable),
        .o_crc_gen_wdt_ctrl_wdt_fw_clr(fw_clear_signal),
        ////////////////////////////////////    
        .i_crc_err_fifo_pop_err_rsp_code_next(err_rsp_code),
        .i_crc_err_fifo_pop_valid_wr_enable(err_fifo_pop_valid),
        .o_crc_err_fifo_pop_pop(err_rsp_fifo_pop),
        ////////////////////////////////////
        .i_crc_err_fifo_data0_poly_lsb_next(data0_poly_lsb),
        ////////////////////////////////////
        .i_crc_err_fifo_data1_poly_msb_next(data1_poly_msb),
        ////////////////////////////////////
        .i_crc_err_fifo_data2_data_addr_next(data2_data_addr),
        ////////////////////////////////////
        .i_crc_err_fifo_data3_crc_addr_next(data3_crc_addr),
        ////////////////////////////////////
        .i_crc_err_fifo_data4_crc_poly_size_sel_next(data4_crc_poly_size_sel),
        ////////////////////////////////////
        .i_crc_err_fifo_data4_crc_rpt_num_next(data4_crc_rpt_num),
        ////////////////////////////////////
        .i_crc_err_fifo_data4_crc_req_id_next(data4_crc_req_id),
        ////////////////////////////////////
        .i_wdt_int_lvl(wdt_ovf_int),
        .i_crc_err_rsp_full_int_lvl(err_rsp_fifo_full),
        .o_int(o_int),
        ////////////////////////////////////
        .o_crc_gen_data_ba_addr(cfg_data_ba),
        .o_crc_gen_crc_ba_addr(cfg_crc_ba),
        ////////////////////////////////////
        .i_apb_sel(i_reg_apb_psel),
        .i_apb_enable(i_reg_apb_penable),
        .i_apb_write(i_reg_apb_pwrite),
        .i_apb_addr(i_reg_apb_paddr[9:2]),
        .o_apb_rdata(o_reg_apb_prdata),
        .i_apb_wdata(i_reg_apb_pwdata)
    );

    assign o_reg_apb_pready = 1'b1;  
  
endmodule
