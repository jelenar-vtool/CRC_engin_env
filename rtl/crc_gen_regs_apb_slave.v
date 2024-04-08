//__________________________________________________________________
//
//  Module:        crc_gen_regs_apb_slave
//
//  Description:   Automatically generated registers for crc_gen_regs
//
//  Created:       By apbsgen utility
//  Version:       v1.7.045 --- Compiled on: Jan 12 2023 -- 12:13:02
//
//  Revision:      1.0
//
//__________________________________________________________________


module crc_gen_regs_apb_slave
(
  input                                 i_sys_clk,
  input                                 i_sys_arstn,

  // Register: CRC_GEN_CTRL
  // Field: RPT_NUM
  output [2:0]                          o_crc_gen_ctrl_rpt_num,

  // Register: CRC_GEN_POLY_16
  // Field: VAL
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
  input                                 i_crc_gen_wdt_ctrl_wdt_fw_clr_next,
  input                                 i_crc_gen_wdt_ctrl_wdt_fw_clr_wr_enable,

  // Register: CRC_ERR_FIFO_POP
  // Field: ERR_RSP_CODE
  input  [7:0]                          i_crc_err_fifo_pop_err_rsp_code_next,
  input                                 i_crc_err_fifo_pop_err_rsp_code_wr_enable,
  // Field: VALID
  input                                 i_crc_err_fifo_pop_valid_next,
  input                                 i_crc_err_fifo_pop_valid_wr_enable,
  // Field: POP
  output                                o_crc_err_fifo_pop_pop,
  input                                 i_crc_err_fifo_pop_pop_next,
  input                                 i_crc_err_fifo_pop_pop_wr_enable,

  // Register: CRC_ERR_FIFO_DATA0
  // Field: POLY_LSB
  input  [31:0]                         i_crc_err_fifo_data0_poly_lsb_next,
  input                                 i_crc_err_fifo_data0_poly_lsb_wr_enable,

  // Register: CRC_ERR_FIFO_DATA1
  // Field: POLY_MSB
  input  [31:0]                         i_crc_err_fifo_data1_poly_msb_next,
  input                                 i_crc_err_fifo_data1_poly_msb_wr_enable,

  // Register: CRC_ERR_FIFO_DATA2
  // Field: DATA_ADDR
  input  [31:0]                         i_crc_err_fifo_data2_data_addr_next,
  input                                 i_crc_err_fifo_data2_data_addr_wr_enable,

  // Register: CRC_ERR_FIFO_DATA3
  // Field: CRC_ADDR
  input  [31:0]                         i_crc_err_fifo_data3_crc_addr_next,
  input                                 i_crc_err_fifo_data3_crc_addr_wr_enable,

  // Register: CRC_ERR_FIFO_DATA4
  // Field: CRC_POLY_SIZE_SEL
  input  [1:0]                          i_crc_err_fifo_data4_crc_poly_size_sel_next,
  input                                 i_crc_err_fifo_data4_crc_poly_size_sel_wr_enable,
  // Field: CRC_RPT_NUM
  input  [2:0]                          i_crc_err_fifo_data4_crc_rpt_num_next,
  input                                 i_crc_err_fifo_data4_crc_rpt_num_wr_enable,
  // Field: CRC_REQ_ID
  input  [15:0]                         i_crc_err_fifo_data4_crc_req_id_next,
  input                                 i_crc_err_fifo_data4_crc_req_id_wr_enable,

  // Register: CRC_INT_EN
  // Field: WDT_INT_EN
  output                                o_crc_int_en_wdt_int_en,
  // Field: CRC_ERR_RSP_FULL_INT_EN
  output                                o_crc_int_en_crc_err_rsp_full_int_en,

  // Register: CRC_INT_STATUS
  // Field: WDT_INT_STATUS
  output                                o_crc_int_status_wdt_int_status,
  input                                 i_crc_int_status_wdt_int_status_next,
  input                                 i_crc_int_status_wdt_int_status_wr_enable,
  // Field: CRC_ERR_RSP_FULL_INT_STATUS
  output                                o_crc_int_status_crc_err_rsp_full_int_status,
  input                                 i_crc_int_status_crc_err_rsp_full_int_status_next,
  input                                 i_crc_int_status_crc_err_rsp_full_int_status_wr_enable,

  // Register: CRC_GEN_DATA_BA
  // Field: ADDR
  output [31:0]                         o_crc_gen_data_ba_addr,

  // Register: CRC_GEN_CRC_BA
  // Field: ADDR
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

//__________________________________________________________
// Internal Signals
//__________________________________________________________
reg    [31:0]                         read_data_q;
wire                                  read_enable;
wire                                  write_enable;

reg    [2:0]                          crc_gen_ctrl_rpt_num_q;
wire                                  crc_gen_ctrl_wr_enable;
wire                                  crc_gen_ctrl_rd_enable;
reg    [31:0]                         crc_gen_ctrl_rdata;
reg    [15:0]                         crc_gen_poly_16_val_q;
wire                                  crc_gen_poly_16_wr_enable;
wire                                  crc_gen_poly_16_rd_enable;
reg    [31:0]                         crc_gen_poly_16_rdata;
reg    [31:0]                         crc_gen_poly_32_val_q;
wire                                  crc_gen_poly_32_wr_enable;
wire                                  crc_gen_poly_32_rd_enable;
reg    [31:0]                         crc_gen_poly_32_rdata;
reg    [31:0]                         crc_gen_poly_64l_val_q;
wire                                  crc_gen_poly_64l_wr_enable;
wire                                  crc_gen_poly_64l_rd_enable;
reg    [31:0]                         crc_gen_poly_64l_rdata;
reg    [31:0]                         crc_gen_poly_64h_val_q;
wire                                  crc_gen_poly_64h_wr_enable;
wire                                  crc_gen_poly_64h_rd_enable;
reg    [31:0]                         crc_gen_poly_64h_rdata;
reg    [15:0]                         crc_gen_wdt_ctrl_wdt_init_cnt_q;
reg                                   crc_gen_wdt_ctrl_wdt_en_q;
reg                                   crc_gen_wdt_ctrl_wdt_fw_clr_q;
wire                                  crc_gen_wdt_ctrl_wr_enable;
wire                                  crc_gen_wdt_ctrl_rd_enable;
reg    [31:0]                         crc_gen_wdt_ctrl_rdata;
reg    [7:0]                          crc_err_fifo_pop_err_rsp_code_q;
reg                                   crc_err_fifo_pop_valid_q;
reg                                   crc_err_fifo_pop_pop_q;
wire                                  crc_err_fifo_pop_wr_enable;
wire                                  crc_err_fifo_pop_rd_enable;
reg    [31:0]                         crc_err_fifo_pop_rdata;
reg    [31:0]                         crc_err_fifo_data0_poly_lsb_q;
wire                                  crc_err_fifo_data0_rd_enable;
reg    [31:0]                         crc_err_fifo_data0_rdata;
reg    [31:0]                         crc_err_fifo_data1_poly_msb_q;
wire                                  crc_err_fifo_data1_rd_enable;
reg    [31:0]                         crc_err_fifo_data1_rdata;
reg    [31:0]                         crc_err_fifo_data2_data_addr_q;
wire                                  crc_err_fifo_data2_rd_enable;
reg    [31:0]                         crc_err_fifo_data2_rdata;
reg    [31:0]                         crc_err_fifo_data3_crc_addr_q;
wire                                  crc_err_fifo_data3_rd_enable;
reg    [31:0]                         crc_err_fifo_data3_rdata;
reg    [1:0]                          crc_err_fifo_data4_crc_poly_size_sel_q;
reg    [2:0]                          crc_err_fifo_data4_crc_rpt_num_q;
reg    [15:0]                         crc_err_fifo_data4_crc_req_id_q;
wire                                  crc_err_fifo_data4_rd_enable;
reg    [31:0]                         crc_err_fifo_data4_rdata;
reg                                   crc_int_en_wdt_int_en_q;
reg                                   crc_int_en_crc_err_rsp_full_int_en_q;
wire                                  crc_int_en_wr_enable;
wire                                  crc_int_en_rd_enable;
reg    [31:0]                         crc_int_en_rdata;
reg                                   crc_int_status_wdt_int_status_q;
reg                                   crc_int_status_crc_err_rsp_full_int_status_q;
wire                                  crc_int_status_wr_enable;
wire                                  crc_int_status_rd_enable;
reg    [31:0]                         crc_int_status_rdata;
reg    [31:0]                         crc_gen_data_ba_addr_q;
wire                                  crc_gen_data_ba_wr_enable;
wire                                  crc_gen_data_ba_rd_enable;
reg    [31:0]                         crc_gen_data_ba_rdata;
reg    [31:0]                         crc_gen_crc_ba_addr_q;
wire                                  crc_gen_crc_ba_wr_enable;
wire                                  crc_gen_crc_ba_rd_enable;
reg    [31:0]                         crc_gen_crc_ba_rdata;


//__________________________________________________________
// Module logic
//__________________________________________________________
assign o_crc_gen_ctrl_rpt_num = crc_gen_ctrl_rpt_num_q;
assign o_crc_gen_poly_16_val = crc_gen_poly_16_val_q;
assign o_crc_gen_poly_32_val = crc_gen_poly_32_val_q;
assign o_crc_gen_poly_64l_val = crc_gen_poly_64l_val_q;
assign o_crc_gen_poly_64h_val = crc_gen_poly_64h_val_q;
assign o_crc_gen_wdt_ctrl_wdt_init_cnt = crc_gen_wdt_ctrl_wdt_init_cnt_q;
assign o_crc_gen_wdt_ctrl_wdt_en = crc_gen_wdt_ctrl_wdt_en_q;
assign o_crc_gen_wdt_ctrl_wdt_fw_clr = crc_gen_wdt_ctrl_wdt_fw_clr_q;
assign o_crc_err_fifo_pop_pop = crc_err_fifo_pop_pop_q;
assign o_crc_int_en_wdt_int_en = crc_int_en_wdt_int_en_q;
assign o_crc_int_en_crc_err_rsp_full_int_en = crc_int_en_crc_err_rsp_full_int_en_q;
assign o_crc_int_status_wdt_int_status = crc_int_status_wdt_int_status_q;
assign o_crc_int_status_crc_err_rsp_full_int_status = crc_int_status_crc_err_rsp_full_int_status_q;
assign o_crc_gen_data_ba_addr = crc_gen_data_ba_addr_q;
assign o_crc_gen_crc_ba_addr = crc_gen_crc_ba_addr_q;

assign read_enable = i_apb_sel && !i_apb_write && (!i_apb_enable);
assign write_enable = i_apb_sel && i_apb_write && (!i_apb_enable);



// Register CRC_GEN_CTRL

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_ctrl_rpt_num_q <= 3'h0;
  end
  else if (crc_gen_ctrl_wr_enable)
  begin
    crc_gen_ctrl_rpt_num_q <= i_apb_wdata[2:0];
  end
end

assign crc_gen_ctrl_wr_enable = write_enable && i_apb_addr == 8'd0;
assign crc_gen_ctrl_rd_enable = read_enable && i_apb_addr == 8'd0;


always @*
begin : CRC_GEN_CTRL_BLOCK
    integer crc_gen_ctrl_i;
    reg    [31:0]                         crc_gen_ctrl_rdata_tmp;
    crc_gen_ctrl_rdata_tmp = 32'h0;
    crc_gen_ctrl_rdata = 32'h0;
        crc_gen_ctrl_rdata_tmp[2:0] = crc_gen_ctrl_rpt_num_q;
        crc_gen_ctrl_rdata = crc_gen_ctrl_rdata | ({32{crc_gen_ctrl_rd_enable}} & crc_gen_ctrl_rdata_tmp);
end


// Register CRC_GEN_POLY_16

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_poly_16_val_q <= 16'h0;
  end
  else if (crc_gen_poly_16_wr_enable)
  begin
    crc_gen_poly_16_val_q <= i_apb_wdata[15:0];
  end
end

assign crc_gen_poly_16_wr_enable = write_enable && i_apb_addr == 8'd1;
assign crc_gen_poly_16_rd_enable = read_enable && i_apb_addr == 8'd1;


always @*
begin : CRC_GEN_POLY_16_BLOCK
    integer crc_gen_poly_16_i;
    reg    [31:0]                         crc_gen_poly_16_rdata_tmp;
    crc_gen_poly_16_rdata_tmp = 32'h0;
    crc_gen_poly_16_rdata = 32'h0;
        crc_gen_poly_16_rdata_tmp[15:0] = crc_gen_poly_16_val_q;
        crc_gen_poly_16_rdata = crc_gen_poly_16_rdata | ({32{crc_gen_poly_16_rd_enable}} & crc_gen_poly_16_rdata_tmp);
end


// Register CRC_GEN_POLY_32

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_poly_32_val_q <= 32'h0;
  end
  else if (crc_gen_poly_32_wr_enable)
  begin
    crc_gen_poly_32_val_q <= i_apb_wdata;
  end
end

assign crc_gen_poly_32_wr_enable = write_enable && i_apb_addr == 8'd2;
assign crc_gen_poly_32_rd_enable = read_enable && i_apb_addr == 8'd2;


always @*
begin : CRC_GEN_POLY_32_BLOCK
    integer crc_gen_poly_32_i;
    reg    [31:0]                         crc_gen_poly_32_rdata_tmp;
    crc_gen_poly_32_rdata_tmp = 32'h0;
    crc_gen_poly_32_rdata = 32'h0;
        crc_gen_poly_32_rdata_tmp = crc_gen_poly_32_val_q;
        crc_gen_poly_32_rdata = crc_gen_poly_32_rdata | ({32{crc_gen_poly_32_rd_enable}} & crc_gen_poly_32_rdata_tmp);
end


// Register CRC_GEN_POLY_64L

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_poly_64l_val_q <= 32'h0;
  end
  else if (crc_gen_poly_64l_wr_enable)
  begin
    crc_gen_poly_64l_val_q <= i_apb_wdata;
  end
end

assign crc_gen_poly_64l_wr_enable = write_enable && i_apb_addr == 8'd3;
assign crc_gen_poly_64l_rd_enable = read_enable && i_apb_addr == 8'd3;


always @*
begin : CRC_GEN_POLY_64L_BLOCK
    integer crc_gen_poly_64l_i;
    reg    [31:0]                         crc_gen_poly_64l_rdata_tmp;
    crc_gen_poly_64l_rdata_tmp = 32'h0;
    crc_gen_poly_64l_rdata = 32'h0;
        crc_gen_poly_64l_rdata_tmp = crc_gen_poly_64l_val_q;
        crc_gen_poly_64l_rdata = crc_gen_poly_64l_rdata | ({32{crc_gen_poly_64l_rd_enable}} & crc_gen_poly_64l_rdata_tmp);
end


// Register CRC_GEN_POLY_64H

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_poly_64h_val_q <= 32'h0;
  end
  else if (crc_gen_poly_64h_wr_enable)
  begin
    crc_gen_poly_64h_val_q <= i_apb_wdata;
  end
end

assign crc_gen_poly_64h_wr_enable = write_enable && i_apb_addr == 8'd4;
assign crc_gen_poly_64h_rd_enable = read_enable && i_apb_addr == 8'd4;


always @*
begin : CRC_GEN_POLY_64H_BLOCK
    integer crc_gen_poly_64h_i;
    reg    [31:0]                         crc_gen_poly_64h_rdata_tmp;
    crc_gen_poly_64h_rdata_tmp = 32'h0;
    crc_gen_poly_64h_rdata = 32'h0;
        crc_gen_poly_64h_rdata_tmp = crc_gen_poly_64h_val_q;
        crc_gen_poly_64h_rdata = crc_gen_poly_64h_rdata | ({32{crc_gen_poly_64h_rd_enable}} & crc_gen_poly_64h_rdata_tmp);
end


// Register CRC_GEN_WDT_CTRL

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_wdt_ctrl_wdt_init_cnt_q <= 16'hffff;
  end
  else if (crc_gen_wdt_ctrl_wr_enable)
  begin
    crc_gen_wdt_ctrl_wdt_init_cnt_q <= i_apb_wdata[15:0];
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_wdt_ctrl_wdt_en_q <= 1'h0;
  end
  else if (crc_gen_wdt_ctrl_wr_enable)
  begin
    crc_gen_wdt_ctrl_wdt_en_q <= i_apb_wdata[16];
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_wdt_ctrl_wdt_fw_clr_q <= 1'h0;
  end
  else if (crc_gen_wdt_ctrl_wr_enable)
  begin
    crc_gen_wdt_ctrl_wdt_fw_clr_q <= i_apb_wdata[17];
  end
  else if (i_crc_gen_wdt_ctrl_wdt_fw_clr_wr_enable)
  begin
    crc_gen_wdt_ctrl_wdt_fw_clr_q <= i_crc_gen_wdt_ctrl_wdt_fw_clr_next;
  end
end

assign crc_gen_wdt_ctrl_wr_enable = write_enable && i_apb_addr == 8'd5;
assign crc_gen_wdt_ctrl_rd_enable = read_enable && i_apb_addr == 8'd5;


always @*
begin : CRC_GEN_WDT_CTRL_BLOCK
    integer crc_gen_wdt_ctrl_i;
    reg    [31:0]                         crc_gen_wdt_ctrl_rdata_tmp;
    crc_gen_wdt_ctrl_rdata_tmp = 32'h0;
    crc_gen_wdt_ctrl_rdata = 32'h0;
        crc_gen_wdt_ctrl_rdata_tmp[17] = crc_gen_wdt_ctrl_wdt_fw_clr_q;
        crc_gen_wdt_ctrl_rdata_tmp[16] = crc_gen_wdt_ctrl_wdt_en_q;
        crc_gen_wdt_ctrl_rdata_tmp[15:0] = crc_gen_wdt_ctrl_wdt_init_cnt_q;
        crc_gen_wdt_ctrl_rdata = crc_gen_wdt_ctrl_rdata | ({32{crc_gen_wdt_ctrl_rd_enable}} & crc_gen_wdt_ctrl_rdata_tmp);
end


// Register CRC_ERR_FIFO_POP

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_pop_err_rsp_code_q <= 8'h0;
  end
  else if (i_crc_err_fifo_pop_err_rsp_code_wr_enable)
  begin
    crc_err_fifo_pop_err_rsp_code_q <= i_crc_err_fifo_pop_err_rsp_code_next;
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_pop_valid_q <= 1'h0;
  end
  else if (i_crc_err_fifo_pop_valid_wr_enable)
  begin
    crc_err_fifo_pop_valid_q <= i_crc_err_fifo_pop_valid_next;
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_pop_pop_q <= 1'h0;
  end
  else if (crc_err_fifo_pop_wr_enable)
  begin
    crc_err_fifo_pop_pop_q <= i_apb_wdata[9];
  end
  else if (i_crc_err_fifo_pop_pop_wr_enable)
  begin
    crc_err_fifo_pop_pop_q <= i_crc_err_fifo_pop_pop_next;
  end
end

assign crc_err_fifo_pop_wr_enable = write_enable && i_apb_addr == 8'd6;
assign crc_err_fifo_pop_rd_enable = read_enable && i_apb_addr == 8'd6;


always @*
begin : CRC_ERR_FIFO_POP_BLOCK
    integer crc_err_fifo_pop_i;
    reg    [31:0]                         crc_err_fifo_pop_rdata_tmp;
    crc_err_fifo_pop_rdata_tmp = 32'h0;
    crc_err_fifo_pop_rdata = 32'h0;
        crc_err_fifo_pop_rdata_tmp[9] = crc_err_fifo_pop_pop_q;
        crc_err_fifo_pop_rdata_tmp[8] = crc_err_fifo_pop_valid_q;
        crc_err_fifo_pop_rdata_tmp[7:0] = crc_err_fifo_pop_err_rsp_code_q;
        crc_err_fifo_pop_rdata = crc_err_fifo_pop_rdata | ({32{crc_err_fifo_pop_rd_enable}} & crc_err_fifo_pop_rdata_tmp);
end


// Register CRC_ERR_FIFO_DATA0

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data0_poly_lsb_q <= 32'h0;
  end
  else if (i_crc_err_fifo_data0_poly_lsb_wr_enable)
  begin
    crc_err_fifo_data0_poly_lsb_q <= i_crc_err_fifo_data0_poly_lsb_next;
  end
end

assign crc_err_fifo_data0_rd_enable = read_enable && i_apb_addr == 8'd7;


always @*
begin : CRC_ERR_FIFO_DATA0_BLOCK
    integer crc_err_fifo_data0_i;
    reg    [31:0]                         crc_err_fifo_data0_rdata_tmp;
    crc_err_fifo_data0_rdata_tmp = 32'h0;
    crc_err_fifo_data0_rdata = 32'h0;
        crc_err_fifo_data0_rdata_tmp = crc_err_fifo_data0_poly_lsb_q;
        crc_err_fifo_data0_rdata = crc_err_fifo_data0_rdata | ({32{crc_err_fifo_data0_rd_enable}} & crc_err_fifo_data0_rdata_tmp);
end


// Register CRC_ERR_FIFO_DATA1

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data1_poly_msb_q <= 32'h0;
  end
  else if (i_crc_err_fifo_data1_poly_msb_wr_enable)
  begin
    crc_err_fifo_data1_poly_msb_q <= i_crc_err_fifo_data1_poly_msb_next;
  end
end

assign crc_err_fifo_data1_rd_enable = read_enable && i_apb_addr == 8'd8;


always @*
begin : CRC_ERR_FIFO_DATA1_BLOCK
    integer crc_err_fifo_data1_i;
    reg    [31:0]                         crc_err_fifo_data1_rdata_tmp;
    crc_err_fifo_data1_rdata_tmp = 32'h0;
    crc_err_fifo_data1_rdata = 32'h0;
        crc_err_fifo_data1_rdata_tmp = crc_err_fifo_data1_poly_msb_q;
        crc_err_fifo_data1_rdata = crc_err_fifo_data1_rdata | ({32{crc_err_fifo_data1_rd_enable}} & crc_err_fifo_data1_rdata_tmp);
end


// Register CRC_ERR_FIFO_DATA2

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data2_data_addr_q <= 32'h0;
  end
  else if (i_crc_err_fifo_data2_data_addr_wr_enable)
  begin
    crc_err_fifo_data2_data_addr_q <= i_crc_err_fifo_data2_data_addr_next;
  end
end

assign crc_err_fifo_data2_rd_enable = read_enable && i_apb_addr == 8'd9;


always @*
begin : CRC_ERR_FIFO_DATA2_BLOCK
    integer crc_err_fifo_data2_i;
    reg    [31:0]                         crc_err_fifo_data2_rdata_tmp;
    crc_err_fifo_data2_rdata_tmp = 32'h0;
    crc_err_fifo_data2_rdata = 32'h0;
        crc_err_fifo_data2_rdata_tmp = crc_err_fifo_data2_data_addr_q;
        crc_err_fifo_data2_rdata = crc_err_fifo_data2_rdata | ({32{crc_err_fifo_data2_rd_enable}} & crc_err_fifo_data2_rdata_tmp);
end


// Register CRC_ERR_FIFO_DATA3

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data3_crc_addr_q <= 32'h0;
  end
  else if (i_crc_err_fifo_data3_crc_addr_wr_enable)
  begin
    crc_err_fifo_data3_crc_addr_q <= i_crc_err_fifo_data3_crc_addr_next;
  end
end

assign crc_err_fifo_data3_rd_enable = read_enable && i_apb_addr == 8'd10;


always @*
begin : CRC_ERR_FIFO_DATA3_BLOCK
    integer crc_err_fifo_data3_i;
    reg    [31:0]                         crc_err_fifo_data3_rdata_tmp;
    crc_err_fifo_data3_rdata_tmp = 32'h0;
    crc_err_fifo_data3_rdata = 32'h0;
        crc_err_fifo_data3_rdata_tmp = crc_err_fifo_data3_crc_addr_q;
        crc_err_fifo_data3_rdata = crc_err_fifo_data3_rdata | ({32{crc_err_fifo_data3_rd_enable}} & crc_err_fifo_data3_rdata_tmp);
end


// Register CRC_ERR_FIFO_DATA4

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data4_crc_poly_size_sel_q <= 2'h0;
  end
  else if (i_crc_err_fifo_data4_crc_poly_size_sel_wr_enable)
  begin
    crc_err_fifo_data4_crc_poly_size_sel_q <= i_crc_err_fifo_data4_crc_poly_size_sel_next;
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data4_crc_rpt_num_q <= 3'h0;
  end
  else if (i_crc_err_fifo_data4_crc_rpt_num_wr_enable)
  begin
    crc_err_fifo_data4_crc_rpt_num_q <= i_crc_err_fifo_data4_crc_rpt_num_next;
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_err_fifo_data4_crc_req_id_q <= 16'h0;
  end
  else if (i_crc_err_fifo_data4_crc_req_id_wr_enable)
  begin
    crc_err_fifo_data4_crc_req_id_q <= i_crc_err_fifo_data4_crc_req_id_next;
  end
end

assign crc_err_fifo_data4_rd_enable = read_enable && i_apb_addr == 8'd11;


always @*
begin : CRC_ERR_FIFO_DATA4_BLOCK
    integer crc_err_fifo_data4_i;
    reg    [31:0]                         crc_err_fifo_data4_rdata_tmp;
    crc_err_fifo_data4_rdata_tmp = 32'h0;
    crc_err_fifo_data4_rdata = 32'h0;
        crc_err_fifo_data4_rdata_tmp[20:5] = crc_err_fifo_data4_crc_req_id_q;
        crc_err_fifo_data4_rdata_tmp[4:2] = crc_err_fifo_data4_crc_rpt_num_q;
        crc_err_fifo_data4_rdata_tmp[1:0] = crc_err_fifo_data4_crc_poly_size_sel_q;
        crc_err_fifo_data4_rdata = crc_err_fifo_data4_rdata | ({32{crc_err_fifo_data4_rd_enable}} & crc_err_fifo_data4_rdata_tmp);
end


// Register CRC_INT_EN

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_int_en_wdt_int_en_q <= 1'h0;
  end
  else if (crc_int_en_wr_enable)
  begin
    crc_int_en_wdt_int_en_q <= i_apb_wdata[0];
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_int_en_crc_err_rsp_full_int_en_q <= 1'h0;
  end
  else if (crc_int_en_wr_enable)
  begin
    crc_int_en_crc_err_rsp_full_int_en_q <= i_apb_wdata[1];
  end
end

assign crc_int_en_wr_enable = write_enable && i_apb_addr == 8'd12;
assign crc_int_en_rd_enable = read_enable && i_apb_addr == 8'd12;


always @*
begin : CRC_INT_EN_BLOCK
    integer crc_int_en_i;
    reg    [31:0]                         crc_int_en_rdata_tmp;
    crc_int_en_rdata_tmp = 32'h0;
    crc_int_en_rdata = 32'h0;
        crc_int_en_rdata_tmp[1] = crc_int_en_crc_err_rsp_full_int_en_q;
        crc_int_en_rdata_tmp[0] = crc_int_en_wdt_int_en_q;
        crc_int_en_rdata = crc_int_en_rdata | ({32{crc_int_en_rd_enable}} & crc_int_en_rdata_tmp);
end


// Register CRC_INT_STATUS

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_int_status_wdt_int_status_q <= 1'h0;
  end
  else if (i_crc_int_status_wdt_int_status_wr_enable)
  begin
    crc_int_status_wdt_int_status_q <= (i_crc_int_status_wdt_int_status_next & (~({1{crc_int_status_wr_enable}}) | ~(i_apb_wdata[0])));
  end
  else
  begin
    crc_int_status_wdt_int_status_q <= (crc_int_status_wdt_int_status_q & (~({1{crc_int_status_wr_enable}}) | ~(i_apb_wdata[0])));
  end
end

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_int_status_crc_err_rsp_full_int_status_q <= 1'h0;
  end
  else if (i_crc_int_status_crc_err_rsp_full_int_status_wr_enable)
  begin
    crc_int_status_crc_err_rsp_full_int_status_q <= (i_crc_int_status_crc_err_rsp_full_int_status_next & (~({1{crc_int_status_wr_enable}}) | ~(i_apb_wdata[1])));
  end
  else
  begin
    crc_int_status_crc_err_rsp_full_int_status_q <= (crc_int_status_crc_err_rsp_full_int_status_q & (~({1{crc_int_status_wr_enable}}) | ~(i_apb_wdata[1])));
  end
end

assign crc_int_status_wr_enable = write_enable && i_apb_addr == 8'd13;
assign crc_int_status_rd_enable = read_enable && i_apb_addr == 8'd13;


always @*
begin : CRC_INT_STATUS_BLOCK
    integer crc_int_status_i;
    reg    [31:0]                         crc_int_status_rdata_tmp;
    crc_int_status_rdata_tmp = 32'h0;
    crc_int_status_rdata = 32'h0;
        crc_int_status_rdata_tmp[1] = crc_int_status_crc_err_rsp_full_int_status_q;
        crc_int_status_rdata_tmp[0] = crc_int_status_wdt_int_status_q;
        crc_int_status_rdata = crc_int_status_rdata | ({32{crc_int_status_rd_enable}} & crc_int_status_rdata_tmp);
end


// Register CRC_GEN_DATA_BA

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_data_ba_addr_q <= 32'h0;
  end
  else if (crc_gen_data_ba_wr_enable)
  begin
    crc_gen_data_ba_addr_q <= i_apb_wdata;
  end
end

assign crc_gen_data_ba_wr_enable = write_enable && i_apb_addr == 8'd14;
assign crc_gen_data_ba_rd_enable = read_enable && i_apb_addr == 8'd14;


always @*
begin : CRC_GEN_DATA_BA_BLOCK
    integer crc_gen_data_ba_i;
    reg    [31:0]                         crc_gen_data_ba_rdata_tmp;
    crc_gen_data_ba_rdata_tmp = 32'h0;
    crc_gen_data_ba_rdata = 32'h0;
        crc_gen_data_ba_rdata_tmp = crc_gen_data_ba_addr_q;
        crc_gen_data_ba_rdata = crc_gen_data_ba_rdata | ({32{crc_gen_data_ba_rd_enable}} & crc_gen_data_ba_rdata_tmp);
end


// Register CRC_GEN_CRC_BA

always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
  if (!i_sys_arstn)
  begin
    crc_gen_crc_ba_addr_q <= 32'h0;
  end
  else if (crc_gen_crc_ba_wr_enable)
  begin
    crc_gen_crc_ba_addr_q <= i_apb_wdata;
  end
end

assign crc_gen_crc_ba_wr_enable = write_enable && i_apb_addr == 8'd15;
assign crc_gen_crc_ba_rd_enable = read_enable && i_apb_addr == 8'd15;


always @*
begin : CRC_GEN_CRC_BA_BLOCK
    integer crc_gen_crc_ba_i;
    reg    [31:0]                         crc_gen_crc_ba_rdata_tmp;
    crc_gen_crc_ba_rdata_tmp = 32'h0;
    crc_gen_crc_ba_rdata = 32'h0;
        crc_gen_crc_ba_rdata_tmp = crc_gen_crc_ba_addr_q;
        crc_gen_crc_ba_rdata = crc_gen_crc_ba_rdata | ({32{crc_gen_crc_ba_rd_enable}} & crc_gen_crc_ba_rdata_tmp);
end


always @(posedge i_sys_clk or negedge i_sys_arstn)
begin
    if(!i_sys_arstn)
    begin
    read_data_q <= 32'h0;
    end
    else if (read_enable)
    begin
    read_data_q <= 32'h0
                          | (crc_gen_ctrl_rdata)
                          | (crc_gen_poly_16_rdata)
                          | (crc_gen_poly_32_rdata)
                          | (crc_gen_poly_64l_rdata)
                          | (crc_gen_poly_64h_rdata)
                          | (crc_gen_wdt_ctrl_rdata)
                          | (crc_err_fifo_pop_rdata)
                          | (crc_err_fifo_data0_rdata)
                          | (crc_err_fifo_data1_rdata)
                          | (crc_err_fifo_data2_rdata)
                          | (crc_err_fifo_data3_rdata)
                          | (crc_err_fifo_data4_rdata)
                          | (crc_int_en_rdata)
                          | (crc_int_status_rdata)
                          | (crc_gen_data_ba_rdata)
                          | (crc_gen_crc_ba_rdata);
    end
    else
    begin
        read_data_q <= 32'h0;
    end
end

assign o_apb_rdata = read_data_q;


endmodule

