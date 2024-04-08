class crc_master_sequencer extends uvm_sequencer #(crc_item);

   `uvm_component_utils(crc_master_sequencer)
    crc_cfg cfg;
   virtual crc_if crc_vif;
    extern function new(string name, uvm_component parent);
    extern function void build_phase(uvm_phase phase);
endclass : crc_master_sequencer
 
//-------------------------------------------------------------------------------------------------------------
function crc_master_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

//-------------------------------------------------------------------------------------------------------------
function void crc_master_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
 if(!uvm_config_db #(virtual crc_if )::get(this, "", "crc_vif", crc_vif)) begin 
       `uvm_fatal("", "Failed to get virtual_interface !");
end
 
endfunction : build_phase
