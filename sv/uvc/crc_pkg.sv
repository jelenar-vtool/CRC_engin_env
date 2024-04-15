//`ifndef crc_PKG_SV
//`define crc_PKG_SV

//------------------------------------------------------------------------------------------------------------
`include "uvm_macros.svh"

	package crc_pkg;
    import uvm_pkg::*;
//vrv cu ovde i za apb da dodajem!?!?!!!!???
  //`include "crc_item.sv"- ovo mi ne treba?
  //`include "crc_cfg.sv" - ovo mi ne treba?
 // `include "crc_master_sequencer.sv" - ovo mi ne treba?
  //`include "crc_master_sequence.sv" - ovo mi ne treba?
  //`include "crc_master_driver.sv" - ovo mi ne treba?
  //`include "crc_monitor.sv" - ovo mi ne treba?
  //`include "crc_agent.sv" - ovo mi ne treba?
		//valid_ready
   `include "../../vr_uvc/uvc/vr_defiines.sv"
   `include "../../vr_uvc/uvc/vr_item.sv"
   `include "../../vr_uvc/uvc/vr_cfg.sv"
   `include "../../vr_uvc/uvc/vr_master_sequncer.sv"
   `include "../../vr_uvc/uvc/vr_slave_sequncer.sv"
   `include "../../vr_uvc/uvc/vr_sequence_lib.sv"
   `include "../../vr_uvc/uvc/vr_master_driver.sv"
   `include "../../vr_uvc/uvc/vr_slave_driver.sv"
   `include "../../vr_uvc/uvc/vr_monitor.sv"
   `include "../../vr_uvc/uvc/vr_agent.sv"
		//apb
   `include "../../apb_uvc/uvc/apb_defines.sv"
   `include "../../apb_uvc/uvc/apb_item.sv"
   `include "../../apb_uvc/uvc/apb_cfg.sv"
   `include "../../apb_uvc/uvc/apb_master_sequencer.sv"
   `include "../../apb_uvc/uvc/apb_master_sequence.sv"
   `include "../../apb_uvc/uvc/apb_master_driver.sv"
   `include "../../apb_uvc/uvc/apb_monitor.sv"
   `include "../../apb_uvc/uvc/apb_agent.sv"
endpackage 

//`endif //crc_PKG_SV
