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
   `include "../../vr_uvc/uvc/vr_item"
   `include "../../vr_uvc/uvc/vr_cfg"
   `include "../../vr_uvc/uvc/vr_master_sequencer"
   `include "../../vr_uvc/uvc/vr_slave_sequencer"
   `include "../../vr_uvc/uvc/vr_sequence_lib"
   `include "../../vr_uvc/uvc/vr_master_driver"
   `include "../../vr_uvc/uvc/vr_slave_driver"
   `include "../../vr_uvc/uvc/vr_monitor"
   `include "../../vr_uvc/uvc/vr.agent"
endpackage 

//`endif //crc_PKG_SV
