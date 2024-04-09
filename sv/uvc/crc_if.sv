//ova interefejs mi ne treba?????
interface crc_if#(parameter CRC_REQ_WITDH = 36, parameter CRC_RSP_WITDH = 149, parameter CRC_PARAM_REQ_WITDH = 24)(input i_clk,input  i_nreset);
	logic i_reg_apb_pse;
	logic i_reg_apb_penable;
	logic i_reg_apb_pwrite;
	logic [9:0] i_reg_apb_paddr;
	logic [31:0] i_reg_apb_pwdata;                         
	logic o_reg_apb_pready;
	logic [31:0] o_reg_apb_prdata;
	  
	logic i_crc_req_valid;
	logic [CRC_REQ_WITDH-1:0] i_crc_req_data;
	logic o_crc_req_ready;
	  
	logic i_crc_done_ready;
	logic [CRC_RSP_WITDH-1:0] o_crc_done_data;
	logic o_crc_done_valid;
	  
	logic i_crc_param_done_valid;
	logic [CRC_PARAM_RSP_WITDH-1:0] i_crc_param_done_data;
	logic o_crc_param_done_ready;  
		                    
	logic o_crc_param_valid;
	logic [CRC_PARAM_REQ_WITDH-1:0] o_crc_param_data;                         
	logic i_crc_param_ready;
	  
	logic o_int;

endinterface
