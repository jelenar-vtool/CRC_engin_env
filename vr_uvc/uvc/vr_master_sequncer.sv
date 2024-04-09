// * * * Default sequencer * * *


class vr_master_sequencer extends uvm_sequencer #(vr_item);

   `uvm_component_utils(vr_master_sequencer)

    vr_cfg cfg;

    extern function new (string name, uvm_component parent);
    extern function void build_phase (uvm_phase phase);
endclass // vr_master_sequencer
 
//-------------------------------------------------------------------------------------------------------------
function vr_master_sequencer::new (string name, uvm_component parent);
    super.new(name, parent);
endfunction 

//-------------------------------------------------------------------------------------------------------------
function void vr_master_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(vr_cfg )::get(this, "", "cfg", cfg)) begin
        `uvm_info("build_phase", "CFG is not set through config db", UVM_LOW);    
    end 
    else begin
        `uvm_info("build_phase", "CFG is set through config db", UVM_LOW);
    end
endfunction
