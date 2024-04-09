/*
* * * * *   AGENT CONFIGURATION     * * * * * 
    You can add specific fields for your agents here
*/

class apb_cfg extends uvm_object;  

//  Enables protocol checks
    rand bit has_checks;
    rand bit has_delay;
    rand bit ready_high;
//  Enables coverage  
    rand bit has_coverage;
    rand agent_type_enum agent_type; // master (0) or slave (1)


//  Simulation timeout
    time test_time_out = 100000000;

//  Default constraints 
    constraint apb_cfg_default_cst {        
        soft has_coverage == 1;
        soft has_checks == 1;
        soft has_delay == 1;
    }
//------------------------------------------------------------------------------------------------------------
// Shorthand macros
//------------------------------------------------------------------------------------------------------------
    `uvm_object_utils_begin(apb_cfg)
        `uvm_field_int (has_coverage, UVM_ALL_ON)
        `uvm_field_int (has_checks, UVM_ALL_ON)
    `uvm_object_utils_end
    
    extern function new(string name = "apb_cfg");

endclass // apb_cfg

//-------------------------------------------------------------------------------------------------------------
function apb_cfg::new(string name = "apb_cfg");
    super.new(name);
endfunction // new


