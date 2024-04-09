class crc_env_cfg extends uvm_object;       
    
    
    vr_cfg slave_config;
    vr_cfg master_config;    
    int has_master_agent;
    int has_slave_agent;
    

    extern function new(string name = "crc_env_cfg");
    `uvm_object_utils_begin(crc_env_cfg)

        `uvm_field_object(master_config, UVM_ALL_ON)
        `uvm_field_object(slave_config, UVM_ALL_ON)
        `uvm_field_int(has_master_agent, UVM_ALL_ON )
        `uvm_field_int(has_slave_agent, UVM_ALL_ON)      
    `uvm_object_utils_end
endclass

function crc_env_cfg::new(string name = "crc_env_cfg");
    super.new(name);
    master_config = vr_cfg::type_id::create ("master_config");
    slave_config = vr_cfg::type_id::create ("slave_config");
endfunction

//-------------------------------------------------------------------------------------------------------------

