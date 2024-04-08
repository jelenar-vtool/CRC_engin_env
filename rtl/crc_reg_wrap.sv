`include "crc_gen_regs_apb_slave.v"

module crc_reg_wrap (
	input                                 i_sys_clk,
	input                                 i_sys_arstn,

	output [2:0]                          o_crc_gen_ctrl_rpt_num,

	
	output [15:0]                         o_crc_gen_poly_16_val,

	// Register: CRC_GEN_POLY_32
	// Field: VAL
	output [31:0]                         o_crc_gen_poly_32_val,

	// Register: CRC_GEN_POLY_64L
	// Field: VAL
	output [31:0]                         o_crc_gen_poly_64l_val,

	// Register: CRC_GEN_POLY_64H
	// Field: VAL
	output [31:0]                         o_crc_gen_poly_64h_val,

	// Register: CRC_GEN_WDT_CTRL
	// Field: WDT_INIT_CNT
	output [15:0]                         o_crc_gen_wdt_ctrl_wdt_init_cnt,
	// Field: WDT_EN
	output                                o_crc_gen_wdt_ctrl_wdt_en,
	// Field: WDT_FW_CLR
	output                                o_crc_gen_wdt_ctrl_wdt_fw_clr,

	// Register: CRC_ERR_FIFO_POP
	// Field: ERR_RSP_CODE
	input  [7:0]                          i_crc_err_fifo_pop_err_rsp_code_next,
	// Field: VALID
	input                                 i_crc_err_fifo_pop_valid_wr_enable,
	// Field: POP
	output                                o_crc_err_fifo_pop_pop,

	// Register: CRC_ERR_FIFO_DATA0
	// Field: POLY_LSB
	input  [31:0]                         i_crc_err_fifo_data0_poly_lsb_next,

	// Register: CRC_ERR_FIFO_DATA1
	// Field: POLY_MSB
	input  [31:0]                         i_crc_err_fifo_data1_poly_msb_next,

	// Register: CRC_ERR_FIFO_DATA2
	// Field: DATA_ADDR
	input  [31:0]                         i_crc_err_fifo_data2_data_addr_next,

	// Register: CRC_ERR_FIFO_DATA3
	// Field: CRC_ADDR
	input  [31:0]                         i_crc_err_fifo_data3_crc_addr_next,

	// Register: CRC_ERR_FIFO_DATA4
	// Field: CRC_POLY_SIZE_SEL
	input  [1:0]                          i_crc_err_fifo_data4_crc_poly_size_sel_next,
	// Field: CRC_RPT_NUM
	input  [2:0]                          i_crc_err_fifo_data4_crc_rpt_num_next,
	// Field: CRC_REQ_ID
	input  [15:0]                         i_crc_err_fifo_data4_crc_req_id_next,

	// Register: CRC_INT_STATUS
	// Field: WDT_INT_STATUS
	input i_wdt_int_lvl,
	// Field: CRC_ERR_RSP_FULL_INT_STATUS
	input i_crc_err_rsp_full_int_lvl,

	output o_int,

	output [31:0]                         o_crc_gen_data_ba_addr,

	output [31:0]                         o_crc_gen_crc_ba_addr,

	// Default bus
	//-------------------------------------------------------------------
	input                                 i_apb_sel,
	input                                 i_apb_enable,
	input                                 i_apb_write,
	input  [9:2]                          i_apb_addr,
	output [31:0]                         o_apb_rdata,
	input  [31:0]                         i_apb_wdata
);

wire wdt_fw_clr;
wire err_fifo_pop_clr;
wire err_rsp_full_int_en;
wire wdt_int_en;
wire wdt_int_status;
wire crc_int_status_wdt_int_status_wr_enable;
wire crc_int_status_crc_err_rsp_full_int_status_wr_enable;

crc_gen_regs_apb_slave crc_gen_regs_apb_slave_i (
	.i_sys_clk(i_sys_clk),
	.i_sys_arstn(i_sys_arstn),

	.o_crc_gen_ctrl_rpt_num(o_crc_gen_ctrl_rpt_num),


	.o_crc_gen_poly_16_val(o_crc_gen_poly_16_val),


	.o_crc_gen_poly_32_val(o_crc_gen_poly_32_val),


	.o_crc_gen_poly_64l_val(o_crc_gen_poly_64l_val),


	.o_crc_gen_poly_64h_val(o_crc_gen_poly_64h_val),


	.o_crc_gen_wdt_ctrl_wdt_init_cnt(o_crc_gen_wdt_ctrl_wdt_init_cnt),

	.o_crc_gen_wdt_ctrl_wdt_en(o_crc_gen_wdt_ctrl_wdt_en),

	.o_crc_gen_wdt_ctrl_wdt_fw_clr(o_crc_gen_wdt_ctrl_wdt_fw_clr),
	.i_crc_gen_wdt_ctrl_wdt_fw_clr_next(1'b0),
	.i_crc_gen_wdt_ctrl_wdt_fw_clr_wr_enable(wdt_fw_clr),


	.i_crc_err_fifo_pop_err_rsp_code_next(i_crc_err_fifo_pop_err_rsp_code_next),
	.i_crc_err_fifo_pop_err_rsp_code_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),

	.i_crc_err_fifo_pop_valid_next(1'b1),
	.i_crc_err_fifo_pop_valid_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),

	.o_crc_err_fifo_pop_pop(o_crc_err_fifo_pop_pop),
	.i_crc_err_fifo_pop_pop_next(1'b0),
	.i_crc_err_fifo_pop_pop_wr_enable(err_fifo_pop_clr),


	.i_crc_err_fifo_data0_poly_lsb_next(i_crc_err_fifo_data0_poly_lsb_next),
	.i_crc_err_fifo_data0_poly_lsb_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),


	.i_crc_err_fifo_data1_poly_msb_next(i_crc_err_fifo_data1_poly_msb_next),
	.i_crc_err_fifo_data1_poly_msb_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),


	.i_crc_err_fifo_data2_data_addr_next(i_crc_err_fifo_data2_data_addr_next),
	.i_crc_err_fifo_data2_data_addr_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),


	.i_crc_err_fifo_data3_crc_addr_next(i_crc_err_fifo_data3_crc_addr_next),
	.i_crc_err_fifo_data3_crc_addr_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),


	.i_crc_err_fifo_data4_crc_poly_size_sel_next(i_crc_err_fifo_data4_crc_poly_size_sel_next),
	.i_crc_err_fifo_data4_crc_poly_size_sel_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),

	.i_crc_err_fifo_data4_crc_rpt_num_next(i_crc_err_fifo_data4_crc_rpt_num_next),
	.i_crc_err_fifo_data4_crc_rpt_num_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),

	.i_crc_err_fifo_data4_crc_req_id_next(i_crc_err_fifo_data4_crc_req_id_next),
	.i_crc_err_fifo_data4_crc_req_id_wr_enable(i_crc_err_fifo_pop_valid_wr_enable),


	.o_crc_int_en_wdt_int_en(wdt_int_en),

	.o_crc_int_en_crc_err_rsp_full_int_en(err_rsp_full_int_en),

	.o_crc_int_status_wdt_int_status(wdt_int_status),
	.i_crc_int_status_wdt_int_status_next(1'b1),
	.i_crc_int_status_wdt_int_status_wr_enable(crc_int_status_wdt_int_status_wr_enable),

	.o_crc_int_status_crc_err_rsp_full_int_status(err_rsp_full_int_status),
	.i_crc_int_status_crc_err_rsp_full_int_status_next(1'b1),
	.i_crc_int_status_crc_err_rsp_full_int_status_wr_enable(crc_int_status_crc_err_rsp_full_int_status_wr_enable),


  	.o_crc_gen_data_ba_addr(o_crc_gen_data_ba_addr),
  	.o_crc_gen_crc_ba_addr(o_crc_gen_crc_ba_addr),

	.i_apb_sel(i_apb_sel),
	.i_apb_enable(i_apb_enable),
	.i_apb_write(i_apb_write),
	.i_apb_addr(i_apb_addr),
	.o_apb_rdata(o_apb_rdata),
	.i_apb_wdata(i_apb_wdata)
);

reg wdt_int_lvl_q;
reg crc_err_rsp_full_int_lvl_q;

assign o_int = (wdt_int_status & wdt_int_en) | (err_rsp_full_int_status & err_rsp_full_int_en);

always @(posedge i_sys_clk or negedge i_sys_arstn)
    if (!i_sys_arstn)
       wdt_int_lvl_q <= '0;
    else
       wdt_int_lvl_q <= i_wdt_int_lvl;

assign crc_int_status_wdt_int_status_wr_enable = i_wdt_int_lvl & ~wdt_int_lvl_q;

always @(posedge i_sys_clk or negedge i_sys_arstn)
    if (!i_sys_arstn)
       crc_err_rsp_full_int_lvl_q <= '0;
    else
       crc_err_rsp_full_int_lvl_q <= i_crc_err_rsp_full_int_lvl;

assign crc_int_status_crc_err_rsp_full_int_status_wr_enable = i_crc_err_rsp_full_int_lvl & ~crc_err_rsp_full_int_lvl_q;

assign wdt_fw_clr = o_crc_gen_wdt_ctrl_wdt_fw_clr;

assign err_fifo_pop_clr = o_crc_gen_wdt_ctrl_wdt_fw_clr;

endmodule
