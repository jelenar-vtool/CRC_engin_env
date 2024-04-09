//`ifndef apb_PKG_SV
//`define apb_PKG_SV

//------------------------------------------------------------------------------------------------------------
`include "uvm_macros.svh"
//`include "apb_if.sv"
package apb_pkg;
import uvm_pkg::*;
   `include "../env/apb_coverage.sv"
    `include "apb_defines.sv"
    `include "apb_cfg.sv"

    `include "apb_item.sv"
  // `include "../rtl/reg2apb_adapter.sv"

    `include "apb_monitor.sv" 

    `include "apb_master_sequencer.sv"
    `include "apb_slave_sequencer.sv"
    `include "apb_master_sequence.sv"
    `include "slave_empty_driver.sv"
    `include "apb_slave_sequence.sv"
    `include "apb_sequence_lib.sv"
    `include "apb_master_driver.sv"
    //`include "apb_slave_driver.sv"
    `include "apb_agent.sv"
endpackage 

//`endif //apb_PKG_SV

