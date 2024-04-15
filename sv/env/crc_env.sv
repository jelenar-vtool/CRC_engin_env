//------------------------------------------------------------------------------------------------------------
class crc_env extends uvm_env;
    `uvm_component_utils(crc_env)


   crc_env_cfg m_env_cfg; 
  	
	//interfaces
   virtual interface vr_if#(37)  crc_req_t_vif ;
   virtual interface vr_if#(24) crc_param_req_t_vif  ;
   virtual interface vr_if#(157)   crc_param_rsp_t_vif  ;
   virtual interface vr_if#(149)  crc_rsp_t_vif  ;
   virtual interface apb_if#(10,32)  apb_vif  ;
	//agents
   	vr_agent#(37) crc_req_agent; 
	vr_agent#(24) crc_param_req_agent;
	vr_agent#(157) crc_param_rsp_agent;
	vr_agent#(149) crc_rsp_agent; 
	apb_agent#(10,32) apb_master_agent; 
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
     crc_param_req_agent  = vr_agent#(24)::type_id::create("crc_param_req_agent", this);
     crc_param_rsp_agent  = vr_agent#(157)::type_id::create("crc_param_rsp_agent", this);
     crc_rsp_agent  = vr_agent#(149)::type_id::create("crc_rsp_agent", this);
     apb_master_agent  = apb_agent#(10,32)::type_id::create("apb_master_agent", this);



   scbd        = crc_scoreboard::type_id::create("scbd", this);
   m_virt_seqr   = crc_virtual_sequencer::type_id::create ("m_virt_seqr", this);

    crc_req_agent.cfg = m_env_cfg.master_config;
    crc_param_req_agent.cfg = m_env_cfg.slave_config;
    crc_param_rsp_agent.cfg = m_env_cfg.master_config;
    crc_rsp_agent.cfg = m_env_cfg.slave_config;       
    apb_master_agent.apb1_cfg = m_env_cfg.apb_master_cfg;       

endfunction : build_phase 

//------------------------------------------------------------------------------------------------------------ 
function void crc_env:: connect_phase (uvm_phase phase);
    super.connect_phase(phase);
	 //connecting sequencers 
		 m_virt_seqr.seqr1 = crc_req_agent.m_seqr;
		 m_virt_seqr.seqr2 = crc_param_req_agent.s_seqr;
		 m_virt_seqr.seqr1 = crc_param_rsp_agent.m_seqr;
		 m_virt_seqr.seqr2 = crc_rsp_agent.s_seqr;
		 m_virt_seqr.seqr3 = apb_master_agent.m_seqr;
    //connecting monitor to scb 
    if (m_env_cfg.has_master_agent == 1) begin
    crc_req_agent.m_mon.vr_mon_analysis_port.connect(scbd.m_mon_impreq);
    crc_param_rsp_agent.m_mon.vr_mon_analysis_port.connect(scbd.m_mon_impparamrsp);
    end
    if (m_env_cfg.has_slave_agent == 1) begin    
    crc_param_req_agent.m_mon.vr_s_analysis_port.connect(scbd.s_mon_impparamreq); 
    crc_rsp_agent.m_mon.vr_s_analysis_port.connect(scbd.s_mon_imprsp); 
    end
    if (m_env_cfg.has_master_agent == 1) begin //pa vrv nije ovako al za sad nek stoji 
    apb_master_agent.m_mon.apb_mon_analysis_port.connect(scbd.m_ap);
    end	
endfunction : connect_phase
