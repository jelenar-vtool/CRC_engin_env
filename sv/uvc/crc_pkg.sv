//`ifndef crc_PKG_SV
//`define crc_PKG_SV

//------------------------------------------------------------------------------------------------------------
`include "uvm_macros.svh"

package crc_pkg;
    import uvm_pkg::*;

  `include "crc_item.sv"
  `include "crc_cfg.sv"
  `include "crc_master_sequencer.sv"
  `include "crc_master_sequence.sv"
  `include "crc_master_driver.sv"
  `include "crc_monitor.sv"
  `include "crc_agent.sv"
endpackage 

//`endif //crc_PKG_SV
