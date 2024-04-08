class crc_env extends uvm_env;

    `uvm_component_param_utils(crc_env)

    crcapb_env_cfg cfg_env;
    crc_agent#(32,32) master_agent;//parametizacija

    crc_sb sb; 
   	crc_virtual_sequencer sequencer;
    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);
    extern virtual function void print_cfg();
endclass : apb_env

function crc_env :: new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

function void crc_env:: build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    if (!uvm_config_db # (crc_env_cfg) :: get (this, "", "cfg_env", cfg_env)) begin
        `uvm_fatal (get_type_name(), "Failed to get the configuration file from the config DB!")
    end 
    
    master_agent = crc_agent#(32,32) :: type_id :: create ("master_agent", this);
   sequencer   = crc_virtual_sequencer::type_id::create ("sequencer", this);
    master_agent.cfg = cfg_env.master_config;


        

    sb = crc_sb::type_id::create("sb",this);
    

endfunction : build_phase 
 
function void crc_env:: connect_phase (uvm_phase phase);
    super.connect_phase(phase);
   	 sequencer.seqr1 = master_agent.m_seqr;

    //connect monitor to scb !!!
    if (cfg_env.has_master_agent == 1) begin
    master_agent.m_mon.apb_mon_analysis_port.connect(sb.m_mon_imp);
    end
   /* if (cfg_env.has_slave_agent == 1) begin    
    slave_agent.m_mon.apb_mon_analysis_port.connect(sb.s_mon_imp); 
    end*/

endfunction : connect_phase

function void crc_env ::print_cfg();
   `uvm_info(get_type_name(), $sformatf ("The configuration that was set : \n%s", cfg_env.sprint()), UVM_MEDIUM)
endfunction : print_cfg
