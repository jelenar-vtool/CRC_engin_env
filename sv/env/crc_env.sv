//------------------------------------------------------------------------------------------------------------
class crc_env extends uvm_env;
    `uvm_component_utils(crc_env)


   crc_env_cfg m_env_cfg; 
  	
	//interfaces
   virtual interface vr_if#(37)  crc_req_t_vif ;
   virtual interface vr_if#(149) crc_param_req_t_vif  ;
   virtual interface vr_if#(8)   crc_param_rsp_t_vif  ;
   virtual interface vr_if#(24)  crc_rsp_t_vif  ;
	//agents
   	vr_agent#(37) crc_req_agent; 
	vr_agent#(149) crc_param_req_agent;
	vr_agent#(8) crc_param_rsp_agent;
	vr_agent#(24) crc_rsp_agent; 

   crc_scoreboard scbd;
  // other components
   crc_virtual_sequencer m_virt_seqr;



    extern function new (string name, uvm_component parent);
    extern virtual function void build_phase (uvm_phase phase);
    extern virtual function void connect_phase (uvm_phase phase);

endclass

//------------------------------------------------------------------------------------------------------------
function crc_env::new (string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

//------------------------------------------------------------------------------------------------------------
function void crc_env:: build_phase (uvm_phase phase);
    super.build_phase(phase);
    

	 if (!uvm_config_db # (crc_env_cfg) :: get (this, "", "m_env_cfg", m_env_cfg)) begin
        `uvm_fatal (get_type_name(), "Failed to get the configuration file from the config DB!")
    end 
 
     crc_req_agent  = vr_agent#(37)::type_id::create("crc_req_agent", this);
     crc_param_req_agent  = vr_agent#(149)::type_id::create("crc_param_req_agent", this);
     crc_param_rsp_agent  = vr_agent#(8)::type_id::create("crc_param_rsp_agent", this);
     crc_rsp_agent  = vr_agent#(24)::type_id::create("crc_rsp_agent", this);


  cfg  = crc_cfg::type_id::create("cfg", this);

   scbd        = crc_scoreboard::type_id::create("scbd", this);
   m_virt_seqr   = crc_virtual_sequencer::type_id::create ("m_virt_seqr", this);

    crc_req_agent.cfg = cfg_env.master_config;
    crc_param_req_agent.cfg = cfg_env.slave_config;
    crc_param_rsp_agent.cfg = cfg_env.master_config;
    crc_rsp_agent.cfg = cfg_env.slave_config;       


endfunction : build_phase 

//------------------------------------------------------------------------------------------------------------ 
function void crc_env:: connect_phase (uvm_phase phase);
    super.connect_phase(phase);
	 //za sekvence da se poveze 
      //za monitor da se poveze za skorbord da ima ono sa sfg= slave master agent 
		
endfunction : connect_phase
