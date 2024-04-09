/*
      * * * Coverage class, fill your specific coverpoints down bellow * * *
*/

/*    * * * UNCOMMENT AND WRITE COVERAGE BELOW * * *

class apb_coverage extends uvm_component;
	`uvm_component_param_utils(apb_coverage)
	
    apb_cfg cfg; 
    
    covergroup apb_cg with function sample(
        apb_item item
        );
        
        // * * * * WRITE YOUR COVERPOINTS HERE * * * * 
        
    endgroup
	
    extern function new(string name = "apb_coverage", uvm_component parent);
    extern virtual function void build_phase(uvm_phase phase);
endclass

function apb_coverage::new(string name = "apb_coverage", uvm_component parent);
    super.new(name, parent);
    apb_cg = new();	
endfunction // apb_coverage::new

function void  apb_coverage::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(apb_cfg)::get(this, "", "cfg", cfg))   
        `uvm_fatal("build_phase", "cfg wasn't set through config db");
endfunction // apb_coverage::build_phase

*/
