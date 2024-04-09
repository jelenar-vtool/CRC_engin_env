//`ifndef vr_PKG_SV
//`define vr_PKG_SV

//------------------------------------------------------------------------------------------------------------
`include "uvm_macros.svh"
//`include "vr_if.sv"
package vr_pkg;
import uvm_pkg::*;
   //`include "../env/vr_coverage.sv"
    `include "vr_defiines.sv"
    `include "vr_cfg.sv"
    `include "vr_item.sv"
    //`include "../rtl/vr_reg2bus.sv"
    //`include "../rtl/vr_bus2reg.sv"
    `include "vr_monitor.sv" 
    `include "vr_master_sequncer.sv"
    `include "vr_slave_sequncer.sv"
    `include "vr_slave_driver.sv"
    `include "vr_sequence_lib.sv"
    `include "vr_master_driver.sv"
    `include "vr_agent.sv"
endpackage 

//`endif //vr_PKG_SV
