/*
    * * * Environment configuration class. By default it just defines that env will have 2 angets, and creates two agent configurations. One agent will be Master, other will
          be Slave.
          Add or remove fields and constraints to meet your specific needs.
*/
class apb_env_cfg extends uvm_object;       
    
    
    apb_cfg slave_config;
    apb_cfg master_config;    
    int has_master_agent;
    int has_slave_agent;
    

    extern function new(string name = "apb_env_cfg");
    `uvm_object_utils_begin(apb_env_cfg)
        //`uvm_field_object(apb_config, UVM_ALL_ON)
        `uvm_field_object(master_config, UVM_ALL_ON)
        `uvm_field_object(slave_config, UVM_ALL_ON)
        `uvm_field_int(has_master_agent, UVM_ALL_ON )
        `uvm_field_int(has_slave_agent, UVM_ALL_ON)      
    `uvm_object_utils_end
endclass

function apb_env_cfg::new(string name = "apb_env_cfg");
    super.new(name);
    master_config = apb_cfg::type_id::create ("master_config");
    slave_config = apb_cfg::type_id::create ("slave_config");
endfunction
