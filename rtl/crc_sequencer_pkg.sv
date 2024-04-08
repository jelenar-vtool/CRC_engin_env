typedef struct packed {
  logic [1:0] crc_poly_size_sel;
  logic [1:0] crc_poly_sel;
  logic req_rpt_en;
  logic [15:0] req_id;
  logic [7:0] data_addr_offset;
  logic [7:0] crc_addr_offset;
} crc_req_t;

parameter CRC_REQ_WITDH = $bits(crc_req_t);

typedef struct packed {
  logic [63:0] crc_poly;
  logic [1:0] crc_poly_size_sel;
  logic [31:0] data_addr;
  logic [31:0] crc_addr;
  logic [2:0] rpt_num;
  logic [15:0] req_id;  
} crc_param_req_t;

parameter CRC_PARAM_REQ_WITDH = $bits(crc_param_req_t);

typedef struct packed {  
  crc_param_req_t crc_param_req;
  logic [7:0] rsp_code;
} crc_param_rsp_t;

typedef struct packed {  
  logic [15:0] req_id;
  logic [7:0] rsp_code;
} crc_rsp_t;

parameter CRC_PARAM_RSP_WITDH = $bits(crc_param_rsp_t);
parameter CRC_RSP_WITDH = $bits(crc_rsp_t);

parameter CRC_REQ_MAX_OUTSTAND = 32;
parameter CRC_WD_CNT_W = 16;
