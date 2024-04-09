
//`include "uvm_pkg.sv"
`include "uvm_macros.svh" 
`include "vr_pkg.sv"
package  vr_env_pkg;

import uvm_pkg::*;
import vr_pkg::*;

`include "vr_env_cfg.sv"
    `include "vr_virual_sequncer.sv"
    `include "vr_virual_sequnce.sv"

`include "vr_scoreboard.sv"

`include "vr_env.sv"

`include "vr_test_list.sv"

endpackage 

//------------------------------------------------------------------------------------------------------------
